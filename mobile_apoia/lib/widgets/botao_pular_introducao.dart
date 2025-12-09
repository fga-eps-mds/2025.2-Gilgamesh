import 'package:flutter/material.dart';
import 'package:mobile_apoia/telas/acesso/tela_login.dart';

class BotaoPular extends StatelessWidget {
  const BotaoPular({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaLogin()),
        );
      },
      child: const Text(
        "PULAR",
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
      ),
    );
  }
}
