import 'package:flutter/material.dart';

import '../dados/dados_app.dart';

/// Uma linha que mostra um registro de água: ícone, quantidade e horário.
/// Usada na tela principal (registros recentes) e no histórico.
class ItemRegistro extends StatelessWidget {
  final RegistroAgua registro;

  const ItemRegistro({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Ícone de gota dentro de um círculo azul clarinho
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: cores.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.water_drop, color: cores.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DadosApp.formatarQuantidade(registro.quantidadeMl),
                  style: TextStyle(
                    color: cores.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Água',
                  style: TextStyle(color: cores.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            DadosApp.formatarHora(registro.dataHora),
            style: TextStyle(color: cores.onSurfaceVariant, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
