import 'package:flutter/material.dart';

//Barra de pesquisa
class BarraDePesquisa extends StatelessWidget {
  final Function(String) onChanged;
  final VoidCallback onTap;

  const BarraDePesquisa({
    super.key,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 26, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onTap: onTap,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: "Buscar Campanhas, ONGs ou Eventos",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
