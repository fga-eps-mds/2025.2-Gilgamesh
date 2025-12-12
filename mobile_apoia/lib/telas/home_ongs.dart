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

  //Lista Real
  List<Event> _eventosFiltrados = [];
  List<Event> _todosEventos = [];

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
    carregarEventos();
  }

  Future<void> carregarEventos() async {
    final service = EventService();
    final eventos = await service.getEvents(
      cidade: filtroCidade,
      estado: filtroEstado,
    );

    setState(() {
      _todosEventos = eventos;
      _eventosFiltrados = eventos;
    });
  }

  void filtrarBusca(String value) {
    value = value.toLowerCase();
    setState(() {
      _eventosFiltrados = _todosEventos.where((evento) {
        return evento.titulo.toLowerCase().contains(value) ||
            evento.descricao.toLowerCase().contains(value) ||
            evento.location.toLowerCase().contains(value);
      }).toList();
    });
  }

  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 250,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
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

            // BARRA DE PESQUISA
            SearchAnchor(
              searchController: searchController,
              builder: (context, controller) {
                return BarraDePesquisa(
                  onTap: () => controller.openView(),
                  onChanged: filtrarBusca,
                );
              },
              suggestionsBuilder: (context, controller) {
                final txt = controller.text.toLowerCase();

                final sugestoes = _todosEventos.where((evento) {
                  return evento.titulo.toLowerCase().contains(txt);
                }).toList();

                if (sugestoes.isEmpty) {
                  return const [
                    ListTile(title: Text("Nenhum evento encontrado")),
                  ];
                }

                return sugestoes.map((evento) {
                  return ListTile(
                    title: Text(evento.titulo),
                    onTap: () {
                      controller.closeView(evento.titulo);
                      setState(() => _eventosFiltrados = [evento]);
                    },
                  );
                }).toList();
              },
            ),

            const SizedBox(height: 16),

            // Filtros por Cidade e Estado
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: filtroCidade.isEmpty ? null : filtroCidade,
                    decoration: const InputDecoration(
                      labelText: "Filtrar por Cidade",
                    ),
                    items: cidades.map((city) {
                      return DropdownMenuItem(value: city, child: Text(city));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => filtroCidade = value ?? "");
                      carregarEventos();
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: filtroEstado.isEmpty ? null : filtroEstado,
                    decoration: const InputDecoration(labelText: "Estado"),
                    items: estados.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                    onChanged: (value) {
                      setState(() => filtroEstado = value ?? "");
                      carregarEventos();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // CARROSSEL eventos
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _eventosFiltrados.map((e) {
                        return EventCard(event: e, onTap: () {});
                      }).toList(),
                    ),
                  ),

                  //seta flutuante
                  Positioned(
                    right: 0,
                    top: 90,
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

      //Botão criar evento
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
