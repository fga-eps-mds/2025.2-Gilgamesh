/* import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IMPORTANTE:
  // Se usar Emulador Android: use '10.0.2.2'
  // Se usar Celular Físico: use o IP da sua máquina (ex: 192.168.0.15)
  // Nunca use 'localhost' ou '127.0.0.1' no emulador!
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<bool> fazerLogin(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login/'); // A URL que definimos no Django

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email":
              email, // O nome da chave tem que ser IGUAL ao que o Django espera
          "senha": senha,
        }),
      );

      if (response.statusCode == 200) {
        print("Django respondeu: ${response.body}");
        return true; // Login deu certo
      } else {
        print("Erro no login: ${response.body}");
        return false; // Login deu errado
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return false;
    }
  }
} */
