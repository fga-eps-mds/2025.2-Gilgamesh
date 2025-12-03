import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import '../telas/home_ongs.dart';

//Barra inferior de navegação
class BottomNavBar extends StatelessWidget {
  final int iconSelecionado;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.iconSelecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: 75,
      decoration: const BoxDecoration(color: Color(0xFFE2952A)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: iconSelecionado == 0 ? Colors.white : Colors.white70,
              size: 28,
            ),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeOngs()),
            ),
          ),

          IconButton(
            icon: Icon(
              Icons.person,
              color: iconSelecionado == 2 ? Colors.white : Colors.white70,
              size: 28,
            ),
            onPressed: () => onTap(2), //tela do perfil ong aqui
          ),
        ],
      ),
    );
  }
}

//Barra superior
class SuperiorBar extends StatelessWidget implements PreferredSizeWidget {
  const SuperiorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFE2952A),
      elevation: 0,
      centerTitle: true,
      title: Logo(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
