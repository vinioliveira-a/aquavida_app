import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Linha de opções em "pílulas" (ex.: 5 Min | 10 Min | 15 Min).
/// A opção escolhida fica azul.
class SeletorOpcoes extends StatelessWidget {
  const SeletorOpcoes({
    super.key,
    required this.opcoes,
    required this.selecionada,
    required this.onChanged,
  });

  final List<int> opcoes;
  final int selecionada;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < opcoes.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
              child: _Opcao(
                texto: '${opcoes[i]} Min',
                ativa: opcoes[i] == selecionada,
                onTap: () => onChanged(opcoes[i]),
              ),
            ),
          ),
      ],
    );
  }
}

class _Opcao extends StatelessWidget {
  const _Opcao({
    required this.texto,
    required this.ativa,
    required this.onTap,
  });

  final String texto;
  final bool ativa;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ativa ? AppColors.azulPrimario : AppColors.branco,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ativa ? AppColors.azulPrimario : AppColors.bordaInput,
            width: 1,
          ),
        ),
        child: Text(
          texto,
          style: TextStyle(fontFamily: 'Poppins', 
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ativa ? AppColors.branco : AppColors.azulEscuro,
          ),
        ),
      ),
    );
  }
}
