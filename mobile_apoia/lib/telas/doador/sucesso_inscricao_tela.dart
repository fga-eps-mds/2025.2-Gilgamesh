import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/doador/home_usuario.dart';

const Color corAzulPrincipal = Color(0xFF007AFF);
const Color corLaranjaSecundaria = Color(0xFFFF9900);

class SucessoInscricaoTela extends StatelessWidget {
  const SucessoInscricaoTela({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corAzulPrincipal,
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'SUA PRESENÇA NO EVENTO FOI CONFIRMADA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: corAzulPrincipal,
                ),
              ),
              const SizedBox(height: 15),

              Icon(
                Icons.check_circle,
                color: Colors.lightGreen.shade600,
                size: 100,
              ),
              const SizedBox(height: 15),

              const Text(
                'Apoia+ agradece sua participação! Juntos, fazemos a diferença.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeUsuario(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('VOLTAR PARA O INÍCIO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
