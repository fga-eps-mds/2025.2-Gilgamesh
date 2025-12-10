import 'package:flutter/material.dart';
import '../../widgets/barra_inferior_e_superior.dart';
import '../../widgets/logo.dart';
import '../../services/auth_service.dart';
import '../../telas/acesso/tela_login.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../doador/editar_dados_usuario.dart';

class TelaPerfilONG extends StatefulWidget {
  const TelaPerfilONG({super.key});

  @override
  State<TelaPerfilONG> createState() => _TelaPerfilONGState();
}

class _TelaPerfilONGState extends State<TelaPerfilONG> {
  int _selectedIndex = 1;
  final AuthService _authService = AuthService();

  String _nomeUsuario = "Carregando...";
  String _email = "...";
  //String _tipo = "";

  Color get corPrincipal => AppColors.laranjaApoia;

  @override
  void initState() {
    super.initState();
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
        _nomeUsuario = "ONG";
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
                    fontSize: 18,
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
                    text: "Seus Eventos",
                    onTap: () {
                      print("Eventos");
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.edit_square,
                    text: "Editar Dados",
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                       MaterialPageRoute(builder:   (_) => const EditarDadosUsuario()));
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

      bottomNavigationBar: BottomNavBar(
        iconSelecionado: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
