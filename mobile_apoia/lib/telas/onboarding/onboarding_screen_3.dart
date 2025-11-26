import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/bolinhas_navegacao_telasiniciais.dart';
import 'package:mobile_apoia/telas/acesso/tela_login.dart';
import 'package:mobile_apoia/widgets/cores.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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

              // Imagem
              Icon(
                Icons.volunteer_activism, // Ícone de "Entrega/Doação"
                size: 150,
                color: AppColors.verdePrincipal,
              ),

              const Spacer(flex: 1),

              Text(
                "CADA GESTO CONTA",
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
                "FAÇA DOAÇÕES, CONFIRME PRESENÇA EM EVENTOS E AJUDE A FORTALECER CAUSAS SOCIAIS COM TRANSPARÊNCIA E PROPÓSITO.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),

              const Spacer(flex: 2),

              // pontinhos cinzas de navegação
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildDot(AppColors.corCinzaInativo), // 1º
                  const SizedBox(width: 8),
                  buildDot(AppColors.corCinzaInativo), // 2º
                  const SizedBox(width: 8),
                  buildDot(AppColors.corCinzaAtivo), // 3º ATIVO (Escuro)
                ],
              ),

              const SizedBox(height: 30), // Espaço entre dots e botão
              // botão começa agora
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // leva para tela de login
                    //o pushReplace faz com que ao passar pela introdução e apertar o botão voltar, o usuário não volte tudo, ficando no login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaLogin(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.verdePrincipal, // Cor do fundo
                    foregroundColor: Colors.white, // Cor do texto
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "COMEÇAR AGORA",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const Spacer(flex: 1),
              // Espaço extra no final
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
