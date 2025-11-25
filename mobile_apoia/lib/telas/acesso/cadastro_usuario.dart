import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import 'package:mobile_apoia/widgets/cores.dart';

class CadastroUsuarios extends StatefulWidget {
  const CadastroUsuarios({super.key});

  @override
  State<CadastroUsuarios> createState() => _CadastroUsuariosState();
}

class _CadastroUsuariosState extends State<CadastroUsuarios> {
  // --- 1. CONTROLADORES (Para capturar o texto digitado) ---
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();

  // Estado para o Dropdown de UF
  String estadoSelecionado = 'UF';

  final List<String> _estados = [
    'UF',
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(
              children: [
                // --- LOGO ---
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

                const SizedBox(height: 40),

                // --- formulários(Conectando os controladores) ---
                caixaInput(
                  hintText: "NOME COMPLETO",
                  controller: _nomeController, // <--- Conectado
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "CPF",
                  keyboardType: TextInputType.number,
                  controller: _cpfController, // <--- Conectado
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "E-MAIL",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController, // <--- Conectado
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "TELEFONE",
                  keyboardType: TextInputType.phone,
                  controller: _telefoneController, // <--- Conectado
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: caixaInput(
                        hintText: "ENDEREÇO / CIDADE",
                        controller: _enderecoController, // <--- Conectado
                      ),
                    ),
                    const SizedBox(width: 10),
                    caixaEstados(),
                  ],
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "SENHA",
                  obscureText: true,
                  controller: _senhaController, // <--- Conectado
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "CONFIRMAR SENHA",
                  obscureText: true,
                  controller: _confirmaSenhaController, // <--- Conectado
                ),
                const SizedBox(height: 15),

                // Campo de Upload
                caixaInput(
                  hintText: "UPLOAD DE FOTO (OPCIONAL)",
                  suffixIcon: InkWell(
                    onTap: () {
                      print("Abrir seletor de arquivos");
                    },
                    child: const Icon(
                      Icons.file_upload_outlined,
                      color: Colors.black54,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // --- BOTÃO CADASTRAR ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // impimindo dados para teste
                      print("--- DADOS DO VOLUNTÁRIO ---");
                      print("Nome: ${_nomeController.text}");
                      print("CPF: ${_cpfController.text}");
                      print("Email: ${_emailController.text}");
                      print("Telefone: ${_telefoneController.text}");
                      print("Endereço: ${_enderecoController.text}");
                      print("Estado: $estadoSelecionado");
                      print("Senha: ${_senhaController.text}");

                      // backend
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulBotao,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "CADASTRAR VOLUNTÁRIO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget caixaInput({
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cinzaInputFundo,
        borderRadius: BorderRadius.circular(0),
      ),
      child: TextField(
        controller: controller, // conecta ao campo de texto
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
          suffixIcon: suffixIcon,
          contentPadding: (maxLines > 1)
              ? const EdgeInsets.symmetric(vertical: 10)
              : null,
        ),
      ),
    );
  }

  Widget caixaEstados() {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.cinzaInputFundo,
        borderRadius: BorderRadius.circular(0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: estadoSelecionado,
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          elevation: 16,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onChanged: (String? newValue) {
            setState(() {
              estadoSelecionado = newValue!;
            });
          },
          items: _estados.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}
