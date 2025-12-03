import 'package:flutter/material.dart';
import '../../widgets/barra_inferior_e_superior.dart';
import '../../widgets/logo.dart'; 

class TelaPerfilUsuario extends StatefulWidget {
  // define se a tela abre no modo ONG (Laranja) ou Doador (Azul)
  final bool isOng; 

  const TelaPerfilUsuario({super.key, required this.isOng});

  @override
  State<TelaPerfilUsuario> createState() => _TelaPerfilUsuarioState();
}

class _TelaPerfilUsuarioState extends State<TelaPerfilUsuario> {
  int _selectedIndex = 2; 

  Color get corPrincipal => widget.isOng ? const Color(0xFFFF9900) : const Color(0xFF007AFF);
  
  final String _nomeUsuario = "NOME DO USUÁRIO";
  final String _telefone = "(61) 99999-9999";
  final String _email = "USUARIO@GMAIL.COM";
  final String _local = "CIDADE-DF";

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, 
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87, size: 30),
        title: Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corPrincipal, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Logo(), 
        centerTitle: true,
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                 BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3), 
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                Text(
                  _nomeUsuario,
                  style: TextStyle(
                    color: corPrincipal, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 18
                  ),
                ),
                const SizedBox(height: 5),
                Text(_telefone, style: const TextStyle(color: Colors.black54)),
                Text(_email, style: const TextStyle(color: Colors.black54)),
                Text(_local, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.check_circle_outline,
                    text: "Eventos Cadastrados",
                    onTap: () {
                      print("Navegar para Meus Eventos");
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.edit_square,
                    text: "Editar Dados",
                    onTap: () {
                       print("Navegar para Edição");
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    text: "Sobre o App",
                    onTap: () {
                       print("Navegar para Sobre");
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        iconSelecionado: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}