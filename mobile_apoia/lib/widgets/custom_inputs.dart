import 'package:flutter/material.dart';

Widget buildCustomInput({
  required IconData icon,
  required String hintText,
  required Color corFundoIcone,
  required Color corFundoInput,
  bool isPassword = false,
}) {
  return Row(
    children: [
      Container(
        width: 60,
        height: 60,
        color: corFundoIcone,
        child: Icon(icon, color: Colors.black87, size: 28),
      ),
      Expanded(
        child: Container(
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: corFundoInput,
          child: TextField(
            obscureText: isPassword, // Se for senha, esconde o texto
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black45),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    ],
  );
}
