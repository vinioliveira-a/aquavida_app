import 'package:flutter/material.dart';

/// Botão azul arredondado de largura total (o estilo vem do AppTheme).
/// Com [carregando] = true mostra uma rodinha e fica desativado
/// (use enquanto espera a resposta da API).
class BotaoPrimario extends StatelessWidget {
  const BotaoPrimario({
    super.key,
    required this.texto,
    required this.onPressed,
    this.carregando = false,
  });

  final String texto;
  final VoidCallback? onPressed;
  final bool carregando;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40, // 116px no Figma
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        child: carregando
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(texto),
      ),
    );
  }
}
