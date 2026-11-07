import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Tela inicial (Figma: TelaInicial, frame 1080x2400).
/// A imagem de fundo já contém o gradiente, a logo e a ilustração.
/// Texto e botão ficam por cima, posicionados proporcionalmente à altura.
class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final estiloTitulo = TextStyle(fontFamily: 'Poppins', 
      fontSize: 13, // 36px no Figma
      fontWeight: FontWeight.w600,
      color: AppColors.azulEscuro,
      letterSpacing: 0.17,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;

          return Stack(
            children: [
              // Fundo: gradiente + logo + ilustração
              Positioned.fill(
                child: Image.asset(
                  'assets/images/fundo_inicial.png',
                  fit: BoxFit.cover,
                ),
              ),

              // Slogan (Figma: y = 860 de 2400)
              Positioned(
                top: h * (860 / 2400),
                left: 20,
                right: 20,
                child: Text(
                  'Seu parceiro diário para uma vida mais saudável.',
                  textAlign: TextAlign.center,
                  style: estiloTitulo,
                ),
              ),

              // Botão Começar (Figma: y = 1958 de 2400)
              Positioned(
                top: h * (1958 / 2400),
                left: 20,
                right: 20,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Começar'),
                ),
              ),

              // Frase final (Figma: y = 2103 de 2400)
              Positioned(
                top: h * (2103 / 2400),
                left: 20,
                right: 20,
                child: Text(
                  'Vamos cuidar da sua hidratação.',
                  textAlign: TextAlign.center,
                  style: estiloTitulo,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
