import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/doador/home_usuario.dart';
import 'package:mobile_apoia/telas/doador/tela_perfil_usuario.dart';
import 'logo.dart'; 


const Color corAzulPrincipal = Color(0xFF007AFF);
const Color corLaranjaONG = Color(0xFFFF9900);

// BARRA SUPERIOR 

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

// BARRA INFERIOR 

class BottomNavBarDoador extends StatelessWidget {

  final int iconSelecionado; 
  final ValueChanged<int> onTap;

  const BottomNavBarDoador({
    super.key,
    required this.iconSelecionado,
    required this.onTap,
  });

  
  void _handleNavigation(BuildContext context, int index) {
    onTap(index);

    Widget screenToNavigate;
    if (index == 0) {
      screenToNavigate = const HomeUsuario();
    } else if (index == 1) {
      
      screenToNavigate = const TelaPerfilUsuario(isOng: false);
    } else {
      
      return; 
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screenToNavigate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: 75,
      
      decoration: const BoxDecoration(color: corAzulPrincipal), 
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      
          IconButton(
            icon: Icon(
              Icons.home,
              
              color: iconSelecionado == 0 ? Colors.white : Colors.white70,
              size: 28,
            ),
            onPressed: () => _handleNavigation(context, 0),
          ),

          
          IconButton(
            icon: Icon(
              Icons.person,
              
              color: iconSelecionado == 1 ? Colors.white : Colors.white70,
              size: 28,
            ),
            onPressed: () => _handleNavigation(context, 1), 
          ),
        ],
      ),
    );
  }
}