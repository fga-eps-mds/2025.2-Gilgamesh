import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/acesso/pre_cadastro.dart';
import 'package:mobile_apoia/telas/doador/home_usuario.dart';
import 'package:mobile_apoia/telas/home_ongs.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import 'package:mobile_apoia/services/auth_service.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  // controladores(Para capturar o texto)
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

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
                      text: const TextSpan(
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
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                // CAMPO EMAIL (Com o controlador conectado)
                _buildCustomInput(
                  icon: Icons.mail_outline,
                  hintText: "EMAIL",
                  corFundoIcone: AppColors.cinzaEscuroIcone,
                  corFundoInput: AppColors.cinzaInputFundo,
                  controller: _emailController, // <--- controlador
                ),

                const SizedBox(height: 20),

                // CAMPO SENHA (Com o controlador conectado)
                _buildCustomInput(
                  icon: Icons.lock_outline,
                  hintText: "SENHA",
                  isPassword: true,
                  corFundoIcone: AppColors.cinzaEscuroIcone,
                  corFundoInput: AppColors.cinzaInputFundo,
                  controller: _senhaController, // <--- controlador
                ),

                const SizedBox(height: 10),

                // Esqueci minha senha
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

                // BOTÃO ENTRAR
                InkWell(
                  onTap: () async {
                    if (_emailController.text.isEmpty ||
                        _senhaController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha e-mail e senha'),
                        ),
                      );
                      return;
                    }

                    print("Email digitado: ${_emailController.text}");
                    print("Senha digitada: ${_senhaController.text}");

                    // Chamando BACKEND para o tipo de usuário
                    String? tipoUsuario = await AuthService().login(
                      _emailController.text,
                      _senhaController.text,
                    );

                    if (!context.mounted)
                      return; // Segurança do Flutter para não dar erro se a tela fechar

                    if (tipoUsuario != null) {
                      print("Login autorizado! Tipo: $tipoUsuario");

                      // Lógica de Redirecionamento
                      if (tipoUsuario == 'ong') {
                        // Redireciona para Home da ONG
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeOngs(),
                          ),
                        );
                      } else if (tipoUsuario == 'voluntario') {
                        // Redireciona para Home do Voluntário
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeUsuario(),
                          ),
                        );
                      } else {
                        // Caso seja 'admin' ou um tipo desconhecido
                        Navigator.pushReplacementNamed(context, '/home_padrao');
                      }
                    } else {
                      print("Falha no login.");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Login falhou. Verifique e-mail e senha.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.verdeGradiente1,
                          AppColors.verdeGradiente2,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.verdeGradiente2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
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
                        "ENTRAR SEM LOGIN",
                        style: TextStyle(color: Colors.black87, fontSize: 12),
                      ),
                    ),
                    const Text(
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

  Widget _buildCustomInput({
    required IconData icon,
    required String hintText,
    required Color corFundoIcone,
    required Color corFundoInput,
    TextEditingController? controller,
    bool isPassword = false,
  }) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          color: corFundoIcone,
          child: Icon(icon, color: Colors.black87, size: 28),
        ),
        Expanded(
          child: Container(
            height: 60,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: corFundoInput,
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.black45),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
