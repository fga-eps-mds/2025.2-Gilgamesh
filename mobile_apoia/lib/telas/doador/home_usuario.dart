import 'package:flutter/material.dart';
import 'package:mobile_apoia/models/event.dart';
import 'package:mobile_apoia/models/ong.dart';
import 'package:mobile_apoia/services/event_service.dart';
import 'package:mobile_apoia/services/auth_service.dart';
import 'package:mobile_apoia/telas/doador/tela_perfil_usuario.dart';
import 'package:mobile_apoia/telas/doador/visualizar_evento_doador.dart';
import 'package:mobile_apoia/widgets/event_card.dart';
import 'package:mobile_apoia/widgets/barra_inferior_superior_tela_doador.dart';
import 'package:mobile_apoia/widgets/barra_de_pesquisa.dart';
import 'package:mobile_apoia/telas/doador/perfil_ong_tela.dart';

class HomeUsuario extends StatefulWidget {
  const HomeUsuario({super.key});

  @override
  State<HomeUsuario> createState() => _HomeUsuarioState();
}

class _HomeUsuarioState extends State<HomeUsuario> {
  final SearchController searchController = SearchController();
  final EventService _eventService = EventService();
  final AuthService _authService = AuthService();

  // Listas Reais
  List<Event> _todosEventos = [];
  List<Event> _eventosFiltrados = [];
  List<Ong> _todasOngs = [];
  List<Ong> _ongsFiltradas = [];

  bool _carregando = true;

  // Filtros
  String filtroCidade = "";
  String filtroEstado = "";

  final Map<String, List<String>> cidadesPorEstado = {
    "AC": ["Rio Branco", "Cruzeiro do Sul"],
    "AL": ["Maceió", "Arapiraca"],
    "AP": ["Macapá", "Santana"],
    "AM": ["Manaus", "Parintins"],
    "BA": ["Salvador", "Feira de Santana"],
    "CE": ["Fortaleza", "Juazeiro do Norte"],
    "DF": ["Brasília", "Ceilândia"],
    "ES": ["Vitória", "Vila Velha"],
    "GO": ["Goiânia", "Anápolis"],
    "MA": ["São Luís", "Imperatriz"],
    "MT": ["Cuiabá", "Várzea Grande"],
    "MS": ["Campo Grande", "Dourados"],
    "MG": ["Belo Horizonte", "Uberlândia"],
    "PA": ["Belém", "Ananindeua"],
    "PB": ["João Pessoa", "Campina Grande"],
    "PR": ["Curitiba", "Londrina"],
    "PE": ["Recife", "Olinda"],
    "PI": ["Teresina", "Parnaíba"],
    "RJ": ["Rio de Janeiro", "Niterói"],
    "RN": ["Natal", "Mossoró"],
    "RS": ["Porto Alegre", "Caxias do Sul"],
    "RO": ["Porto Velho", "Ji-Paraná"],
    "RR": ["Boa Vista", "Rorainópolis"],
    "SC": ["Florianópolis", "Joinville"],
    "SP": ["São Paulo", "Campinas"],
    "SE": ["Aracaju", "Nossa Senhora do Socorro"],
    "TO": ["Palmas", "Araguaína"],
  };

  List<String> estadosDisponiveis = [
    "AC",
    "AL",
    "AP",
    "AM",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RJ",
    "RN",
    "RS",
    "RO",
    "RR",
    "SC",
    "SP",
    "SE",
    "TO",
  ];

  List<String> cidadesDisponiveis = [
    "Rio Branco",
    "Cruzeiro do Sul",
    "Maceió",
    "Arapiraca",
    "Macapá",
    "Santana",
    "Manaus",
    "Parintins",
    "Salvador",
    "Feira de Santana",
    "Fortaleza",
    "Juazeiro do Norte",
    "Brasília",
    "Ceilândia",
    "Vitória",
    "Vila Velha",
    "Goiânia",
    "Anápolis",
    "São Luís",
    "Imperatriz",
    "Cuiabá",
    "Várzea Grande",
    "Campo Grande",
    "Dourados",
    "Belo Horizonte",
    "Uberlândia",
    "Belém",
    "Ananindeua",
    "João Pessoa",
    "Campina Grande",
    "Curitiba",
    "Londrina",
    "Recife",
    "Olinda",
    "Teresina",
    "Parnaíba",
    "Rio de Janeiro",
    "Niterói",
    "Natal",
    "Mossoró",
    "Porto Alegre",
    "Caxias do Sul",
    "Porto Velho",
    "Ji-Paraná",
    "Boa Vista",
    "Rorainópolis",
    "Florianópolis",
    "Joinville",
    "São Paulo",
    "Campinas",
    "Aracaju",
    "Nossa Senhora do Socorro",
    "Palmas",
    "Araguaína",
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _buscarDadosDoBanco();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    aplicarFiltros();
  }

