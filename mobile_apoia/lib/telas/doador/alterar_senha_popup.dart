import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';

class AlterarSenhaPopup extends StatefulWidget {
  const AlterarSenhaPopup({super.key});

  @override
  State<AlterarSenhaPopup> createState() => _AlterarSenhaPopupState();
}

class _AlterarSenhaPopupState extends State<AlterarSenhaPopup> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  
  bool _isLoading = false;
  bool _mostrarSenhaAtual = false;
  bool _mostrarNovaSenha = false;
  bool _mostrarConfirmaSenha = false;
  bool _temMinimoCaracteres = false;
  bool _temLetra = false;
  bool _temNumero = false;
  String _tipoUsuario = 'voluntario';

  @override
  void initState() {
    super.initState();
    _carregarTipoUsuario();
    _novaSenhaController.addListener(_validarSenhaEmTempoReal);
  }

  void _carregarTipoUsuario() async {
    final dados = await _authService.getUsuarioSalvo();
    if (dados != null && mounted) {
      setState(() {
        _tipoUsuario = dados['tipo_usuario'] ?? 'voluntario';
      });
    }
  }

  Color get _corPrincipal {
    return _tipoUsuario == 'ong' ? AppColors.laranjaApoia : AppColors.azulApoia;
  }

  @override
  void dispose() {
    _novaSenhaController.removeListener(_validarSenhaEmTempoReal);
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  void _validarSenhaEmTempoReal() {
    final senha = _novaSenhaController.text;
    
    setState(() {
      _temMinimoCaracteres = senha.length >= 8;
      _temLetra = RegExp(r'[a-zA-Z]').hasMatch(senha);
      _temNumero = RegExp(r'[0-9]').hasMatch(senha);
    });
  }

  bool _senhaValida() {
    return _temMinimoCaracteres && _temLetra && _temNumero;
  }

  void _alterarSenha() async {
    if (_senhaAtualController.text.isEmpty ||
        _novaSenhaController.text.isEmpty ||
        _confirmaSenhaController.text.isEmpty) {
      _mostrarMensagem('Todos os campos são obrigatórios', erro: true);
      return;
    }

    if (_novaSenhaController.text != _confirmaSenhaController.text) {
      _mostrarMensagem('As novas senhas não coincidem', erro: true);
      return;
    }

    if (!_senhaValida()) {
      _mostrarMensagem(
        'A senha deve conter no mínimo 8 caracteres, incluindo letras e números',
        erro: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    final resultado = await _userService.alterarSenha(
      senhaAtual: _senhaAtualController.text,
      novaSenha: _novaSenhaController.text,
      confirmaSenha: _confirmaSenhaController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (resultado['sucesso']) {
      _mostrarMensagem(resultado['mensagem'], erro: false);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      _mostrarMensagem(resultado['mensagem'], erro: true);
    }
  }

  void _mostrarMensagem(String mensagem, {required bool erro}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 14,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ALTERAR SENHA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              Icon(
                Icons.lock_reset,
                size: 60,
                color: _corPrincipal,
              ),
              
              const SizedBox(height: 20),

              _buildPasswordInput(
                hintText: 'SENHA ATUAL',
                controller: _senhaAtualController,
                obscureText: !_mostrarSenhaAtual,
                onToggleVisibility: () {
                  setState(() => _mostrarSenhaAtual = !_mostrarSenhaAtual);
                },
              ),
              
              const SizedBox(height: 15),

              _buildPasswordInput(
                hintText: 'NOVA SENHA',
                controller: _novaSenhaController,
                obscureText: !_mostrarNovaSenha,
                onToggleVisibility: () {
                  setState(() => _mostrarNovaSenha = !_mostrarNovaSenha);
                },
              ),
              
              const SizedBox(height: 15),

              _buildPasswordInput(
                hintText: 'CONFIRMAR NOVA SENHA',
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

              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading 
                          ? null 
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'CANCELAR',
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _alterarSenha,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _corPrincipal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'SALVAR',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}