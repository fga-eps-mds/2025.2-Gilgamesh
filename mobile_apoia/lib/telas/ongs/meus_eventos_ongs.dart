import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/ongs/detalhes_evento_ong.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../../models/event.dart';
import '../../widgets/barra_inferior_e_superior.dart';
import '../../services/event_service.dart';
import '../../services/auth_service.dart';

class MeusEventosTelaONG extends StatefulWidget {
  const MeusEventosTelaONG({super.key});

  @override
  State<MeusEventosTelaONG> createState() => _MeusEventosTelaONGState();
}

class _MeusEventosTelaONGState extends State<MeusEventosTelaONG> {
  final EventService _eventService = EventService();
  final AuthService _authService = AuthService();
  
  List<Event> _meusEventos = [];
  bool _carregando = true;
  String _mensagemErro = '';

  @override
  void initState() {
    super.initState();
    _carregarMeusEventos();
  }

  Future<void> _carregarMeusEventos() async {
    setState(() {
      _carregando = true;
      _mensagemErro = '';
    });

    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        setState(() {
          _mensagemErro = 'Sessão expirada. Faça login novamente.';
          _carregando = false;
        });
        return;
      }

      final eventos = await _eventService.getMeusEventos(token);
      
      setState(() {
        _meusEventos = eventos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao carregar eventos: $e';
        _carregando = false;
      });
    }
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}h';
  }

  Widget _buildEventCard(Event evento) {
    final int vagasDisponiveis = evento.totalVagas - evento.participantes;
    final double percentualOcupacao = 
        evento.totalVagas > 0 ? (evento.participantes / evento.totalVagas) : 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalhesEventoONG(evento: evento),
            ),
          );
          
          if (resultado == true) {
            _carregarMeusEventos();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.azulApoia,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: vagasDisponiveis > 0 
                          ? Colors.green.shade100 
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vagasDisponiveis > 0 ? 'ATIVO' : 'LOTADO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: vagasDisponiveis > 0 
                            ? Colors.green.shade700 
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    _formatarData(evento.date),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    _formatarHora(evento.date),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      evento.location,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 20,
                        color: AppColors.laranjaApoia,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${evento.participantes} inscritos',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Vagas: ${evento.totalVagas}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percentualOcupacao,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentualOcupacao >= 0.8 
                        ? Colors.red 
                        : percentualOcupacao >= 0.5 
                            ? Colors.orange 
                            : Colors.green,
                  ),
                  minHeight: 8,
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.visibility, size: 18),
                  label: const Text('VER PARTICIPANTES E EDITAR'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.laranjaApoia,
                    side: BorderSide(color: AppColors.laranjaApoia),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesEventoONG(evento: evento),
                      ),
                    );
                    
                    if (resultado == true) {
                      _carregarMeusEventos();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperiorBar(showBackButton: true),
      
      body: RefreshIndicator(
        onRefresh: _carregarMeusEventos,
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _mensagemErro.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _mensagemErro,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _carregarMeusEventos,
                          child: const Text('TENTAR NOVAMENTE'),
                        ),
                      ],
                    ),
                  )
                : _meusEventos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 80,
                              color: AppColors.laranjaApoia.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Você ainda não criou nenhum evento.',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Crie seu primeiro evento para começar!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _meusEventos.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(_meusEventos[index]);
                        },
                      ),
      ),
      
      bottomNavigationBar: BottomNavBar(
        iconSelecionado: 1,
        onTap: (index) {},
      ),
    );
  }
}