import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Temas claro e escuro do app + estilos de cartões e campos.
/// A fonte Poppins vem da pasta assets/fonts (funciona sem internet).
class AppTheme {
  AppTheme._();

  // ---------------- TEMA CLARO ----------------
  static final ThemeData light = _criar(
    fundo: AppColors.fundoTela,
    cores: const ColorScheme.light(
      primary: AppColors.azulPrimario, // botões, ícones e destaques
      onPrimary: Colors.white,
      primaryContainer: AppColors.azulClaro, // fundo dos ícones redondos
      onPrimaryContainer: Color(0xFF1E3A8A),
      secondary: AppColors.azulSecundario,
      onSecondary: Colors.white,
      surface: Colors.white, // cartões
      onSurface: AppColors.azulEscuro, // textos principais
      onSurfaceVariant: AppColors.cinzaTexto, // textos secundários
      outline: Color(0xFF9CA3AF),
      outlineVariant: Color(0xFFE3E8F0), // bordas dos cartões
      error: AppColors.vermelho,
    ),
  );

  // ---------------- TEMA ESCURO ----------------
  static final ThemeData dark = _criar(
    fundo: AppColors.fundoEscuro,
    cores: const ColorScheme.dark(
      primary: Color(0xFF3B82F6),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF1E3A66),
      onPrimaryContainer: Color(0xFFBFDBFE),
      secondary: Color(0xFF60A5FA),
      onSecondary: Colors.white,
      surface: Color(0xFF1E293B),
      onSurface: Color(0xFFF1F5F9),
      onSurfaceVariant: Color(0xFF94A3B8),
      outline: Color(0xFF64748B),
      outlineVariant: Color(0xFF334155),
      error: Color(0xFFF87171),
    ),
  );

  static ThemeData _criar({
    required Color fundo,
    required ColorScheme cores,
  }) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      colorScheme: cores,
      scaffoldBackgroundColor: fundo,

      // Botão azul arredondado (estilo "pílula" do protótipo)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cores.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(40),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // Mensagens que aparecem na parte de baixo da tela
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Gradiente azul usado nos cartões de destaque.
  static const LinearGradient gradienteAzul = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2F6BEE), Color(0xFF5A8CF2)],
  );

  /// Visual padrão dos cartões (cantos arredondados e borda fina).
  static BoxDecoration decoracaoCartao(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: cores.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: cores.outlineVariant),
    );
  }

  /// Visual padrão dos campos de texto das telas internas.
  static InputDecoration decoracaoCampo(
    BuildContext context, {
    required String dica,
    String? sufixo,
    String? textoAjuda,
  }) {
    final cores = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: dica,
      suffixText: sufixo,
      helperText: textoAjuda,
      filled: true,
      fillColor: cores.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: cores.onSurfaceVariant, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cores.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cores.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cores.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: cores.error, width: 1.5),
      ),
    );
  }
}
