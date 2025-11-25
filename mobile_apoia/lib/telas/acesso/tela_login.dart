import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/custom_inputs.dart';
import 'package:mobile_apoia/telas/acesso/pre_cadastro.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import 'package:mobile_apoia/widgets/cores.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

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

                const SizedBox(height: 60),

                const Text(
                  "LOG IN",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                // Campo de Email/CPF
                buildCustomInput(
                  icon: Icons.mail_outline,
                  hintText: "EMAIL OU CPF/CNPJ",
                  corFundoIcone: AppColors.corCinzaIcone,
                  corFundoInput: AppColors.cinzaInputFundo,
                ),

                const SizedBox(height: 20),

                // Campo de Senha
                buildCustomInput(
                  icon: Icons.lock_outline,
                  hintText: "SENHA",
                  isPassword: true, // Ativa o modo senha
                  corFundoIcone: AppColors.corCinzaIcone,
                  corFundoInput: AppColors.cinzaInputFundo,
                ),

                const SizedBox(height: 10),

                // "Esqueci minha senha"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      print("Recuperar senha");
                    },
                    child: const Text(
                      "ESQUECI MINHA SENHA",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                InkWell(
                  onTap: () {
                    print("Botão Entrar clicado");
                    // Navegar para a Home
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.verdeGradiente1,
                          AppColors.verdeGradiente2,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.verdeGradiente2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "ENTRAR",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => print("Entrar sem login"),
                      child: const Text(
                        "ENTRAR SEM LOG IN",
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ),
                    Text(
                      "OU",
                      style: TextStyle(
                        color: AppColors.laranjaApoia,
                        fontSize: 12,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PreCadastro(),
                          ),
                        );
                      },
                      child: const Text(
                        "NÃO TENHO UMA CONTA",
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
