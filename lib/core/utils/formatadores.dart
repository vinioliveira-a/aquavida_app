import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Aplica a máscara DD/MM/AAAA enquanto a pessoa digita.
class DataInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue antigo,
    TextEditingValue novo,
  ) {
    final digitos = novo.text.replaceAll(RegExp(r'\D'), '');
    final limitado = digitos.length > 8 ? digitos.substring(0, 8) : digitos;

    final buffer = StringBuffer();
    for (var i = 0; i < limitado.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(limitado[i]);
    }

    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

/// DateTime -> "DD/MM/AAAA".
String dataParaTexto(DateTime d) {
  final dia = d.day.toString().padLeft(2, '0');
  final mes = d.month.toString().padLeft(2, '0');
  return '$dia/$mes/${d.year}';
}

/// TimeOfDay -> "HH:mm" (formato que vai para a API).
String horaParaTexto(TimeOfDay h) {
  return '${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}';
}

/// "HH:mm" -> TimeOfDay (ou null se vazio/inválido).
TimeOfDay? textoParaHora(String? texto) {
  if (texto == null) return null;
  final partes = texto.split(':');
  if (partes.length < 2) return null;
  final h = int.tryParse(partes[0]);
  final m = int.tryParse(partes[1]);
  if (h == null || m == null) return null;
  return TimeOfDay(hour: h, minute: m);
}
