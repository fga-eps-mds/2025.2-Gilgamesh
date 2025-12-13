import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/ongs/editar_evento_ong.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../../models/event.dart';
import '../../services/auth_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_config.dart';

class Participante {
  final int id;
  final String nome;
  final String email;
  final String? telefone;
  final DateTime dataInscricao;

  Participante({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    required this.dataInscricao,
  });

  factory Participante.fromJson(Map<String, dynamic> json) {
    return Participante(
      id: json['id'],
      nome: json['voluntario']['nome'] ?? 'Sem nome',
      email: json['voluntario']['email'] ?? '',
      telefone: json['voluntario']['telefone'],
      dataInscricao: DateTime.parse(json['data_inscricao']),
    );
  }
}

class DetalhesEventoONG extends StatefulWidget {
  final Event evento;

  const DetalhesEventoONG({super.key, required this.evento});

  @override
  State<DetalhesEventoONG> createState() => _DetalhesEventoONGState();
}

class _DetalhesEventoONGState extends State<DetalhesEventoONG> {
  final AuthService _authService = AuthService();
  
  List<Participante> _participantes = [];
  bool _carregandoParticipantes = true;
  String _mensagemErro = '';
  int _totalParticipantes = 0;
  int _vagasDisponiveis = 0;

  @override
  void initState() {
    super.initState();
    _carregarParticipantes();
  }

  Future<void> _carregarParticipantes() async {
    setState(() {
      _carregandoParticipantes = true;
      _mensagemErro = '';
    });

    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        setState(() {
          _mensagemErro = 'Sessão expirada';
          _carregandoParticipantes = false;
        });
        return;
      }

      final url = Uri.parse(
        '${APIConfig.baseURL}/api/eventos/${widget.evento.id}/participantes/',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        
        final List<dynamic> participantesJson = data['participantes'];
        
        setState(() {
          _participantes = participantesJson
              .map((json) => Participante.fromJson(json))
              .toList();
          _totalParticipantes = data['total_participantes'];
          _vagasDisponiveis = data['vagas_disponiveis'];
          _carregandoParticipantes = false;
        });
      } else {
        setState(() {
          _mensagemErro = 'Erro ao carregar participantes';
          _carregandoParticipantes = false;
        });
      }
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro de conexão: $e';
        _carregandoParticipantes = false;
      });
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}h';
  }

  Widget _buildParticipanteCard(Participante participante) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.azulApoia.withOpacity(0.2),
              child: Text(
                participante.nome.isNotEmpty 
                    ? participante.nome[0].toUpperCase() 
                    : '?',
                style: TextStyle(
                  color: AppColors.azulApoia,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participante.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    participante.email,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (participante.telefone != null && 
                      participante.telefone!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          participante.telefone!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Inscrito em: ${_formatarData(participante.dataInscricao)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.laranjaApoia,
        title: const Text(
          'DETALHES DO EVENTO',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INFORMAÇÕES DO EVENTO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.laranjaApoia,
                    AppColors.laranjaApoia.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.evento.titulo.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatarData(widget.evento.date),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatarHora(widget.evento.date),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.evento.location,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.people,
                      label: 'Inscritos',
                      value: '$_totalParticipantes',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.event_seat,
                      label: 'Vagas Restantes',
                      value: '$_vagasDisponiveis',
                      color: _vagasDisponiveis > 0 
                          ? Colors.green 
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('EDITAR INFORMAÇÕES DO EVENTO'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulApoia,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarEventoTela(
                          eventoId: widget.evento.id.toString(),
                        ),
                      ),
                    );
                    
                    if (resultado == true) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.group,
                    color: AppColors.laranjaApoia,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LISTA DE PARTICIPANTES',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.azulApoia,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _carregandoParticipantes
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _mensagemErro.isNotEmpty
                      ? Center(
                          child: Column(
                            children: [
                              Text(
                                _mensagemErro,
                                style: const TextStyle(color: Colors.red),
                              ),
                              TextButton(
                                onPressed: _carregarParticipantes,
                                child: const Text('TENTAR NOVAMENTE'),
                              ),
                            ],
                          ),
                        )
                      : _participantes.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person_off,
                                      size: 50,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Nenhum participante inscrito ainda',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Column(
                              children: _participantes
                                  .map((p) => _buildParticipanteCard(p))
                                  .toList(),
                            ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}