import 'package:flutter/material.dart';

import '../screens/tela_configuracoes.dart';
import '../screens/tela_estatisticas.dart';
import '../screens/tela_principal.dart';

/// Menu de navegação inferior (Início, Estatísticas e Configurações).
///
/// Cada tela coloca esta barra no seu Scaffold, informando qual aba
/// deve aparecer selecionada:
///   bottomNavigationBar: const BarraNavegacao(indiceAtual: 0),
class BarraNavegacao extends StatelessWidget {
  // 0 = Início, 1 = Estatísticas, 2 = Configurações
  final int indiceAtual;

  const BarraNavegacao({super.key, required this.indiceAtual});

  /// Abre a tela da aba que foi tocada.
  void _abrirTela(BuildContext context, int indice) {
    // Se já estamos na tela principal dessa aba, não faz nada.
    // (Navigator.canPop é false quando não há tela "embaixo" desta.)
    if (indice == indiceAtual && !Navigator.canPop(context)) {
      return;
    }

    Widget novaTela;
    if (indice == 0) {
      novaTela = const TelaPrincipal();
    } else if (indice == 1) {
      novaTela = const TelaEstatisticas();
    } else {
      novaTela = const TelaConfiguracoes();
    }

    // Abre a nova tela e remove as anteriores da pilha de navegação.
    // Usamos PageRouteBuilder com duração zero para trocar de aba
    // sem animação, como acontece nos menus de abas dos aplicativos.
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animacao1, animacao2) => novaTela,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Container(
      // Linha fina em cima da barra, como no protótipo
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: cores.outlineVariant)),
      ),
      child: BottomNavigationBar(
        currentIndex: indiceAtual,
        onTap: (indice) => _abrirTela(context, indice),
        type: BottomNavigationBarType.fixed,
        backgroundColor: cores.surface,
        elevation: 0,
        selectedItemColor: cores.primary,
        unselectedItemColor: cores.onSurfaceVariant,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: 'Estatísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
