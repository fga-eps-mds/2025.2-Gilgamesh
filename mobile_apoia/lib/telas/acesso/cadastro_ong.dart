import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import 'package:mobile_apoia/telas/acesso/tela_login.dart';
import 'package:mobile_apoia/services/auth_service.dart';

class CadastroOngs extends StatefulWidget {
  const CadastroOngs({super.key});

  @override
  State<CadastroOngs> createState() => _CadastroOngsState();
}

class _CadastroOngsState extends State<CadastroOngs> {
  // CONTROLADORES (Para capturar o texto digitado)
  final _nomeOngController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  final _descricaoController = TextEditingController();

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

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

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
                  controller: _descricaoController,
                ),
                const SizedBox(height: 15),

                const SizedBox(height: 40),

                // --- BOTÃO CADASTRAR ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    //o async (assincrono) impede que a aplicação congele enquanto espera os dados do backend
                    onPressed: () async {
                      print("Iniciou o clique");

                      //Confere se as senhas são iguais e retorna mensagem de erro se não for
                      if (_senhaController.text !=
                          _confirmaSenhaController.text) {
                        print("Erro! Senhas não conferem!");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('As senhas não coincidem!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return; //Para a execução
                      }

                      if (_nomeOngController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _cnpjController.text.isEmpty ||
                          _senhaController.text.isEmpty ||
                          estadoSelecionado == 'UF') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Preencha todos os campos obrigatórios',
                            ),
                          ),
                        );
                        return;
                      }
                      print("Enviando dados para o Django...");
                      print("Enviando cadastro de: $_nomeOngController ");
                      // impimindo dados para teste
                      /* print("--- DADOS DA ONG ---");
                      print("Nome: ${_nomeOngController.text}");
                      print("Cnpj: ${_cnpjController.text}");
                      print("Email: ${_emailController.text}");
                      print("Telefone: ${_telefoneController.text}");
                      print("Endereço: ${_enderecoController.text}");
                      print("Estado: $estadoSelecionado");
                      print("Senha: ${_senhaController.text}");
                      print("Descrição: ${_decricaoController.text}"); */
                      // 3. chama o backend django
                      bool sucesso = await AuthService().cadastrar(
                        nome: _nomeOngController.text,
                        email: _emailController.text,
                        password: _senhaController.text,
                        tipoUsuario: 'ong',
                        cnpj: _cnpjController.text,
                        telefone: _telefoneController.text,
                        // Passando endereço formatado com UF
                        endereco: _enderecoController.text,
                        uf: estadoSelecionado,
                        descricao: _descricaoController.text,
                      );
                      print("RESPOSTA DO SERVIÇO (Sucesso?): $sucesso");
                      // resposta visual
                      if (!context.mounted) return; // Segurança do Flutter

                      if (sucesso) {
                        print("Sucesso! Navegando para Login...");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cadastro realizado! Faça login.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Remove tudo da pilha e vai pro login
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaLogin(),
                          ),
                          (route) => false,
                        );
                      } else {
                        print("Fracasso! Mostrando erro na tela.");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Erro ao cadastrar. Verifique email/CPF.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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

  //Limpeza de memória (boa prática)
  @override
  void dispose() {
    _nomeOngController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    _descricaoController.dispose();
    super.dispose();
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
