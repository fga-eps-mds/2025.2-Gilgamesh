import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../../services/user_service.dart';

class AlterarSenhaPopup extends StatefulWidget {
  const AlterarSenhaPopup({super.key});

  @override
  State<AlterarSenhaPopup> createState() => _AlterarSenhaPopupState();
}

class _AlterarSenhaPopupState extends State<AlterarSenhaPopup> {
  final UserService _userService = UserService();
  
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();
  
  bool _isLoading = false;           
  bool _mostrarSenhaAtual = false; 
  bool _mostrarNovaSenha = false;
  bool _mostrarConfirmaSenha = false;

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
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

    if (_novaSenhaController.text.length < 6) {
      _mostrarMensagem('A senha deve ter no mínimo 6 caracteres', erro: true);
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
              
              const Icon(
                Icons.lock_reset,
                size: 60,
                color: AppColors.azulApoia,
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Requisitos da senha:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '• Mínimo de 6 caracteres',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                    Text(
                      '• Diferente da senha atual',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
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
                        backgroundColor: AppColors.azulApoia,
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