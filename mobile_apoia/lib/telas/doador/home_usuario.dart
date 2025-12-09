
import 'package:flutter/material.dart';
//import '../../services/event_service.dart'; --necessita o API primeiro
import 'package:mobile_apoia/models/event.dart';
import 'package:mobile_apoia/telas/doador/tela_perfil_usuario.dart';
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
  final ScrollController scrollController = ScrollController();
  //futura conexão django
  // late Future<List<Event>> futureEventos;

  final List<Event> eventosMock = [
    Event(
      id: 1,
      titulo: "Campanha de Doação",
      descricao: "Ajude famílias carentes",
      date: DateTime(2025, 2, 12),
      location: "São Paulo",
      totalVagas: 50,
      participantes: 18,
      ongId: 101,
    ),
    Event(
      id: 2,
      titulo: "Arrecadação de Roupas",
      descricao: "Doe roupas e ajude",
      date: DateTime(2025, 3, 5),
      location: "Rio de Janeiro",
      totalVagas: 80,
      participantes: 32,
      ongId: 102,
    ),
    Event(
      id: 3,
      titulo: "Mutirão Ambiental",
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
      appBar: const SuperiorBarDoador(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Campanhas ativas",
              style: TextStyle(
                fontSize: 22,
                color: Color(0xFF1E5AA8),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            //barra de pesquisa
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
                        return evento.titulo.toLowerCase().contains(txt) ||
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
                              onTap: () => print("Clicou em ${e.titulo}"),
                            ),
                          )
                          .toList(),
                    ),
                  ),

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
