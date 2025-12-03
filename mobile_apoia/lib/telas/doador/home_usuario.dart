import 'package:flutter/material.dart';
//import '../../services/event_service.dart'; --necessita o API primeiro
import 'package:mobile_apoia/models/event.dart';
import 'package:mobile_apoia/widgets/event_card.dart';
import 'package:mobile_apoia/widgets/barra_inferior_superior_tela_doador.dart';
import 'package:mobile_apoia/widgets/barra_de_pesquisa.dart';

class HomeUsuario extends StatefulWidget {
  const HomeUsuario({super.key});

  @override
  State<HomeUsuario> createState() => _TelaListaDeEventosState();
}

class _TelaListaDeEventosState extends State<HomeUsuario> {
  //futura conexão django
  // late Future<List<Event>> futureEventos;

  // LISTA PARA TESTES
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperiorBarDoador(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const BarraDePesquisa(),
            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: eventosMock
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
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 0,
        onTap: (index) {
          print("Ícone clicado: $index");
        },
      ),
    );
  }
}
