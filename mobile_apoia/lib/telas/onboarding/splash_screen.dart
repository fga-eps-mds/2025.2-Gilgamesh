import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/onboarding/onboarding_screen_1.dart';
import 'package:mobile_apoia/widgets/logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // O comando abaixo espera 1.5 segundos e executa a navegação, tive que colocar milisegundos pq o dart não aceita o double aqui
    Future.delayed(const Duration(milliseconds: 2000), () {
      // Verificamos se o widget ainda está montado na tela por segurança
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Logo(height: 300),

            const SizedBox(height: 20),

            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "DOAÇÕES PARA QUEM PRECISA",
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "O ELO DA AJUDA",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
