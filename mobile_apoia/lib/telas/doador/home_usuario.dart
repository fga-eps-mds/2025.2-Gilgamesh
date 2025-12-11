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

class HomeUsuario extends StatefulWidget {
  const HomeUsuario({super.key});

  @override
  State<HomeUsuario> createState() => _TelaListaDeEventosState();
}

class _TelaListaDeEventosState extends State<HomeUsuario> {
  final SearchController searchController = SearchController();

  final EventService _eventService = EventService();
  final AuthService _authService = AuthService();

  // Listas Reais
  List<Event> _todosEventos = [];
  List<Event> _eventosFiltrados = [];
  List<Ong> _todasOngs = []; //  Lista real de ONGs

  bool _carregando = true;

  // Filtros
  String filtroCidade = "";
  String filtroEstado = "";

  final List<String> cidades = [
    "São Paulo",
    "Rio de Janeiro",
    "Florianópolis",
    "Brasília",
  ];

  final List<String> estados = ["SP", "RJ", "SC", "DF"];

  @override
  void initState() {
    super.initState();
    _buscarDadosDoBanco();
  }

  // Busca Eventos E ONGs ao mesmo tempo
  Future<void> _buscarDadosDoBanco() async {
    print(">>> [DEBUG] 1. Iniciando carregamento...");
    setState(() => _carregando = true);

    try {
      print(">>> [DEBUG] 2. Chamando API de Eventos...");
      final resultados = await Future.wait([
        _eventService.getEvents(
          cidade: filtroCidade,
          estado: filtroEstado,
        ), // índice 0
        _authService.getOngs(), // índice 1
      ]);

      setState(() {
        _todosEventos = resultados[0] as List<Event>;
        _eventosFiltrados = _todosEventos;

        _todasOngs = resultados[1] as List<Ong>; // <--- Preenche as ONGs

        _carregando = false;
      });
    } catch (e) {
      print("Erro ao carregar dados: $e");
      setState(() => _carregando = false);
    }
  }

  void aplicarBusca(String valor) {
    valor = valor.toLowerCase();

    setState(() {
      _eventosFiltrados = _todosEventos.where((evento) {
        return evento.titulo.toLowerCase().contains(valor) ||
            evento.location.toLowerCase().contains(valor);
      }).toList();
    });
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

              // BARRA DE PESQUISA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchAnchor(
                  searchController: searchController,
                  builder: (context, controller) {
                    return BarraDePesquisa(
                      onTap: () => controller.openView(),
                      onChanged: aplicarBusca,
                    );
                  },
                  suggestionsBuilder: (context, controller) => [],
                ),
              ),

              const SizedBox(height: 10),

              // FILTROS (Cidade + Estado)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Cidade"),
                        initialValue: filtroCidade.isEmpty
                            ? null
                            : filtroCidade,
                        items: cidades
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => filtroCidade = value ?? "");
                          _buscarDadosDoBanco();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Estado"),
                        initialValue: filtroEstado.isEmpty
                            ? null
                            : filtroEstado,
                        items: estados
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => filtroEstado = value ?? "");
                          _buscarDadosDoBanco();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Carrosel de ongs
              _buildSecaoTitulo("ONGs Parceiras"),

              SizedBox(
                height: 110,
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : _todasOngs.isEmpty
                    ? const Center(child: Text("Nenhuma ONG encontrada."))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _todasOngs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final ong = _todasOngs[index];
                          return Column(
                            children: [
                              // Avatar da ONG
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(
                                    0.2,
                                  ), // Cor padrão
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 2,
                                  ),
                                ),
                                // Como não temos foto no banco, usamos a inicial do nome
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
                          );
                        },
                      ),
              ),

              // carrosel de eventos
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
              MaterialPageRoute(builder: (context) => TelaPerfilUsuario()),
            );
          }
        },
      ),
    );
  }
}
