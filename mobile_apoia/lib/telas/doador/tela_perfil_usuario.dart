import 'package:flutter/material.dart';
// Importação da barra de navegação da ONG )
import '../../widgets/barra_inferior_e_superior.dart'; 
// Importação da barra de navegação do Doador 
import '../../widgets/barra_inferior_superior_tela_doador.dart'; 
import '../../widgets/logo.dart';
import '../../services/auth_service.dart';
import '../../telas/acesso/tela_login.dart'; 

class TelaPerfilUsuario extends StatefulWidget {
  final bool isOng; 

  const TelaPerfilUsuario({super.key, required this.isOng});

  @override
  State<TelaPerfilUsuario> createState() => _TelaPerfilUsuarioState();
}

class _TelaPerfilUsuarioState extends State<TelaPerfilUsuario> {
  
  int _selectedIndex = 1; 
  final AuthService _authService = AuthService(); 


  String _nomeUsuario = "Carregando...";
  String _email = "...";
  // String _tipo = ""; 

  
  Color get corPrincipal => widget.isOng ? const Color(0xFFFF9900) : const Color(0xFF007AFF);

  @override
  void initState() {
    super.initState();
    
    if (widget.isOng) {
       _selectedIndex = 2; 
    } else {
       _selectedIndex = 1; 
    }
    _carregarDados(); 
  }

  
  void _carregarDados() async {
    final dados = await _authService.getUsuarioSalvo();
    
    if (dados != null) {
      setState(() {
        _nomeUsuario = dados['nome'] ?? dados['username'] ?? 'Usuário';
        _email = dados['email'] ?? 'Sem email';
      });
    } else {
      setState(() {
        _nomeUsuario = "Visitante";
      });
    }
  }

  void _sair() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const TelaLogin()),
      (route) => false,
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, 
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black87, size: 30),
        title: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color ?? Colors.black54,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define qual Widget de Barra de Navegação será usado
    final Widget navBar = widget.isOng 
      ? BottomNavBar( 
          iconSelecionado: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
        )
      : BottomNavBarDoador( 
          iconSelecionado: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
        );

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
                  child: Icon(Icons.person, size: 60, color: corPrincipal),
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
                Text(_email, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),

          // MENU
          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.check_circle_outline,
                    text: widget.isOng ? "Eventos Cadastrados" : "Eventos Confirmados",
                    onTap: () {
                      print("Eventos");
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.edit_square,
                    text: "Editar Dados",
                    onTap: () {
                        print("Editar");
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.exit_to_app, 
                    text: "Sair da Conta",
                    color: Colors.red, 
                    onTap: _sair,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: navBar, 
    );
  }
}