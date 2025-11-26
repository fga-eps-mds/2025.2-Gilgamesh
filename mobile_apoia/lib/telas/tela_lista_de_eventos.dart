import 'package:flutter/material.dart';
//import '../../services/event_service.dart'; --necessita o API primeiro
import '../models/event.dart';
import '../widgets/event_card.dart';
import '../widgets/barra_inferior_e_superior.dart';
import '/telas/criar_evento.dart';

class TelaListaDeEventos extends StatefulWidget {
  const TelaListaDeEventos({super.key});

  @override
  State<TelaListaDeEventos> createState() => _TelaListaDeEventosState();
}

class _TelaListaDeEventosState extends State<TelaListaDeEventos> {
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
      appBar: const SuperiorBar(),

      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
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

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFFDF8F2C),
            onPressed: () {
              // Lógica de navegação para a tela CriarEventoTela
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CriarEventoTela()),
              );
              print("Criar novo evento");
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
          print("Ícone clicado: $index");
        },
      ),
    );
  }
}