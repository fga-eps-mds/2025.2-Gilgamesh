import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/doador/sucesso_inscricao_tela.dart';
import '../../models/ong.dart';
import 'package:mobile_apoia/widgets/barra_inferior_superior_tela_doador.dart';
import 'package:mobile_apoia/telas/doador/tela_perfil_usuario.dart';

const Color corAzulTexto = Color(0xFF007AFF);
const Color corLaranjaONG = Color(0xFFFF9900);

class PerfilOngTela extends StatelessWidget {
  final Ong ong;

  const PerfilOngTela({super.key, required this.ong});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBarDoador(
        iconSelecionado: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TelaPerfilUsuario(),
              ),
            );
          }
        },
      ),

      appBar: AppBar(
        backgroundColor: corAzulTexto,
        title: Text(
          ong.nome.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // avatar
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(color: corLaranjaONG, width: 4),
                ),
                child: Center(
                  child: Text(
                    ong.nome.isNotEmpty ? ong.nome[0].toUpperCase() : "?",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: corAzulPrincipal,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // nome
            Text(
              ong.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: corAzulTexto,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
            const Divider(),

            // informações
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildInfoTile(Icons.email, "E-mail", ong.email),
                  _buildInfoTile(
                    Icons.location_on,
                    "Endereço",
                    ong.endereco.isEmpty ? "Não informado" : ong.endereco,
                  ),

                  _buildInfoTile(Icons.phone, "Telefone", ong.telefone),
                  _buildInfoTile(Icons.info, "Sobre", ong.descricao),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: corAzulTexto, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
