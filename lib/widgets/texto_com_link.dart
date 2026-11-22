import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Linha centralizada com texto cinza e link azul.
/// Ex.: "Ainda não possui conta? Registre-se".
class TextoComLink extends StatelessWidget {
  const TextoComLink({
    super.key,
    required this.texto,
    required this.link,
    required this.onTap,
  });

  final String texto;
  final String link;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(fontFamily: 'Poppins', 
      fontSize: 12.5, // 35px no Figma
      fontWeight: FontWeight.w600,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('$texto ', style: base.copyWith(color: AppColors.cinzaTexto)),
        InkWell(
          onTap: onTap,
          child: Text(link, style: base.copyWith(color: AppColors.azulLink)),
        ),
      ],
    );
  }
}
