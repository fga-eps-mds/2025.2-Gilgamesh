import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/onboarding/splash_screen.dart'; //importa a primeira pagina

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apoia+',
      home: const SplashScreen(),
    );
  }
}
