import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Campo com rótulo que abre o seletor de horário ao tocar.
class SeletorHorario extends StatelessWidget {
  const SeletorHorario({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.onChanged,
  });

  final String rotulo;
  final TimeOfDay? valor;
  final ValueChanged<TimeOfDay> onChanged;

  String _formatar(TimeOfDay h) =>
      '${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}';

  Future<void> _escolher(BuildContext context) async {
    final escolhido = await showTimePicker(
      context: context,
      initialTime: valor ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (ctx, child) => MediaQuery(
        data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (escolhido != null) onChanged(escolhido);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: TextStyle(fontFamily: 'Poppins', 
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.azulEscuro,
          ),
        ),
        const SizedBox(height: 7),
        InkWell(
          onTap: () => _escolher(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.branco,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.bordaInput, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  valor == null ? 'Horário' : _formatar(valor!),
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: valor == null
                        ? AppColors.placeholder
                        : AppColors.azulEscuro,
                  ),
                ),
                const Icon(Icons.expand_more, size: 18, color: Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
