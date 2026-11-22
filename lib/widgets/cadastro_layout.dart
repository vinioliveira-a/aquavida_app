import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'botao_primario.dart';
import 'gota_avatar.dart';

/// Estrutura comum das telas de cadastro: topo (voltar + "Passo X de 3"),
/// gota, título, subtítulo, conteúdo da tela e botão no final.
class CadastroLayout extends StatelessWidget {
  const CadastroLayout({
    super.key,
    required this.passo,
    required this.titulo,
    required this.subtitulo,
    required this.textoBotao,
    required this.onContinuar,
    required this.child,
    this.carregando = false,
    this.espacoLogoTitulo = 12,
    this.espacoAposTitulo = 50,
  });

  final int passo;
  final String titulo;
  final String subtitulo;
  final String textoBotao;
  final VoidCallback onContinuar;
  final Widget child;

  /// true = botão com rodinha (esperando a API).
  final bool carregando;

  /// Espaço entre a gota e o título.
  final double espacoLogoTitulo;

  /// Espaço entre o subtítulo e o conteúdo.
  final double espacoAposTitulo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoTela,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Topo: voltar + badge do passo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  _BadgePasso(passo: passo),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 84),
                      const Center(child: GotaAvatar()),
                      SizedBox(height: espacoLogoTitulo),

                      Text(
                        titulo,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 19, // 54px no Figma
                          fontWeight: FontWeight.w600,
                          color: AppColors.azulEscuro,
                          letterSpacing: 0.25,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitulo,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 11, // 30px no Figma
                          fontWeight: FontWeight.w600,
                          color: AppColors.cinzaTexto,
                          letterSpacing: 0.14,
                        ),
                      ),
                      SizedBox(height: espacoAposTitulo),

                      child,

                      const SizedBox(height: 52),
                      BotaoPrimario(
                texto: textoBotao,
                onPressed: onContinuar,
                carregando: carregando,
              ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgePasso extends StatelessWidget {
  const _BadgePasso({required this.passo});

  final int passo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.azulClaro,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Passo $passo de 3',
        style: TextStyle(fontFamily: 'Poppins', 
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.azulPrimario,
        ),
      ),
    );
  }
}
