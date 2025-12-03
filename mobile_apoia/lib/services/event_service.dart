import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class EventService {
  final String baseUrl = 'http://10.0.2.2:8000/api/eventos/';

  Future<List<Event>> getEvents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        String jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> body = jsonDecode(jsonString);
        
        return body.map((dynamic item) => Event.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao carregar eventos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
  Future<bool> createEvent(Event event) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(event.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      print("Erro ao criar: $e");
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