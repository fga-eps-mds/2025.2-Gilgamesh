import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UserService {
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/auth';
    } else {
      return 'http://127.0.0.1:8000/api/auth';
    }
  }

  Future<Map<String, dynamic>?> buscarDadosUsuario() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Token não encontrado');
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/usuario/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        print('Erro ao buscar dados: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão ao buscar dados: $e');
      return null;
    }
  }

  Future<bool> atualizarUsuario({
    required String nome,
    String? endereco,
    String? uf,
    String? telefone,
    String? descricao,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Token não encontrado');
        return false;
      }

      Map<String, dynamic> body = {
        'nome': nome,
      };

      if (endereco != null && endereco.isNotEmpty) {
        body['endereco'] = endereco;
      }
      
      if (uf != null && uf.isNotEmpty && uf != 'UF') {
        body['uf'] = uf;
      }

      if (telefone != null && telefone.isNotEmpty) {
        body['telefone'] = telefone;
      }

      if (descricao != null && descricao.isNotEmpty) {
        body['descricao'] = descricao;
      }

      print('Enviando atualização: $body');

      final response = await http.put(
        Uri.parse('$baseUrl/usuario/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final dadosAtualizados = jsonDecode(utf8.decode(response.bodyBytes));
        await prefs.setString(
          'user_data', 
          jsonEncode(dadosAtualizados['usuario'])
        );
        return true;
      } else {
        print('Erro na atualização: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }


  Future<Map<String, dynamic>> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
    required String confirmaSenha,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return {
          'sucesso': false,
          'mensagem': 'Usuário não autenticado. Faça login novamente.',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/alterar-senha/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'senha_atual': senhaAtual,
          'nova_senha': novaSenha,
          'confirma_senha': confirmaSenha,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'sucesso': true,
          'mensagem': 'Senha alterada com sucesso!',
        };
      } else {
        final erro = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'sucesso': false,
          'mensagem': erro['erro'] ?? 'Erro ao alterar senha',
        };
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return {
        'sucesso': false,
        'mensagem': 'Erro de conexão com o servidor',
      };
    }
  }
}