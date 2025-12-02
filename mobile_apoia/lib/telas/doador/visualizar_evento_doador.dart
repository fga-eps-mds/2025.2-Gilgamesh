import 'package:flutter/material.dart';
import '/models/event.dart'; 
import '/widgets/barra_inferior_superior_tela_doador.dart'; 
import 'sucesso_inscricao_tela.dart'; 

const Color corAzulPrincipal = Color(0xFF007AFF);
const Color corLaranjaONG = Color(0xFFFF9900); 

class DetalhesDoadorTela extends StatelessWidget {
  final Event event;

  const DetalhesDoadorTela({super.key, required this.event});


  Widget _buildDetailRow(IconData icon, String text) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: corAzulPrincipal, size: 28), 
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

  void _confirmarParticipacao(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SucessoInscricaoTela(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: const SuperiorBarDoador(showBackButton: true), 
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            Container(
              height: 200,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Text(
                'FOTO DE DIVULGAÇÃO DA CAMPANHA',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Título e ONG Responsável
                  Text(
                    event.nome.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: corAzulPrincipal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'ONG RESPONSÁVEL', 
                    style: TextStyle(
                      fontSize: 16,
                      color: corLaranjaONG,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  Text(
                    event.descricao,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 30),

                  const Divider(),
                  
                  _buildDetailRow(
                    Icons.location_on,
                    'LOCALIZAÇÃO: ${event.location}',
                  ),

                
                  _buildDetailRow(
                    Icons.access_time,
                    'HORÁRIO: 08:00 HORAS', 
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: () => _confirmarParticipacao(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corAzulPrincipal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'PARTICIPAR DO EVENTO',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        onTap: (index) {
          
        },
      ),
    ); 
  }
}