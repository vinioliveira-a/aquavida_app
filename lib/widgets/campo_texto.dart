import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';

/// Campo de texto com rótulo em cima (ex.: "E-mail*"), igual ao Figma.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.rotulo,
    required this.dica,
    this.controller,
    this.obscuro = false,
    this.tipoTeclado,
    this.formatadores,
  });

  final String rotulo;
  final String dica;
  final TextEditingController? controller;
  final bool obscuro;
  final TextInputType? tipoTeclado;
  final List<TextInputFormatter>? formatadores;

  OutlineInputBorder _borda(Color cor) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // 35px no Figma
        borderSide: BorderSide(color: cor, width: 1),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FittedBox: o rótulo nunca quebra em duas linhas
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            rotulo,
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.azulEscuro,
            ),
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: obscuro,
          keyboardType: tipoTeclado,
          inputFormatters: formatadores,
          style: TextStyle(fontFamily: 'Poppins', 
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.azulEscuro,
          ),
          decoration: InputDecoration(
            hintText: dica,
            hintStyle: TextStyle(fontFamily: 'Poppins', 
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.placeholder,
            ),
            filled: true,
            fillColor: AppColors.branco,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: _borda(AppColors.bordaInput),
            focusedBorder: _borda(AppColors.azulPrimario),
          ),
        ),
      ],
    );
  }
}
