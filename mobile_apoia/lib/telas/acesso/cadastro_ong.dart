import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import 'package:mobile_apoia/widgets/logo.dart';

class CadastroOngs extends StatefulWidget {
  const CadastroOngs({super.key});

  @override
  State<CadastroOngs> createState() => _CadastroOngsState();
}

class _CadastroOngsState extends State<CadastroOngs> {
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
                caixaInput(hintText: "NOME DA INSTITUIÇÃO"),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "CNPJ",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "E-MAIL INSTITUCIONAL",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),

                caixaInput(
                  hintText: "TELEFONE",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),

                // --- LINHA ENDEREÇO + DROPDOWN ESTADO ---
                Row(
                  children: [
                    // Endereço ocupa o espaço que sobrar (Expanded)
                    Expanded(child: caixaInput(hintText: "ENDEREÇO / CIDADE")),
                    const SizedBox(width: 10),
                    // Dropdown tem tamanho fixo
                    caixaEstados(),
                  ],
                ),
                const SizedBox(height: 15),

                caixaInput(hintText: "SENHA", obscureText: true),
                const SizedBox(height: 15),

                caixaInput(hintText: "CONFIRMAR SENHA", obscureText: true),
                const SizedBox(height: 15),

                // Campo de Descrição (Multi-linhas)
                caixaInput(
                  hintText: "DESCRIÇÃO CURTA (EX: MISSÃO, ÁREA DE ATUAÇÃO)",
                  maxLines: 3, // Permite mais linhas
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
                      print("Enviar formulário de ONG");
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
      // DropdownButtonHideUnderline remove a linha padrão chata do dropdown
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: estadoSelecionado,
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true, // Ocupa todo o espaço do container
          elevation: 16,
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onChanged: (String? newValue) {
            // É aqui que a mágica do StatefulWidget acontece
            setState(() {
              estadoSelecionado = newValue!;
            });
          },
          // Cria a lista de itens do menu baseado na nossa lista _estados
          items: _estados.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}
