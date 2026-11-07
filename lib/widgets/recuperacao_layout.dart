import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'botao_primario.dart';
import 'icone_circulo.dart';

/// Estrutura comum das telas de recuperação de senha: ícone no círculo,
/// título, subtítulo, conteúdo, botão e um rodapé opcional.
class RecuperacaoLayout extends StatelessWidget {
  const RecuperacaoLayout({
    super.key,
    required this.icone,
    required this.titulo,
    required this.textoBotao,
    required this.onContinuar,
    required this.child,
    this.carregando = false,
    this.subtitulo,
    this.destaque,
    this.rodape,
    this.proporcaoIcone = 0.55,
    this.espacoAposTitulo = 38,
    this.espacoAntesBotao = 40,
  });

  final IconData icone;
  final String titulo;
  final String? subtitulo;

  /// Linha em azul claro abaixo do subtítulo (ex.: o e-mail).
  final String? destaque;
  final String textoBotao;
  final VoidCallback onContinuar;
  final Widget child;

  /// true = botão com rodinha (esperando a API).
  final bool carregando;

  /// Widget abaixo do botão (ex.: "Lembrou a senha? Entrar").
  final Widget? rodape;
  final double proporcaoIcone;
  final double espacoAposTitulo;
  final double espacoAntesBotao;

  @override
  Widget build(BuildContext context) {
    final estiloSubtitulo = TextStyle(fontFamily: 'Poppins', 
      fontSize: 11, // 30px no Figma
      fontWeight: FontWeight.w600,
      color: AppColors.cinzaTexto,
      letterSpacing: 0.14,
    );

    return Scaffold(
      backgroundColor: AppColors.fundoTela,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 130),
              Center(
                child: IconeCirculo(icone: icone, proporcao: proporcaoIcone),
              ),
              const SizedBox(height: 38),

              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 20, // 56px no Figma
                  fontWeight: FontWeight.w600,
                  color: AppColors.azulEscuro,
                  letterSpacing: 0.26,
                ),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitulo!,
                  textAlign: TextAlign.center,
                  style: estiloSubtitulo,
                ),
              ],
              if (destaque != null)
                Text(
                  destaque!,
                  textAlign: TextAlign.center,
                  style: estiloSubtitulo.copyWith(color: AppColors.azulLink),
                ),
              SizedBox(height: espacoAposTitulo),

              child,

              SizedBox(height: espacoAntesBotao),
              BotaoPrimario(
                texto: textoBotao,
                onPressed: onContinuar,
                carregando: carregando,
              ),
              if (rodape != null) ...[
                const SizedBox(height: 8),
                rodape!,
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
