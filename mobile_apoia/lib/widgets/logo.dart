import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  // Variável para controlar o tamanho
  final double height;

  const Logo({
    super.key,
    this.height = 220, // Valor padrão se ninguém informar nada
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      height: height,
      fit: BoxFit.contain, // Garante que não estica/distorce
    );
  }
}
