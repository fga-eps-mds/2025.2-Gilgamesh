import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/onboarding/onboarding_screen_2.dart';
import 'package:mobile_apoia/widgets/bolinhas_navegacao_telasiniciais.dart';
import 'package:mobile_apoia/widgets/botao_pular_introducao.dart'; //impor necessário para o botão pular introdução

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color corVerde = const Color(0xFF5ABF86);
    final Color corAzulTexto = const Color(0xFF2E8EB6);
    final Color corCinzaAtivo = const Color(0xFF666666);
    final Color corCinzaInativo = const Color(0xFFDDDDDD);

    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea garante que não fique embaixo da barra de status/notch
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ), // Margem nas laterais
          child: Column(
            children: [
              const Spacer(flex: 2),

              Icon(
                Icons.volunteer_activism, // Ícone de "Mão segurando coração"
                size: 150,
                color: corVerde,
              ),

              const Spacer(flex: 1),

              Text(
                "CONECTE-SE A QUEM FAZ A DIFERENÇA",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: corAzulTexto,
                  letterSpacing: 0.5, // Espaçamento entre letras
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "APOIA+ APROXIMA PESSOAS DISPOSTAS A AJUDAR DE ONGS E PROJETOS SOCIAIS QUE TRANSFORMAM VIDAS.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5, // Altura da linha para facilitar leitura
                  color: Colors.black54,
                ),
              ),

              const Spacer(flex: 2),

              // BARRA DE NAVEGAÇÃO (PONTOS + BOTÃO)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 50),

                  // bolinhas cinza de navegação
                  Row(
                    children: [
                      buildDot(corCinzaAtivo), // Ativo
                      const SizedBox(width: 8),
                      buildDot(corCinzaInativo), // Inativo
                      const SizedBox(width: 8),
                      buildDot(corCinzaInativo), // Inativo
                    ],
                  ),

                  // botão verde --> leva pra página seguinte pelo Navigator
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingScreen2(),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: corVerde,
                        shape: BoxShape.circle, // Forma circular
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 1),

              //botão pular explicação
              const BotaoPular(),

              const SizedBox(height: 20), // Espacinho final
            ],
          ),
        ),
      ),
    );
  }
}