  //atualiza cidades com base no estado selecionado
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
      //nenhum estado selecionado = mostra todas as cidades
      setState(() {
        cidadesDisponiveis = [];
        cidadesPorEstado.forEach((estado, cidades) {
          cidadesDisponiveis.addAll(cidades);
        });
        cidadesDisponiveis = cidadesDisponiveis.toSet().toList();
      });
    }
  }

  //atualiza estados com base na cidade selecionada
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

  // Busca Eventos E ONGs ao mesmo tempo
  Future<void> _buscarDadosDoBanco() async {
    print(">>> [DEBUG] Iniciando carregamento...");
    setState(() => _carregando = true);

    try {
      final resultados = await Future.wait([
        _eventService.getEvents(
          cidade: filtroCidade.isEmpty ? null : filtroCidade,
          estado: filtroEstado.isEmpty ? null : filtroEstado,
        ),
        _authService.getOngs(),
      ]);

      setState(() {
        _todosEventos = resultados[0] as List<Event>;
        _todasOngs = resultados[1] as List<Ong>;

        aplicarFiltros();

        _carregando = false;
      });
    } catch (e) {
      print("Erro ao carregar dados: $e");
      setState(() => _carregando = false);
    }
  }

  void aplicarFiltros() {
    String busca = searchController.text.toLowerCase();

    // Filtra eventos
    List<Event> eventosTemp = _todosEventos;

    // Aplica filtro de busca local
    if (busca.isNotEmpty) {
      eventosTemp = eventosTemp.where((evento) {
        return evento.titulo.toLowerCase().contains(busca) ||
            evento.location.toLowerCase().contains(busca);
      }).toList();
    }

    // Filtra ONGs
    List<Ong> ongsTemp = _todasOngs;
    if (busca.isNotEmpty) {
      ongsTemp = ongsTemp.where((ong) {
        return ong.nome.toLowerCase().contains(busca);
      }).toList();
    }

    setState(() {
      _eventosFiltrados = eventosTemp;
      _ongsFiltradas = ongsTemp;
    });
  }

  void _aplicarFiltroLocalizacao() {
    _buscarDadosDoBanco();
  }

  //estado selecionado no dropdown
  void _onEstadoChanged(String? novoEstado) {
    setState(() {
      filtroEstado = novoEstado ?? "";
    });
    _atualizarCidadesDisponiveis();
    _aplicarFiltroLocalizacao();
  }

  //cidade selecionado no dropdown
  void _onCidadeChanged(String? novaCidade) {
    setState(() {
      filtroCidade = novaCidade ?? "";
    });
    _atualizarEstadosDisponiveis();
    _aplicarFiltroLocalizacao();
  }

  Widget _buildSecaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 20,
          color: Color(0xFF1E5AA8),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<String> _gerarSugestoes(String query) {
    if (query.isEmpty) return [];

    final queryLower = query.toLowerCase();
    final sugestoes = <String>{};

    for (var evento in _todosEventos) {
      if (evento.titulo.toLowerCase().contains(queryLower)) {
        sugestoes.add(evento.titulo);
      }
    }

    for (var ong in _todasOngs) {
      if (ong.nome.toLowerCase().contains(queryLower)) {
        sugestoes.add(ong.nome);
      }
    }

    for (var evento in _todosEventos) {
      if (evento.location.toLowerCase().contains(queryLower)) {
        sugestoes.add(evento.location);
      }
    }

    return sugestoes.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperiorBarDoador(),

      body: RefreshIndicator(
        onRefresh: _buscarDadosDoBanco,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Explorar",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF1E5AA8),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // BARRA DE PESQUISA COM SUGESTÕES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchAnchor(
                  searchController: searchController,
                  builder: (context, controller) {
                    return BarraDePesquisa(
                      onTap: () => controller.openView(),
                      onChanged: (value) {},
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    final query = controller.text;
                    final sugestoes = _gerarSugestoes(query);

                    if (sugestoes.isEmpty) {
                      return [
                        const ListTile(
                          title: Text("Nenhuma sugestão encontrada"),
                        ),
                      ];
                    }

                    return sugestoes.map((sugestao) {
                      return ListTile(
                        title: Text(sugestao),
                        onTap: () {
                          controller.text = sugestao;
                          controller.closeView(sugestao);
                          aplicarFiltros();
                        },
                      );
                    }).toList();
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Filtros Linkados
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
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
                        initialValue: filtroEstado.isEmpty
                            ? null
                            : filtroEstado,
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
                        initialValue: filtroCidade.isEmpty
                            ? null
                            : filtroCidade,
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
              ),

              const SizedBox(height: 10),

              // Botão para limpar filtros
              if (filtroCidade.isNotEmpty || filtroEstado.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text("Limpar filtros"),
                      onPressed: () {
                        setState(() {
                          filtroCidade = "";
                          filtroEstado = "";
                          searchController.clear();
                        });
                        _atualizarCidadesDisponiveis();
                        _atualizarEstadosDisponiveis();
                        _aplicarFiltroLocalizacao();
                      },
                    ),
                  ),
                ),

              // Carrosel de ongs
              _buildSecaoTitulo("ONGs Parceiras"),

              SizedBox(
                height: 110,
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : _ongsFiltradas.isEmpty
                    ? const Center(child: Text("Nenhuma ONG encontrada."))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _ongsFiltradas.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final ong = _ongsFiltradas[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerfilOngTela(ong: ong),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      ong.nome.isNotEmpty
                                          ? ong.nome[0].toUpperCase()
                                          : "?",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    ong.nome,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Carrosel eventos
              _buildSecaoTitulo("Campanhas Ativas"),

              SizedBox(
                height: 280,
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : _eventosFiltrados.isEmpty
                    ? const Center(child: Text("Nenhum evento disponível."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _eventosFiltrados.length,
                        itemBuilder: (context, index) {
                          final evento = _eventosFiltrados[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: SizedBox(
                              width: 280,
                              child: EventCard(
                                event: evento,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalhesDoadorTela(event: evento),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TelaPerfilUsuario(),
              ),
            );
          }
        },
      ),
    );
  }
}
