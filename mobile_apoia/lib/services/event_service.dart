import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import 'dart:io';
import '../services/api_config.dart';

class EventService {
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/eventos/';
    } else {
      return 'http://127.0.0.1:8000/api/eventos/';
    }
  }

  Future<List<Event>> getEvents({String? cidade, String? estado}) async {
    try {
      // Monta os parâmetros usando interpolação -- suporte para os filtros
      final queryParams = {
        if (cidade != null && cidade.isNotEmpty) 'cidade': cidade,
        if (estado != null && estado.isNotEmpty) 'estado': estado,
      };

      // Constrói a URL usando interpolação
      final String url = queryParams.isEmpty
          ? baseUrl
          : '$baseUrl?${Uri(queryParameters: queryParams).query}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Event.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar eventos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  Future<bool> createEvent(Event event, String token) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token", // o token entra aqui
        },
        body: jsonEncode(event.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Erro: $e");
      return false;
    }
  }

  Future<bool> updateEvent(Event event) async {
    try {
      final url = '$baseUrl${event.id}/';
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(event.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Erro ao editar: $e");
      return false;
    }
  }
}
