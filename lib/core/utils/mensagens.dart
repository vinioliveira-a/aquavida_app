import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Mostra uma mensagem rápida na parte de baixo da tela (SnackBar).
///
/// - Verde: confirmação (ex.: "Água registrada!")
/// - Vermelha: erro (ex.: "Escolha uma quantidade")
///
/// Exemplo:
///   mostrarMensagem(context, 'Meta atualizada!');
///   mostrarMensagem(context, 'Preencha o campo', erro: true);
void mostrarMensagem(BuildContext context, String texto, {bool erro = false}) {
  // Esconde a mensagem anterior (se tiver) para não acumular
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: erro ? AppColors.vermelho : AppColors.verde,
      duration: const Duration(seconds: 2),
      content: Row(
        children: [
          Icon(
            erro ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}
