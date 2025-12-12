import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/ongs/tela_perfil_ong.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/barra_inferior_e_superior.dart';
import '../widgets/barra_de_pesquisa.dart';
import '/telas/criar_evento.dart';
import '../services/event_service.dart';

class HomeOngs extends StatefulWidget {
  const HomeOngs({super.key});

  @override
  State<HomeOngs> createState() => _TelaListaDeEventosState();
}

class _TelaListaDeEventosState extends State<HomeOngs> {
  final SearchController searchController = SearchController();
  final ScrollController scrollController = ScrollController();
  final EventService _eventService = EventService();

  // Listas
  List<Event> _eventosFiltrados = [];
  List<Event> _todosEventos = [];

  // Filtros
  String filtroCidade = "";
  String filtroEstado = "";

  final Map<String, List<String>> cidadesPorEstado = {
    "SP": ["São Paulo", "Campinas", "Santos", "São José dos Campos"],
    "RJ": ["Rio de Janeiro", "Niterói", "Petrópolis", "Volta Redonda"],
    "SC": ["Florianópolis", "Joinville", "Blumenau", "Chapecó"],
    "DF": ["Brasília"],
    "MG": ["Belo Horizonte", "Uberlândia", "Contagem"],
  };

  List<String> estadosDisponiveis = ["SP", "RJ", "SC", "DF", "MG"];
  List<String> cidadesDisponiveis = [
    "São Paulo",
    "Rio de Janeiro",
    "Florianópolis",
    "Brasília",
    "Campinas",
    "Niterói",
    "Joinville",
    "Belo Horizonte",
  ];

  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_aplicarFiltroBusca);
    _carregarEventos();
  }

  @override
  void dispose() {
    searchController.removeListener(_aplicarFiltroBusca);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _carregarEventos() async {
    setState(() => _carregando = true);

    try {
      final eventos = await _eventService.getEvents(
        cidade: filtroCidade.isEmpty ? null : filtroCidade,
        estado: filtroEstado.isEmpty ? null : filtroEstado,
      );

      setState(() {
        _todosEventos = eventos;
        _eventosFiltrados = eventos;
        _carregando = false;
      });
    } catch (e) {
      print("Erro ao carregar eventos: $e");
      setState(() => _carregando = false);
    }
  }

  //atualizar cidades com base no estado selecionado
  void _atualizarCidadesDisponiveis() {
    if (filtroEstado.isNotEmpty && cidadesPorEstado.containsKey(filtroEstado)) {
      setState(() {
        cidadesDisponiveis = cidadesPorEstado[filtroEstado]!;

        // Se a cidade atual não está na lista do estado selecionado, limpa a cidade
        if (!cidadesDisponiveis.contains(filtroCidade)) {
          filtroCidade = "";
        }
      });
    } else {
      //nenhum estado selecionado = mostrar todas as cidades
      setState(() {
        cidadesDisponiveis = [];
        cidadesPorEstado.forEach((estado, cidades) {
          cidadesDisponiveis.addAll(cidades);
        });
        cidadesDisponiveis = cidadesDisponiveis.toSet().toList();
      });
    }
  }

  //atualizar estados com base na cidade selecionada
  void _atualizarEstadosDisponiveis() {
    if (filtroCidade.isNotEmpty) {
      List<String> estadosComEstaCidade = [];
      cidadesPorEstado.forEach((estado, cidades) {
        if (cidades.contains(filtroCidade)) {
          estadosComEstaCidade.add(estado);
        }
      });

      setState(() {
        estadosDisponiveis = estadosComEstaCidade;

        // Se o estado atual não está na lista de estados com esta cidade, limpa o estado
        if (!estadosDisponiveis.contains(filtroEstado)) {
          filtroEstado = estadosComEstaCidade.isNotEmpty
              ? estadosComEstaCidade.first
              : "";
        }
      });
    } else {
      //nenhuma cidade selecionada = mostrar todos os estados
      setState(() {
        estadosDisponiveis = cidadesPorEstado.keys.toList();
      });
    }
  }

  // Aplica filtro de busca localmente nos eventos já carregados
  void _aplicarFiltroBusca() {
    String busca = searchController.text.toLowerCase();

    setState(() {
      _eventosFiltrados = _todosEventos.where((evento) {
        final matchesBusca =
            busca.isEmpty ||
            evento.titulo.toLowerCase().contains(busca) ||
            evento.descricao.toLowerCase().contains(busca) ||
            evento.location.toLowerCase().contains(busca);

        return matchesBusca;
      }).toList();
    });
  }

  void _aplicarFiltroLocalizacao() {
    _carregarEventos();
  }

  //estado selecionado no dropdown
  void _onEstadoChanged(String? novoEstado) {
    setState(() {
      filtroEstado = novoEstado ?? "";
    });
    _atualizarCidadesDisponiveis();
    _aplicarFiltroLocalizacao();
  }

  //cidade selecionada no dropdown
  void _onCidadeChanged(String? novaCidade) {
    setState(() {
      filtroCidade = novaCidade ?? "";
    });
    _atualizarEstadosDisponiveis();
    _aplicarFiltroLocalizacao();
  }

  void _limparFiltros() {
    setState(() {
      filtroCidade = "";
      filtroEstado = "";
      searchController.clear();
    });

    _atualizarCidadesDisponiveis();
    _atualizarEstadosDisponiveis();
    _carregarEventos();
  }

  List<String> _gerarSugestoes(String query) {
    if (query.isEmpty) return [];

    final queryLower = query.toLowerCase();
    final sugestoes = <String>{};

    for (var evento in _todosEventos) {
      if (evento.titulo.toLowerCase().contains(queryLower)) {
        sugestoes.add(evento.titulo);
      }
      if (evento.location.toLowerCase().contains(queryLower)) {
        sugestoes.add(evento.location);
      }
    }

    return sugestoes.toList();
  }

  void scrollRight() {
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.offset;

      if (currentScroll < maxScroll) {
        scrollController.animateTo(
          currentScroll + 300,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperiorBar(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Minhas campanhas ativas",
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF1E5AA8),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // BARRA DE PESQUISA COM SUGESTÕES
            SearchAnchor(
              searchController: searchController,
              builder: (context, controller) {
                return BarraDePesquisa(
                  onTap: () => controller.openView(),
                  onChanged: (_) {},
                );
              },
              suggestionsBuilder: (context, controller) {
                final query = controller.text;
                final sugestoes = _gerarSugestoes(query);

                if (sugestoes.isEmpty) {
                  return [
                    const ListTile(title: Text("Nenhuma sugestão encontrada")),
                  ];
                }

                return sugestoes.map((sugestao) {
                  return ListTile(
                    title: Text(sugestao),
                    onTap: () {
                      controller.text = sugestao;
                      controller.closeView(sugestao);
                      _aplicarFiltroBusca();
                    },
                  );
                }).toList();
              },
            ),

            const SizedBox(height: 16),

            // Filtros - LINKADOS
            Row(
              children: [
                // DROPDOWN DE ESTADO
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Estado",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    initialValue: filtroEstado.isEmpty ? null : filtroEstado,
                    items: [
                      const DropdownMenuItem(
                        value: "",
                        child: Text("Todos os estados"),
                      ),
                      ...estadosDisponiveis.map(
                        (e) => DropdownMenuItem(value: e, child: Text(e)),
                      ),
                    ],
                    onChanged: _onEstadoChanged,
                  ),
                ),

                const SizedBox(width: 12),

                // DROPDOWN DE CIDADE
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Cidade",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    initialValue: filtroCidade.isEmpty ? null : filtroCidade,
                    items: [
                      const DropdownMenuItem(
                        value: "",
                        child: Text("Todas as cidades"),
                      ),
                      ...cidadesDisponiveis.map(
                        (c) => DropdownMenuItem(value: c, child: Text(c)),
                      ),
                    ],
                    onChanged: _onCidadeChanged,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Botão para limpar filtros
            if (filtroCidade.isNotEmpty ||
                filtroEstado.isNotEmpty ||
                searchController.text.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text("Limpar filtros"),
                  onPressed: _limparFiltros,
                ),
              ),

            const SizedBox(height: 16),

            // CARROSSEL eventos
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _eventosFiltrados.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum evento encontrado",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          controller: scrollController,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _eventosFiltrados.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: EventCard(event: e, onTap: () {}),
                              );
                            }).toList(),
                          ),
                        ),

                        // seta flutuante (só aparece se houver mais eventos para rolar)
                        if (_eventosFiltrados.length > 2 &&
                            scrollController.hasClients)
                          Positioned(
                            right: 0,
                            top: MediaQuery.of(context).size.height * 0.2,
                            child: GestureDetector(
                              onTap: scrollRight,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2DB38A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),

      // Botão criar evento
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFFDF8F2C),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CriarEventoTela(),
                ),
              );
            },
            child: const Icon(Icons.add, size: 30),
          ),
          const SizedBox(height: 6),
          const Text(
            "CRIAR EVENTO",
            style: TextStyle(
              color: Color(0xFFDF8F2C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        iconSelecionado: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaPerfilONG()),
            );
          }
        },
      ),
    );
  }
}
