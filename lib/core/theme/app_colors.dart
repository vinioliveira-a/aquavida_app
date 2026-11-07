import 'package:flutter/material.dart';

/// Cores extraídas do Figma (AquaVida).
class AppColors {
  AppColors._();

  static const Color azulEscuro = Color(0xFF002258); // títulos e textos
  static const Color azulPrimario = Color(0xFF2563EB); // botões e ícones
  static const Color azulClaro = Color(0xFFDBEAFE); // círculo dos ícones
  static const Color azulSecundario = Color(0xFF5B8DEF); // detalhes
  static const Color azulLink = Color(0xFF7AB1FB); // links (Registre-se...)
  static const Color fundoTela = Color(0xFFF5F8FC); // fundo (tema claro)
  static const Color fundoEscuro = Color(0xFF0F172A); // fundo (tema escuro)
  static const Color cinzaTexto = Color(0xFF4B5563); // subtítulos
  static const Color bordaInput = Color(0xFFCBD5E1); // borda dos campos
  static const Color placeholder = Color(0xFFB8B8B8); // texto de dica
  static const Color branco = Colors.white;

  static const Color verde = Color(0xFF16A34A); // sucesso / meta atingida
  static const Color vermelho = Color(0xFFE53935); // erro / sair

  // Branco com transparência (usado dentro do cartão azul)
  static const Color brancoTransparente = Color(0x40FFFFFF);
  static const Color brancoSuave = Color(0xDDFFFFFF);
}
