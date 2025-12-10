import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '../../models/event.dart';
import '../../widgets/barra_inferior_superior_tela_doador.dart';
import 'sucesso_inscricao_tela.dart';

class DetalhesDoadorTela extends StatefulWidget {
  final Event event;

  const DetalhesDoadorTela({super.key, required this.event});

  @override
  State<DetalhesDoadorTela> createState() => _DetalhesDoadorTelaState();
}

class _DetalhesDoadorTelaState extends State<DetalhesDoadorTela> {
  bool _estaParticipando = false;

  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
  }

  String _formatarHora(DateTime data) {
    return "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
  }

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
                  value, // Ex: "Rua X, Cidade Y"
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

  void _lidarComParticipacao() async {
    // Lógica futura: chamar o serviço para incremetar 'participantes' no backend

    if (!_estaParticipando) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SucessoInscricaoTela()),
      );

      if (!mounted) return;

      setState(() {
        _estaParticipando = true;
      });
    } else {
      setState(() {
        _estaParticipando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Sua participação foi cancelada.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.laranjaApoia,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String buttonText = _estaParticipando
        ? 'CANCELAR PARTICIPAÇÃO'
        : 'PARTICIPAR DO EVENTO';
    final Color buttonColor = _estaParticipando
        ? AppColors.laranjaApoia
        : AppColors.azulApoia;

    // Calcula vagas restantes (apenas visual por enquanto)
    final int vagasRestantes =
        widget.event.totalVagas - widget.event.participantes;

    return Scaffold(
      appBar: const SuperiorBarDoador(showBackButton: true),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Área Principal
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //  Título do Evento
                  Text(
                    widget.event.titulo.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.azulApoia,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ONG Responsável (Usando ID por enquanto ou nome se tiver no model)
                  Text(
                    'ORGANIZADO PELA ONG #${widget.event.ongId}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.laranjaApoia,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
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
                          ? "Sem descrição informada."
                          : widget.event.descricao,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),

                  // Endereço / Localização
                  _buildDetailRow(
                    Icons.location_on,
                    'LOCALIZAÇÃO',
                    widget.event.location,
                  ),

                  //  Data
                  _buildDetailRow(
                    Icons.calendar_month,
                    'DATA',
                    _formatarData(widget.event.date),
                  ),

                  //  Horário
                  _buildDetailRow(
                    Icons.access_time,
                    'HORÁRIO',
                    "${_formatarHora(widget.event.date)} Horas",
                  ),

                  // Vagas
                  _buildDetailRow(
                    Icons.group,
                    'VAGAS DISPONÍVEIS',
                    "$vagasRestantes restantes (Total: ${widget.event.totalVagas})",
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _lidarComParticipacao,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
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
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 0,
        onTap: (index) {},
      ),
    );
  }
}
