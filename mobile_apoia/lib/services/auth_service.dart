import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthService {
  // O código decide qual IP usar baseado em onde está rodando
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/auth';
    } else {
      // Para Linux, Windows, iOS e Web
      return 'http://127.0.0.1:8000/api/auth';
    }
  }

  /*  // auth_service.dart
  final String baseUrl =
      'http://XXX.XXX.XX.X:8000/api/auth'; // Use o SEU IP aqui */

  // login
  Future<bool> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];

        // Salvar token no celular para usar depois
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_data', jsonEncode(data['usuario']));

        return true; // Login sucesso
      } else {
        print('Erro Login: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }

  // Cadastro
  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String password,
    required String tipoUsuario, // 'ong' ou 'voluntario'
    String? cpf,
    String? cnpj,
    String? endereco,
    String? telefone,
    String? descricao,
  }) async {
    final url = Uri.parse('$baseUrl/cadastro/');

    // Json que comunica com o Django
    Map<String, dynamic> body = {
      'nome': nome,
      'email': email,
      'password':
          password, // No cadastro o Django espera 'password' (ModelSerializer)
      'tipo_usuario': tipoUsuario,
      'endereco': endereco,
      'telefone': telefone,
      'descricao': descricao,
    };

    // Adiciona CPF ou CNPJ dependendo do tipo
    if (tipoUsuario == 'voluntario' && cpf != null) {
      body['cpf'] = cpf;
    } else if (tipoUsuario == 'ong' && cnpj != null) {
      body['cnpj'] = cnpj;
    }

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        return true; // Cadastro sucesso
      } else {
        print('Erro Cadastro: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }

  // Função útil para deslogar
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Apaga o token
  }
}
