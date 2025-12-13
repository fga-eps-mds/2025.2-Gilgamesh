import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/doador/tela_perfil_usuario.dart';
import 'package:mobile_apoia/telas/doador/visualizar_evento_doador.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '/models/event.dart';
import '/widgets/barra_inferior_superior_tela_doador.dart';
import '../../services/auth_service.dart';
import '../../services/participacao_service.dart';

class MeusEventosTela extends StatefulWidget {
  const MeusEventosTela({super.key});

  @override
  State<MeusEventosTela> createState() => _MeusEventosTelaState();
}

class _MeusEventosTelaState extends State<MeusEventosTela> {
  final AuthService _authService = AuthService();
  final ParticipationService _participationService = ParticipationService();
  
  List<Event> _eventosInscritos = [];
  bool _carregando = true;
  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    _carregarEventosInscritos();
  }

  Future<void> _carregarEventosInscritos() async {
    setState(() {
      _carregando = true;
      _mensagemErro = null;
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

      final eventos = await _participationService.buscarMeusEventos(token);
      
      setState(() {
        _eventosInscritos = eventos;
        _carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar eventos inscritos: $e');
      setState(() {
        _mensagemErro = 'Erro ao carregar eventos. Tente novamente.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SuperiorBarDoador(showBackButton: true),
      
      body: _carregando
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando seus eventos...'),
                ],
              ),
            )
          : _mensagemErro != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _mensagemErro!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _carregarEventosInscritos,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar Novamente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.azulApoia,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : _eventosInscritos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 80,
                            color: AppColors.azulApoia.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Você ainda não se inscreveu\nem nenhum evento.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.azulApoia,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Explorar Eventos'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _carregarEventosInscritos,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _eventosInscritos.length,
                        itemBuilder: (context, index) {
                          final event = _eventosInscritos[index];
                          
                          final eventoPassado = event.date.isBefore(DateTime.now());
                          
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () async {
                                final resultado = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalhesDoadorTela(
                                      event: event,
                                    ),
                                  ),
                                );
                                
                                if (resultado == true) {
                                  _carregarEventosInscritos();
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: eventoPassado
                                            ? Colors.grey.shade300
                                            : AppColors.laranjaApoia.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        eventoPassado
                                            ? Icons.event_available
                                            : Icons.calendar_today,
                                        color: eventoPassado
                                            ? Colors.grey
                                            : AppColors.laranjaApoia,
                                        size: 32,
                                      ),
                                    ),
                                    
                                    const SizedBox(width: 16),
                                    
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event.titulo,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: eventoPassado
                                                  ? Colors.grey
                                                  : AppColors.azulApoia,
                                              fontSize: 16,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.grey.shade600,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  event.location,
                                                  style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${_formatarData(event.date)} às ${_formatarHora(event.date)}',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (eventoPassado)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                'Evento realizado',
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 11,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
      
      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}