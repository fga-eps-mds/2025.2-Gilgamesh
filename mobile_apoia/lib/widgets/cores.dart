import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- CORES INSTITUCIONAIS (Do Onboarding e Splash) ---
  static const Color verdePrincipal = Color(0xFF5ABF86);
  static const Color azulTexto = Color(0xFF2E8EB6);

  // --- CORES DE BOTÕES E GRADIENTES (Login e Cadastro) ---
  static const Color verdeGradiente1 = Color(0xFF4DB6AC);
  static const Color verdeGradiente2 = Color(0xFF2E8EB6);
  static const Color laranjaApoia = Color(0xFFFF9800); // O "+" do logo e o "OU"
  static const Color laranjaBotao = Color(0xFFEAA648); // Botão ONG
  static const Color azulBotao = Color(0xFF2E7DB5); // Botão Doador

  // --- CORES NEUTRAS (Cinzas) ---
  static const Color cinzaEscuroIcone = Color(0xFF666666);
  static const Color cinzaInativo = Color(0xFFDDDDDD);
  static const Color cinzaInputFundo = Color(0xFFD9D9D9); // Fundo dos inputs
  static const Color cinzaBordaIcone = Color(0xFFD9D9D9);
  static const Color corCinzaIcone = Color(0xFFD9D9D9);
  static const Color corCinzaAtivo = Color(0xFF666666);
  static const Color corCinzaInativo = Color(
    0xFFDDDDDD,
  ); // Caixinha do ícone no login
}
