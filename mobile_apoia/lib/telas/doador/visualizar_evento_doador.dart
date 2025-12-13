import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../../models/event.dart';
import '../../widgets/barra_inferior_superior_tela_doador.dart';
import 'sucesso_inscricao_tela.dart';
import '../../services/auth_service.dart';
import '../../services/participacao_service.dart';
import 'package:mobile_apoia/telas/doador/home_usuario.dart';

class DetalhesDoadorTela extends StatefulWidget {
  final Event event;

  const DetalhesDoadorTela({super.key, required this.event});

  @override
  State<DetalhesDoadorTela> createState() => _DetalhesDoadorTelaState();
}

class _DetalhesDoadorTelaState extends State<DetalhesDoadorTela> {
  int? _participacaoIdUsuario;

  bool _isLoading = false;
  bool _verificandoStatusInicial = true;

  late int _participantesAtuais;
  late int _totalVagas;

  final AuthService _authService = AuthService();
  final ParticipationService _participationService = ParticipationService();

  @override
  void initState() {
    super.initState();
    _participantesAtuais = widget.event.participantes;
    _totalVagas = widget.event.totalVagas;
    _carregarDadosCompletos();
  }

  Future<void> _carregarDadosCompletos() async {
    final token = await _authService.getToken();
    if (token == null) {
      if (mounted) setState(() => _verificandoStatusInicial = false);
      return;
    }

    int idEvento = int.parse(widget.event.id.toString());

    final eventoAtualizado = await _participationService.buscarEventoPorId(
      idEvento,
      token,
    );
    
    final idParticipacao = await _participationService
        .verificarParticipacaoUsuario(idEvento, token);

    if (mounted) {
      setState(() {
        if (eventoAtualizado != null) {
          _participantesAtuais = eventoAtualizado.participantes;
          _totalVagas = eventoAtualizado.totalVagas;
        }
        _participacaoIdUsuario = idParticipacao;

        if (_participacaoIdUsuario != null && _participantesAtuais == 0) {
          _participantesAtuais = 1;
        }

        _verificandoStatusInicial = false;
      });
    }
  }

  void _gerenciarInscricao() async {
    setState(() => _isLoading = true);
    final token = await _authService.getToken();
    int idEvento = int.parse(widget.event.id.toString());

    if (_participacaoIdUsuario == null) {
      await _realizarInscricao(idEvento, token!);
    } else {
      await _cancelarInscricao(token!);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _realizarInscricao(int idEvento, String token) async {
    final resultado = await _participationService.participar(idEvento, token);

    if (resultado == ResultadoParticipacao.sucesso) {
      final novoId = await _participationService.verificarParticipacaoUsuario(
        idEvento,
        token,
      );

      setState(() {
        _participantesAtuais++;
        _participacaoIdUsuario = novoId;
      });

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SucessoInscricaoTela()),
      );
    } else if (resultado == ResultadoParticipacao.jaInscrito) {
      final idExistente = await _participationService
          .verificarParticipacaoUsuario(idEvento, token);

      setState(() {
        _participacaoIdUsuario = idExistente;

        if (_participantesAtuais == 0) {
          _participantesAtuais = 1;
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você já estava inscrito! Atualizando tela..."),
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao participar.")));
    }
  }

  Future<void> _cancelarInscricao(String token) async {
    if (_participacaoIdUsuario == null) return;

    final sucesso = await _participationService.cancelarParticipacao(
      _participacaoIdUsuario!,
      token,
    );

    if (sucesso) {
      setState(() {
        if (_participantesAtuais > 0) {
          _participantesAtuais--;
        }

        _participacaoIdUsuario = null;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inscrição cancelada com sucesso.")),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao cancelar. Tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatarData(DateTime data) =>
      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  String _formatarHora(DateTime data) =>
      "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.azulApoia, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool usuarioEstaInscrito = _participacaoIdUsuario != null;

    final String buttonText = usuarioEstaInscrito
        ? 'CANCELAR PARTICIPAÇÃO'
        : 'PARTICIPAR DO EVENTO';
    final Color buttonColor = usuarioEstaInscrito
        ? Colors.redAccent
        : AppColors.azulApoia;

    // Calcula vagas
    final int vagasRestantes = _totalVagas - _participantesAtuais;
    final int vagasDisplay = vagasRestantes > _totalVagas
        ? _totalVagas
        : (vagasRestantes < 0 ? 0 : vagasRestantes);

    return Scaffold(
      appBar: const SuperiorBarDoador(showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.event.titulo.toUpperCase(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.azulApoia,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ORGANIZADO PELA ONG #${widget.event.ongId}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.laranjaApoia,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.event.descricao.isEmpty
                      ? "Sem descrição."
                      : widget.event.descricao,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 1),

              _buildDetailRow(
                Icons.location_on,
                'LOCALIZAÇÃO',
                widget.event.location,
              ),
              _buildDetailRow(
                Icons.calendar_month,
                'DATA',
                _formatarData(widget.event.date),
              ),
              _buildDetailRow(
                Icons.access_time,
                'HORÁRIO',
                "${_formatarHora(widget.event.date)} Horas",
              ),

              _verificandoStatusInicial
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _buildDetailRow(
                      Icons.group,
                      'VAGAS DISPONÍVEIS',
                      "$vagasDisplay restantes (Total: $_totalVagas)",
                    ),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _gerenciarInscricao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 0,
        onTap: (index) {},
      ),
    );
  }
}
