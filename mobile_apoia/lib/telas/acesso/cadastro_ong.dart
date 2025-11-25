import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import 'package:mobile_apoia/widgets/logo.dart';

class CadastroOngs extends StatefulWidget {
  const CadastroOngs({super.key});

  @override
  State<CadastroOngs> createState() => _CadastroOngsState();
}

class _CadastroOngsState extends State<CadastroOngs> {
  // --- 1. CONTROLADORES (Para capturar o texto digitado) ---
  final TextEditingController _nomeOngController = TextEditingController();
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController =
      TextEditingController();
  final TextEditingController _decricaoController = TextEditingController();

  // Estado para o Dropdown de UF
  String estadoSelecionado = 'UF'; // Valor inicial
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
      // SingleChildScrollView é obrigatório aqui porque o formulário é alto
      // e o teclado vai cobrir a tela.
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: Column(
              children: [
                Column(
                  children: [
                    const Logo(),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // --- CAMPOS DO FORMULÁRIO ---
                // Usando nosso widget customizado _buildGrayInput
                caixaInput(
                  hintText: "NOME DA INSTITUIÇÃO",
                  controller: _nomeOngController,
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "CNPJ",
                  keyboardType: TextInputType.number,
                  controller: _cnpjController,
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "E-MAIL INSTITUCIONAL",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "TELEFONE",
                  keyboardType: TextInputType.phone,
                  controller: _telefoneController,
                ),
                const SizedBox(height: 15),

                // --- LINHA ENDEREÇO + DROPDOWN ESTADO ---
                Row(
                  children: [
                    // Endereço ocupa o espaço que sobrar (Expanded)
                    Expanded(
                      child: caixaInput(
                        hintText: "ENDEREÇO / CIDADE",
                        controller: _enderecoController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Dropdown tem tamanho fixo
                    caixaEstados(),
                  ],
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "SENHA",
                  obscureText: true,
                  controller: _senhaController,
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "CONFIRMAR SENHA",
                  obscureText: true,
                  controller: _confirmaSenhaController,
                ),
                const SizedBox(height: 15),

                // Campo de Descrição (Multi-linhas)
                caixaInput(
                  hintText: "DESCRIÇÃO CURTA (EX: MISSÃO, ÁREA DE ATUAÇÃO)",
                  maxLines: 3, // Permite mais linhas
                  controller: _decricaoController,
                ),
                const SizedBox(height: 15),

                // Campo de Upload (Com ícone no final)
                caixaInput(
                  hintText: "UPLOAD DE LOGO",
                  // Usamos um InkWell no ícone para ele ser clicável
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
                      print("Nome: ${_nomeOngController.text}");
                      print("CPF: ${_cnpjController.text}");
                      print("Email: ${_emailController.text}");
                      print("Telefone: ${_telefoneController.text}");
                      print("Endereço: ${_enderecoController.text}");
                      print("Estado: $estadoSelecionado");
                      print("Senha: ${_senhaController.text}");
                      print("Descrição: ${_decricaoController.text}");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.laranjaBotao,
                      foregroundColor: Colors.black87,
                      elevation: 0, // Flat na imagem
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "CADASTRAR INSTITUIÇÃO",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espaço final para scroll
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET REUTILIZÁVEL PARA OS INPUTS CINZAS ---
  Widget caixaInput({
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon, // Ícone opcional no final (para o upload)
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cinzaInputFundo,
        borderRadius: BorderRadius.circular(
          0,
        ), // Cantos retos conforme a imagem
      ),
      child: TextField(
        controller: controller, //conecta ao campo de texto
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none, // Remove a linha padrão
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
          suffixIcon: suffixIcon, // Adiciona o ícone se ele for passado
          contentPadding: (maxLines > 1)
              ? const EdgeInsets.symmetric(vertical: 10)
              : null,
        ),
      ),
    );
  }

  // --- WIDGET ESPECÍFICO PARA O DROPDOWN DE ESTADO ---
  Widget caixaEstados() {
    return Container(
      width: 110, // Largura fixa para o dropdown
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.cinzaInputFundo,
        borderRadius: BorderRadius.circular(0),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: estadoSelecionado,
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true, // Ocupa todo o espaço do container
          elevation: 16,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onChanged: (String? newValue) {
            setState(() {
              estadoSelecionado = newValue!;
            });
          },
          // Cria a lista de itens do menu baseado na lista _estados
          items: _estados.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}
