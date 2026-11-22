import 'package:flutter/material.dart';
import 'icone_circulo.dart';

/// Gota (Material Symbols: water_drop) dentro de um círculo azul claro.
/// Usada no topo das telas de login/cadastro.
class GotaAvatar extends StatelessWidget {
  const GotaAvatar({super.key, this.tamanho = 60});

  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return IconeCirculo(icone: Icons.water_drop_outlined, tamanho: tamanho);
  }
}
