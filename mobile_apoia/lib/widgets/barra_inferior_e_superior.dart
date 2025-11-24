import 'package:flutter/material.dart';

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
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: iconSelecionado == 1 ? Colors.white : Colors.white70,
              size: 28,
            ),
            onPressed: () => onTap(1),
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: iconSelecionado == 2 ? Colors.white : Colors.white70,
              size: 28,
            ),
            onPressed: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

//Barra superior
class SuperiorBar extends StatelessWidget {
  const SuperiorBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFE2952A),
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Apoia+",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
