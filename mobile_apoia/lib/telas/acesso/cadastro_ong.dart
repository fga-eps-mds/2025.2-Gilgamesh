import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import 'package:mobile_apoia/telas/acesso/tela_login.dart';
import 'package:mobile_apoia/services/auth_service.dart';

class CadastroOngs extends StatefulWidget {
  const CadastroOngs({super.key});

  @override
  State<CadastroOngs> createState() => _CadastroOngsState();
}

class _CadastroOngsState extends State<CadastroOngs> {
  final _nomeOngController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmaSenha = false;
  bool _temMinimoCaracteres = false;
  bool _temLetra = false;
  bool _temNumero = false;

  String estadoSelecionado = 'UF';

  final List<String> _estados = [
    'UF', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT',
    'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR',
    'SC', 'SP', 'SE', 'TO',
  ];

  @override
  void initState() {
    super.initState();
    _senhaController.addListener(_validarSenhaEmTempoReal);
  }

  void _validarSenhaEmTempoReal() {
    final senha = _senhaController.text;
    setState(() {
      _temMinimoCaracteres = senha.length >= 8;
      _temLetra = RegExp(r'[a-zA-Z]').hasMatch(senha);
      _temNumero = RegExp(r'[0-9]').hasMatch(senha);
    });
  }

  bool _senhaValida() {
    return _temMinimoCaracteres && _temLetra && _temNumero;
  }

  @override
  void dispose() {
    _senhaController.removeListener(_validarSenhaEmTempoReal);
    _nomeOngController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
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
        controller: controller,
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

  Widget _buildPasswordInput({
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.cinzaInputFundo,
        borderRadius: BorderRadius.circular(0),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.black54,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }

  Widget _buildRequisitoItem(String texto, bool cumprido) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            cumprido ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: cumprido ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                fontSize: 11,
                color: cumprido ? Colors.green.shade700 : Colors.black54,
                fontWeight: cumprido ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
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

                Row(
                  children: [
                    Expanded(
                      child: caixaInput(
                        hintText: "ENDEREÇO / CIDADE",
                        controller: _enderecoController,
                      ),
                    ),
                    const SizedBox(width: 10),
                    caixaEstados(),
                  ],
                ),
                const SizedBox(height: 15),

                _buildPasswordInput(
                  hintText: "SENHA",
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  onToggleVisibility: () {
                    setState(() => _mostrarSenha = !_mostrarSenha);
                  },
                ),
                const SizedBox(height: 15),

                _buildPasswordInput(
                  hintText: "CONFIRMAR SENHA",
                  controller: _confirmaSenhaController,
                  obscureText: !_mostrarConfirmaSenha,
                  onToggleVisibility: () {
                    setState(() => _mostrarConfirmaSenha = !_mostrarConfirmaSenha);
                  },
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Requisitos da senha:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRequisitoItem(
                        'Mínimo de 8 caracteres',
                        _temMinimoCaracteres,
                      ),
                      _buildRequisitoItem(
                        'Pelo menos uma letra (A-Z ou a-z)',
                        _temLetra,
                      ),
                      _buildRequisitoItem(
                        'Pelo menos um número (0-9)',
                        _temNumero,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                caixaInput(
                  hintText: "DESCRIÇÃO CURTA (EX: MISSÃO, ÁREA DE ATUAÇÃO)",
                  maxLines: 3,
                  controller: _descricaoController,
                ),
                const SizedBox(height: 15),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_senhaController.text != _confirmaSenhaController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('As senhas não coincidem!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (!_senhaValida()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'A senha deve ter no mínimo 8 caracteres, incluindo letras e números',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (_nomeOngController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _cnpjController.text.isEmpty ||
                          _senhaController.text.isEmpty ||
                          estadoSelecionado == 'UF') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Preencha todos os campos obrigatórios.'),
                          ),
                        );
                        return;
                      }

                      bool sucesso = await AuthService().cadastrar(
                        nome: _nomeOngController.text,
                        email: _emailController.text,
                        password: _senhaController.text,
                        tipoUsuario: 'ong',
                        cnpj: _cnpjController.text,
                        telefone: _telefoneController.text,
                        endereco: _enderecoController.text,
                        uf: estadoSelecionado,
                        descricao: _descricaoController.text,
                      );

                      if (!context.mounted) return;

                      if (sucesso) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cadastro realizado! Faça login.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaLogin(),
                          ),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao cadastrar. Verifique email/CNPJ.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
                      "CADASTRAR ONG",
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
}