import 'package:flutter/material.dart';
//import '../../services/event_service.dart'; --necessita o API primeiro
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/barra_inferior_e_superior.dart';
import '../widgets/barra_de_pesquisa.dart';
import '/telas/criar_evento.dart';

class HomeOngs extends StatefulWidget {
  const HomeOngs({super.key});

  @override
  State<HomeOngs> createState() => _TelaListaDeEventosState();
}

class _TelaListaDeEventosState extends State<HomeOngs> {
  final SearchController searchController = SearchController();
  final ScrollController scrollController =
      ScrollController(); //necessario para seta do carrossel funcionar
  //futura conexão django
  // late Future<List<Event>> futureEventos;

  final List<Event> eventosMock = [
    Event(
      id: 1,
      nome: "Campanha de Doação",
      descricao: "Ajude famílias carentes",
      date: DateTime(2025, 2, 12),
      location: "São Paulo",
      totalVagas: 50,
      participantes: 18,
      ongId: 101,
    ),
    Event(
      id: 2,
      nome: "Arrecadação de Roupas",
      descricao: "Doe roupas e ajude",
      date: DateTime(2025, 3, 5),
      location: "Rio de Janeiro",
      totalVagas: 80,
      participantes: 32,
      ongId: 102,
    ),
    Event(
      id: 3,
      nome: "Mutirão Ambiental",
      descricao: "Limpeza da praia estadual",
      date: DateTime(2025, 4, 20),
      location: "Florianópolis",
      totalVagas: 120,
      participantes: 67,
      ongId: 103,
    ),
  ];

  List<Event> eventosFiltrados = [];

  @override
  void initState() {
    super.initState();
    eventosFiltrados = eventosMock;
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

            //barra de pesquisa (com autocomplete)
            SearchAnchor(
              searchController: searchController,
              builder: (context, controller) {
                return BarraDePesquisa(
                  onTap: () => controller.openView(),
                  onChanged: (value) {
                    controller.text = value;

                    setState(() {
                      final txt = value.toLowerCase();

                      eventosFiltrados = eventosMock.where((evento) {
                        return evento.nome.toLowerCase().contains(txt) ||
                            evento.descricao.toLowerCase().contains(txt) ||
                            evento.location.toLowerCase().contains(txt);
                      }).toList();
                    });
                  },
                );
              },
              suggestionsBuilder: (context, controller) {
                final txt = controller.text.toLowerCase();

                final sugestoes = eventosMock.where((evento) {
                  return evento.nome.toLowerCase().contains(txt);
                }).toList();

                if (sugestoes.isEmpty) {
                  return const [
                    ListTile(title: Text("Nenhum evento encontrado")),
                  ];
                }

                return sugestoes.map((evento) {
                  return ListTile(
                    title: Text(evento.nome),
                    onTap: () {
                      controller.closeView(evento.nome);
                      setState(() => eventosFiltrados = [evento]);
                    },
                  );
                }).toList();
              },
            ),

            const SizedBox(height: 16),

            //carrossel de eventos
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: eventosFiltrados
                          .map(
                            (e) => EventCard(
                              event: e,
                              onTap: () {
                                print("Clicou no evento: ${e.nome}");
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  // Seta flutuante
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

      //botão criar evento
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

      bottomNavigationBar: BottomNavBar(iconSelecionado: 0, onTap: (index) {}),
    );
  }
}
