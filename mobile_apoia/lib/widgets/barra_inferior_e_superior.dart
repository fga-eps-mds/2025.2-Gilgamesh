import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/ongs/tela_perfil_ong.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import '../telas/home_ongs.dart';
import 'package:mobile_apoia/widgets/cores.dart';

//Barra inferior de navegação

//  BARRA SUPERIOR
class SuperiorBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const SuperiorBar({super.key, this.showBackButton = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.laranjaApoia,
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

class BottomNavBar extends StatelessWidget {
  final int iconSelecionado;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.iconSelecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.laranjaApoia,

      currentIndex: iconSelecionado,

      onTap: (index) {
        onTap(index);

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeOngs()),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const TelaPerfilONG()),
          );
        }
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: iconSelecionado == 0 ? Colors.white : Colors.white70,
          ),
          label: 'Inicio',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: iconSelecionado == 1 ? Colors.white : Colors.white70,
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
