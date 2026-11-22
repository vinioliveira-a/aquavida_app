import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Cartão branco com texto e interruptor (ex.: "Ativar lembretes").
class CartaoSwitch extends StatelessWidget {
  const CartaoSwitch({
    super.key,
    required this.texto,
    required this.valor,
    required this.onChanged,
  });

  final String texto;
  final bool valor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43,
      padding: const EdgeInsets.only(left: 14, right: 8),
      decoration: BoxDecoration(
        color: AppColors.branco,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bordaInput, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            texto,
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.azulEscuro,
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: valor,
              onChanged: onChanged,
              activeTrackColor: AppColors.azulPrimario,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              trackOutlineColor: WidgetStateProperty.resolveWith(
                (estados) => estados.contains(WidgetState.selected)
                    ? AppColors.azulPrimario
                    : const Color(0xFFB0B0B0),
              ),
              thumbColor: WidgetStateProperty.resolveWith(
                (estados) => estados.contains(WidgetState.selected)
                    ? AppColors.branco
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
