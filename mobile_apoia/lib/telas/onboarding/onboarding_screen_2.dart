import 'package:mobile_apoia/telas/onboarding/onboarding_screen_3.dart';
import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/bolinhas_navegacao_telasiniciais.dart';
import 'package:mobile_apoia/widgets/botao_pular_introducao.dart';
import 'package:mobile_apoia/widgets/cores.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Icon(
                Icons.location_on_rounded, // Ícone de pino de mapa
                size: 150,
                color: AppColors.verdePrincipal,
              ),

              const Spacer(flex: 1),

              Text(
                "DESCUBRA AÇÕES PERTO DE VOCÊ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.azulTexto,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "ENCONTRE CAMPANHAS, EVENTOS E PONTOS DE APOIO NA SUA REGIÃO E PARTICIPE DO JEITO QUE PUDER.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const Spacer(flex: 2),

              // bolinhas cinza de navegação
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 50), // Espaço vazio esquerda
                  // Indicadores (Dots)
                  Row(
                    children: [
                      buildDot(AppColors.corCinzaInativo), // 1º Inativo
                      const SizedBox(width: 8),
                      buildDot(AppColors.corCinzaAtivo), // 2º ATIVO (Escuro)
                      const SizedBox(width: 8),
                      buildDot(AppColors.corCinzaInativo), // 3º Inativo
                    ],
                  ),

                  // Botão Próximo
                  InkWell(
                    onTap: () {
                      // leva para a pagina 3
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnboardingScreen3(),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.verdePrincipal,
                        shape: BoxShape.circle,
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

              // botão pular explicação
              const BotaoPular(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
