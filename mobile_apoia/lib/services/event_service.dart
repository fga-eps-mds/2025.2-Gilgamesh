import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import '../models/event.dart'; 

class EventService {
  // Endereço do seu Django (Para emulador Android)
  final String baseUrl = 'http://10.0.2.2:8000/api/eventos/';

  Future<List<Event>> getEvents() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Event> events = body.map((dynamic item) => Event.fromJson(item)).toList(); 
        return events;
      } else {
        throw Exception('Falha ao carregar eventos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}