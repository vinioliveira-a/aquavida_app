import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Ícone azul dentro de um círculo azul claro (gota, cadeado, escudo...).
class IconeCirculo extends StatelessWidget {
  const IconeCirculo({
    super.key,
    required this.icone,
    this.tamanho = 60,
    this.proporcao = 0.55,
  });

  final IconData icone;

  /// Diâmetro do círculo (Figma: 180px = 60dp).
  final double tamanho;

  /// Tamanho do ícone em relação ao círculo.
  final double proporcao;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamanho,
      height: tamanho,
      decoration: const BoxDecoration(
        color: AppColors.azulClaro,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icone,
        size: tamanho * proporcao,
        color: AppColors.azulPrimario,
      ),
    );
  }
}
