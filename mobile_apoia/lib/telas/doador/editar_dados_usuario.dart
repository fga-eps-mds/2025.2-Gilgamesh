import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import 'package:mobile_apoia/widgets/logo.dart';
import '../../services/user_service.dart';

class EditarDadosUsuario extends StatefulWidget {
  const EditarDadosUsuario({super.key});

  @override
  State<EditarDadosUsuario> createState() => _EditarDadosUsuarioState();
}

class _EditarDadosUsuarioState extends State<EditarDadosUsuario> {
  final UserService _userService = UserService();
  bool _isLoading = true;
  bool _isSaving = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController(); 
  final _cpfController = TextEditingController(); 
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _descricaoController = TextEditingController();

  String estadoSelecionado = 'UF';
  String tipoUsuario = '';

  final List<String> _estados = const [
    'UF', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 
    'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 
    'SC', 'SP', 'SE', 'TO',
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    final dados = await _userService.buscarDadosUsuario();

    if (dados != null) {
      setState(() {
        _nomeController.text = dados['nome'] ?? '';
        _emailController.text = dados['email'] ?? '';
        _cpfController.text = dados['cpf'] ?? '';
        _telefoneController.text = dados['telefone'] ?? '';
        _descricaoController.text = dados['descricao'] ?? '';
        
        tipoUsuario = dados['tipo_usuario'] ?? 'voluntario';

        String enderecoCompleto = dados['endereco'] ?? '';
        if (enderecoCompleto.contains(' - ')) {
          List<String> partes = enderecoCompleto.split(' - ');
          _enderecoController.text = partes[0];
          String uf = partes.last.trim();
          if (_estados.contains(uf)) {
            estadoSelecionado = uf;
          }
        } else {
          _enderecoController.text = enderecoCompleto;
          estadoSelecionado = dados['uf'] ?? 'UF';
        }

        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar dados do usuário'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _salvarAlteracoes() async {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome é obrigatório')),
      );
      return;
    }

    setState(() => _isSaving = true);

    String enderecoCompleto = estadoSelecionado != 'UF'
        ? "${_enderecoController.text}"
        : _enderecoController.text;

    bool sucesso = await _userService.atualizarUsuario(
      nome: _nomeController.text,
      endereco: enderecoCompleto,
      uf: estadoSelecionado,
      telefone: _telefoneController.text,
      descricao: _descricaoController.text,
    );

    setState(() => _isSaving = false);

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados atualizados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Widget _buildInput({
    required String hintText,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey.shade300 : AppColors.cinzaInputFundo,
        borderRadius: BorderRadius.circular(0),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: readOnly ? Colors.grey.shade600 : Colors.black87,
            fontSize: 14,
          ),
          contentPadding: maxLines > 1
              ? const EdgeInsets.symmetric(vertical: 10)
              : null,
        ),
      ),
    );
  }

  Widget _buildStateDropdown() {
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
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onChanged: (String? newValue) {
            setState(() => estadoSelecionado = newValue!);
          },
          items: _estados.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: tipoUsuario == 'ong' 
            ? AppColors.laranjaApoia 
            : AppColors.azulApoia,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Logo(),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  children: [
                    const Text(
                      "EDITAR DADOS",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),

                    _buildInput(
                      hintText: "NOME COMPLETO",
                      controller: _nomeController,
                    ),
                    const SizedBox(height: 15),

                    _buildInput(
                      hintText: "E-MAIL (não editável)",
                      controller: _emailController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 15),

                    if (tipoUsuario == 'voluntario')
                      Column(
                        children: [
                          _buildInput(
                            hintText: "CPF (não editável)",
                            controller: _cpfController,
                            readOnly: true,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),

                    _buildInput(
                      hintText: "TELEFONE",
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            hintText: "ENDEREÇO / CIDADE",
                            controller: _enderecoController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildStateDropdown(),
                      ],
                    ),
                    const SizedBox(height: 15),

                    if (tipoUsuario == 'ong')
                      Column(
                        children: [
                          _buildInput(
                            hintText: "DESCRIÇÃO DA INSTITUIÇÃO",
                            controller: _descricaoController,
                            maxLines: 3,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _salvarAlteracoes,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tipoUsuario == 'ong'
                              ? AppColors.laranjaBotao
                              : AppColors.azulBotao,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "SALVAR ALTERAÇÕES",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}