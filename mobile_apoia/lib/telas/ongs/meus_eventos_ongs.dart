import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/doador/tela_perfil_usuario.dart';
import 'package:mobile_apoia/telas/ongs/tela_perfil_ong.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '/models/event.dart';
import 'package:mobile_apoia/widgets/barra_inferior_e_superior.dart';

class _ParticipacaoManager extends ChangeNotifier {
  //  armazena os IDs dos eventos que o doador está participando
  final Set<int> _eventosParticipadosIds = {};

  List<Event> _eventosCompletos = [];

  void _atualizarLista(List<Event> todosEventos) {
    _eventosCompletos = todosEventos
        .where((event) => _eventosParticipadosIds.contains(event.id))
        .toList();
    notifyListeners();
  }

  void adicionarParticipacao(Event event, List<Event> todosEventos) {
    if (_eventosParticipadosIds.add(event.id)) {
      _atualizarLista(todosEventos);
    }
  }

  void removerParticipacao(Event event, List<Event> todosEventos) {
    if (_eventosParticipadosIds.remove(event.id)) {
      _atualizarLista(todosEventos);
    }
  }

  bool estaParticipando(int eventId) {
    return _eventosParticipadosIds.contains(eventId);
  }

  List<Event> get eventosDoDoador => _eventosCompletos;
}

final _participacaoManager = _ParticipacaoManager();

final List<Event> mockTodosEventos = [
  Event(
    id: 1,
    titulo: 'Limpeza da Praia Central',
    descricao:
        'Ajude a recolher lixo e conscientizar sobre o descarte correto de resíduos plásticos.',
    date: DateTime.now().add(const Duration(days: 7)),
    location: 'Praia Central, Bloco B',
    totalVagas: 50,
    participantes: 25,
    ongId: 101,
  ),
  Event(
    id: 2,
    titulo: 'Campanha de Doação de Sangue',
    descricao: 'Um dia dedicado a salvar vidas no hospital municipal.',
    date: DateTime.now().add(const Duration(days: 14)),
    location: 'Hospital Municipal - Sala 3',
    totalVagas: 30,
    participantes: 30,
    ongId: 102,
  ),
  Event(
    id: 3,
    titulo: 'Arrecadação de Roupas',
    descricao: 'Organização e triagem de roupas doadas para distribuição.',
    date: DateTime.now().add(const Duration(days: 21)),
    location: 'Centro Comunitário São José',
    totalVagas: 20,
    participantes: 5,
    ongId: 103,
  ),
];

class MeusEventosTelaONG extends StatelessWidget {
  const MeusEventosTelaONG({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      // Escuta as mudanças no gerenciador para reconstruir a lista
      listenable: _participacaoManager,
      builder: (context, child) {
        final List<Event> eventos = _participacaoManager.eventosDoDoador;

        return Scaffold(
          appBar: const SuperiorBar(
            showBackButton: false,
            // title: 'MEUS EVENTOS',
          ),

          body: eventos.isEmpty
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
                        'Você ainda não criou nenhum evento.',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    final event = eventos[index];

                    // Formata a data e horário
                    final String dataFormatada =
                        'Data: ${event.date.day.toString().padLeft(2, '0')}/${event.date.month.toString().padLeft(2, '0')} - Horário: 08:00h';

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_today,
                          color: AppColors.laranjaApoia,
                          size: 32,
                        ),
                        title: Text(
                          event.titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.azulApoia,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          dataFormatada,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          // Ao clicar, navega de volta à tela de detalhes
                          Navigator.pop(context, event);
                        },
                      ),
                    );
                  },
                ),

          // Mantendo a barra inferior padrão
          bottomNavigationBar: BottomNavBar(
            iconSelecionado: 0,
            onTap: (index) {
              if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaPerfilONG()),
                );
              }
            },
          ),
        );
      },
    );
  }
}
