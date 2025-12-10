import 'package:flutter/material.dart';
import 'package:mobile_apoia/widgets/cores.dart';
import '/models/event.dart'; 
import '/widgets/barra_inferior_superior_tela_doador.dart'; 
import 'sucesso_inscricao_tela.dart';
//import '/widgets/cores.dart'; 

class DetalhesDoadorTela extends StatefulWidget {
  final Event event;

   const DetalhesDoadorTela({super.key, required this.event});

  @override
  State<DetalhesDoadorTela> createState() => _DetalhesDoadorTelaState();
}

class _DetalhesDoadorTelaState extends State<DetalhesDoadorTela> {
 bool _estaParticipando = false; 

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.azulApoia, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _lidarComParticipacao() async {
    if (!_estaParticipando) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SucessoInscricaoTela()),
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
      SnackBar(
        content: const Text('Sua participação foi cancelada com sucesso.',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.laranjaApoia,
        duration: Duration(seconds: 2),
      ),
    );
    print('Participação cancelada para o evento: ${widget.event.titulo}');
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



    return Scaffold(
      appBar: const SuperiorBarDoador(showBackButton: true),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //Container(
              //height: 200,
              //color: Colors.grey.shade300,
              //alignment: Alignment.center,
              //child: const Text(
                //'FOTO DE DIVULGAÇÃO DA CAMPANHA',
                //style: TextStyle(
                 //color: Colors.black54,
                 // fontWeight: FontWeight.bold,
                 // fontSize: 16,
                //),
              //),
            //),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Título e ONG Responsável
                  Text(
                    widget.event.titulo.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.azulApoia,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'ONG RESPONSÁVEL',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.laranjaApoia,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  Text(
                    widget.event.descricao,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 30),

                  const Divider(),

                  _buildDetailRow(
                    Icons.location_on,
                    'LOCALIZAÇÃO: ${widget.event.location}',
                  ),

                  _buildDetailRow(Icons.access_time, 'HORÁRIO: 08:00 HORAS'),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _lidarComParticipacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:buttonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child:  Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
