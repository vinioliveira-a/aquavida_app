import 'package:flutter/material.dart';

import '../dados/dados_app.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';

/// Cartão azul da tela principal com o círculo de progresso do dia.
///
/// Recebe quanto foi consumido e qual é a meta (os dois em ml).
class CartaoProgresso extends StatelessWidget {
  final int consumidoMl;
  final int metaMl;

  const CartaoProgresso({
    super.key,
    required this.consumidoMl,
    required this.metaMl,
  });

  @override
  Widget build(BuildContext context) {
    // Progresso de 0.0 (nada) até 1.0 (meta completa)
    double progresso = 0;
    int porcentagem = 0;
    if (metaMl > 0) {
      progresso = consumidoMl / metaMl;
      porcentagem = (consumidoMl * 100 / metaMl).round();
    }
    if (progresso > 1) {
      progresso = 1; // o círculo não passa de uma volta completa
    }
    bool metaAtingida = consumidoMl >= metaMl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: AppTheme.gradienteAzul,
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: Column(
        children: [
          const Text(
            'Consumo de hoje',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          // Círculo de progresso com o texto no meio (Stack = um em cima do outro)
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: progresso,
                    strokeWidth: 8,
                    color: Colors.white,
                    backgroundColor: AppColors.brancoTransparente,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DadosApp.formatarQuantidade(consumidoMl),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'de ${DadosApp.formatarQuantidade(metaMl)}',
                      style: const TextStyle(
                        color: AppColors.brancoSuave,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            metaAtingida
                ? '$porcentagem% da meta • Meta atingida!'
                : '$porcentagem% da meta',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
