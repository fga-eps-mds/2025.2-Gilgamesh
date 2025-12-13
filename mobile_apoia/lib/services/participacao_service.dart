import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../services/api_config.dart';

enum ResultadoParticipacao { sucesso, jaInscrito, erro }

class ParticipationService {
  String get baseUrl => APIConfig.baseURL;

  Future<ResultadoParticipacao> participar(int eventId, String token) async {
    final url = Uri.parse('$baseUrl/api/participacoes/');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({"evento": eventId}),
      );

      if (response.statusCode == 201) {
        return ResultadoParticipacao.sucesso;
      } else if (response.body.contains("já está inscrito")) {
        return ResultadoParticipacao.jaInscrito;
      }
      return ResultadoParticipacao.erro;
    } catch (e) {
      print("Erro ao participar: $e");
      return ResultadoParticipacao.erro;
    }
  }

  Future<bool> cancelarParticipacao(int participacaoId, String token) async {
    final url = Uri.parse('$baseUrl/api/participacoes/$participacaoId/');

    try {
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );

      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print("Erro ao cancelar: $e");
      return false;
    }
  }

  Future<Event?> buscarEventoPorId(int id, String token) async {
    try {
      final url = Uri.parse('$baseUrl/api/eventos/$id/');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        return Event.fromJson(jsonDecode(responseBody));
      }
    } catch (e) {
      print("Erro ao buscar evento: $e");
    }
    return null;
  }

  Future<int?> verificarParticipacaoUsuario(int eventId, String token) async {
    try {
      final url = Uri.parse('$baseUrl/api/participacoes/');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> lista = jsonDecode(response.body);

        for (var item in lista) {
          if (item['evento'] == eventId) {
            return item['id'];
          }
        }
      }
    } catch (e) {
      print("Erro ao verificar participação: $e");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> buscarMinhasParticipacoes(
    String token,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/api/participacoes/');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Erro ao buscar participações: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro em buscarMinhasParticipacoes: $e');
      return [];
    }
  }

  Future<List<Event>> buscarMeusEventos(String token) async {
    try {
      // 1. Busca participações
      final participacoes = await buscarMinhasParticipacoes(token);

      if (participacoes.isEmpty) {
        return [];
      }

      final List<Event> eventos = [];

      for (var participacao in participacoes) {
        final eventoId = participacao['evento'];
        if (eventoId == null) continue;

        final evento = await buscarEventoPorId(eventoId, token);
        if (evento != null) {
          eventos.add(evento);
        }
      }

      eventos.sort((a, b) => a.date.compareTo(b.date));

      return eventos;
    } catch (e) {
      print('Erro em buscarMeusEventos: $e');
      return [];
    }
  }
}
