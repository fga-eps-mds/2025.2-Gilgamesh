import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:mobile_apoia/models/ong.dart';
import 'api_config.dart';

class AuthService {
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/auth';
    } else {
      return 'http://127.0.0.1:8000/api/auth';
    }
  }

  Future<List<Ong>> getOngs() async {
    final url = Uri.parse('${APIConfig.baseURL}/api/auth/ongs/');
    try {
      final response = await http.get(Uri.parse('$baseUrl/ongs/'));

      if (response.statusCode == 200) {
        // Decodifica o JSON
        String jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> body = jsonDecode(jsonString);

        // Transforma a lista de JSON em lista de objetos Ong
        return body.map((item) => Ong.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar ONGs: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar ONGs: $e');
      return []; // Retorna lista vazia em caso de erro para não quebrar a tela
    }
  }

  Future<String?> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        String token = data['token'];
        String tipo = data['usuario']['tipo_usuario'] ?? 'voluntario';

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        await prefs.setString('user_data', jsonEncode(data['usuario']));

        return tipo;
      } else {
        print('Erro Login: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    }
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String password,
    required String tipoUsuario,
    String? cpf,
    String? cnpj,
    String? endereco,
    String? telefone,
    String? descricao,
  }) async {
    final url = Uri.parse('$baseUrl/cadastro/');

    Map<String, dynamic> body = {
      'nome': nome,
      'email': email,
      'password': password,
      'tipo_usuario': tipoUsuario,
      'endereco': endereco,
      'telefone': telefone,
      'descricao': descricao,
    };

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

      return response.statusCode == 201;
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>?> getUsuarioSalvo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user_data');
    if (userJson == null) return null;
    return jsonDecode(userJson);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
