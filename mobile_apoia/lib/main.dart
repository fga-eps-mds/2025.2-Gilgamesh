import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/doador/visualizar_evento_doador.dart'; 
import 'package:mobile_apoia/models/event.dart'; 

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Event mockEvent = Event(

      id: 1, 
      titulo: 'Campanha de Doação de Agasalhos',
      descricao: 'Participe da nossa campanha de inverno! Sua doação aquecerá muitas famílias. Doe roupas em bom estado.',
      
      
      date: DateTime(2025, 12, 15), 
      
      location: 'Ponte Alta, Gama - DF',
      totalVagas: 50, 
      participantes: 10,
      ongId: 1,
    );
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apoia+',
      home: DetalhesDoadorTela(event: mockEvent), 
    );
  }
} //main para ver visualizar evento