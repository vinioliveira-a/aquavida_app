import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'dados/dados_app.dart';
import 'screens/tela_adicionar_agua.dart';
import 'screens/tela_cadastro_passo1.dart';
import 'screens/tela_cadastro_passo2.dart';
import 'screens/tela_cadastro_passo3.dart';
import 'screens/tela_codigo_seguranca.dart';
import 'screens/tela_configuracoes.dart';
import 'screens/tela_estatisticas.dart';
import 'screens/tela_historico.dart';
import 'screens/tela_inicial.dart';
import 'screens/tela_login.dart';
import 'screens/tela_nova_senha.dart';
import 'screens/tela_perfil.dart';
import 'screens/tela_principal.dart';
import 'screens/tela_recuperar_senha.dart';

void main() => runApp(const AquaVidaApp());

class AquaVidaApp extends StatelessWidget {
  const AquaVidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder "escuta" DadosApp.temaEscuro: quando a pessoa
    // liga/desliga o tema escuro nas configurações, o app troca de tema.
    return ValueListenableBuilder<bool>(
      valueListenable: DadosApp.temaEscuro,
      builder: (context, escuro, child) {
        return MaterialApp(
          title: 'AquaVida',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: escuro ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            // Entrada
            '/': (_) => const TelaInicial(),
            '/login': (_) => const TelaLogin(),

            // Cadastro (3 passos)
            '/cadastro/passo1': (_) => const TelaCadastroPasso1(),
            '/cadastro/passo2': (_) => const TelaCadastroPasso2(),
            '/cadastro/passo3': (_) => const TelaCadastroPasso3(),

            // Recuperação de senha
            '/recuperar-senha': (_) => const TelaRecuperarSenha(),
            '/recuperar-senha/codigo': (_) => const TelaCodigoSeguranca(),
            '/recuperar-senha/nova': (_) => const TelaNovaSenha(),

            // Dentro do app (depois do login)
            '/home': (_) => const TelaPrincipal(),
            '/adicionar-agua': (_) => const TelaAdicionarAgua(),
            '/historico': (_) => const TelaHistorico(),
            '/estatisticas': (_) => const TelaEstatisticas(),
            '/configuracoes': (_) => const TelaConfiguracoes(),
            '/perfil': (_) => const TelaPerfil(),
          },
        );
      },
    );
  }
}
