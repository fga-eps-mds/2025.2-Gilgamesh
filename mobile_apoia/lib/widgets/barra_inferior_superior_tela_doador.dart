import 'package:flutter/material.dart';
import 'logo.dart';

// Cores (Tema Doador)
const Color corAzulPrincipal = Color(0xFF007AFF);
const Color corLaranjaONG = Color(0xFFFF9900);

//  BARRA SUPERIOR
class SuperiorBarDoador extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const SuperiorBarDoador({super.key, this.showBackButton = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: corAzulPrincipal,
      elevation: 0,

      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,

      title: const Logo(),
      centerTitle: true,

      automaticallyImplyLeading: false,
    );
  }
}

class BottomNavBarDoador extends StatelessWidget {
  final int iconSelecionado;
  final ValueChanged<int> onTap;

  const BottomNavBarDoador({
    super.key,
    required this.iconSelecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: corAzulPrincipal,

      currentIndex: iconSelecionado,
      onTap: onTap,

      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: iconSelecionado == 0 ? Colors.white : Colors.white70,
          ),
          label: 'Início',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat_bubble,
            color: iconSelecionado == 1 ? Colors.white : Colors.white70,
          ),
          label: 'Mensagens',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: iconSelecionado == 2 ? Colors.white : Colors.white70,
          ),
          label: 'Perfil',
        ),
      ],

      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}
