import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/acesso/cadastro_ong.dart';
import 'package:mobile_apoia/telas/acesso/cadastro_usuario.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import 'package:mobile_apoia/widgets/logo.dart';

class PreCadastro extends StatelessWidget {
  const PreCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ), // Margem lateral
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza tudo verticalmente
            children: [
              Column(
                children: [
                  const Logo(),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60), // Espaço entre logo e título

              const Text(
                "CADASTRO",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500, // Peso médio
                  color: Colors.black,
                  letterSpacing: 1.0, // Espaçamento entre letras
                ),
              ),

              const SizedBox(height: 30), // Espaço entre título e botões
              // botão ong
              botoesSelecaoPrecad(
                text: "SOU ONG/INSTITUIÇÃO",
                color: AppColors.laranjaBotao,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroOngs(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20), // Espaço entre os botões
              // botao doador
              botoesSelecaoPrecad(
                text: "SOU VOLUNTÁRIO",
                color: AppColors.azulBotao,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroUsuarios()),
                  );
                },
              ),

              const SizedBox(
                height: 40,
              ), // Espaço extra no final para balancear
            ],
          ),
        ),
      ),
    );
  }

  // --- Função Auxiliar para Criar Botões Iguais ---
  Widget botoesSelecaoPrecad({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity, // Ocupa toda a largura disponível
      height: 60, // Altura do botão (bem alto como na imagem)
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors
              .black, // Cor do texto (na imagem parece preto/cinza escuro)
          elevation: 2, // Sombra leve
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Cantos arredondados
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18, // Fonte grande
            fontWeight: FontWeight.w400, // Fonte regular/média
          ),
        ),
      ),
    );
  }
}
