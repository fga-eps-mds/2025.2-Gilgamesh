import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/doador/home_usuario.dart';
import 'package:mobile_apoia/telas/doador/tela_perfil_usuario.dart';
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

      onTap: (index) {
        onTap(index);

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeUsuario()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const TelaPerfilUsuario(isOng: false),
            ),
          );
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: iconSelecionado == 0 ? Colors.white : Colors.white70,
          ),
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: iconSelecionado == 2 ? Colors.white : Colors.white70,
          ),
        ),
      ],

      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}
