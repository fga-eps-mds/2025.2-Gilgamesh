import 'package:flutter/material.dart';
import '../widgets/logo.dart'; 
import '../widgets/cores.dart'; 

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const String missaoTexto = 'Nossa missão é desenvolver um ecossistema de doações transparente e eficiente, conectando doadores a instituições de forma ágil e segura.';
  static const String desenvolvidoPorTexto = 
    'PROJETO CRIADO PELA EQUIPE DO CURSO\n'
    'DE ENGENHARIA DE SOFTWARE —\n'
    'DISCIPLINA DE MÉTODOS DE\n'
    'DESENVOLVIMENTO DE SOFTWARE.\n'
    'FACULDADE DE CIÊNCIA E TECNOLOGIA -\n'
    'UNIVERSIDADE DE BRASILIA.\n'
    'ANO: 2025.';

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = AppColors.primary; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor, 
        toolbarHeight: 80.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'SOBRE O APP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0079A6),
              ),
            ),
            const SizedBox(height: 20),
            
            const Logo(height: 100), 
            
            const SizedBox(height: 10),
            const Text(
              'apola+',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'O APOIA+ É ...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            
            const SizedBox(height: 40),
            
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      const Icon(Icons.track_changes, size: 24, color: Colors.black87), 
                      const SizedBox(width: 10),
                      const Text(
                        'NOSSA MISSÃO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0079A6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    missaoTexto,
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      const Icon(Icons.groups, size: 24, color: Colors.black87), 
                      const SizedBox(width: 10),
                      const Text(
                        'DESENVOLVIDO POR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0079A6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 34.0),
                    child: Text(
                      desenvolvidoPorTexto,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 80), 
          ],
        ),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          // Lógica de navegação
        },
      ),
    );
  }
}
