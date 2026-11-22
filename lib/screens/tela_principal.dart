import 'package:flutter/material.dart';

import '../dados/dados_app.dart';
import '../core/theme/app_theme.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/cartao_progresso.dart';
import '../widgets/item_registro.dart';

/// Tela 3 - Principal (Início).
/// Mostra a saudação, o progresso do dia, o botão de adicionar água
/// e os registros recentes.
///
/// BACK-END (futuro): esta tela vai RECEBER o consumo do dia e a meta.
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  /// Abre a tela de adicionar água e, ao voltar, atualiza esta tela.
  Future<void> _abrirAdicionarAgua() async {
    await Navigator.pushNamed(context, '/adicionar-agua');
    // "mounted" confere se esta tela ainda está aberta antes de atualizar
    if (mounted) {
      setState(() {});
    }
  }

  /// Abre o histórico completo ("Ver tudo").
  Future<void> _abrirHistorico() async {
    await Navigator.pushNamed(context, '/historico');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Olá, ${DadosApp.nome}!',
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Vamos manter a hidratação em dia!',
              style: TextStyle(color: cores.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Cartão azul com o círculo de progresso
            CartaoProgresso(
              consumidoMl: DadosApp.consumoHoje(),
              metaMl: DadosApp.metaDiariaMl,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _abrirAdicionarAgua,
              child: const Text('Adicionar água'),
            ),
            const SizedBox(height: 20),

            _cartaoRegistrosRecentes(cores),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacao(indiceAtual: 0),
    );
  }

  /// Cartão branco com os registros de hoje.
  Widget _cartaoRegistrosRecentes(ColorScheme cores) {
    List<RegistroAgua> registrosHoje = DadosApp.registrosDoDia(DateTime.now());

    // Mostra no máximo os 5 registros mais recentes
    if (registrosHoje.length > 5) {
      registrosHoje = registrosHoje.sublist(0, 5);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.decoracaoCartao(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título + "Ver tudo"
          Row(
            children: [
              Expanded(
                child: Text(
                  'Registros recentes',
                  style: TextStyle(
                    color: cores.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _abrirHistorico,
                child: Text(
                  'Ver tudo',
                  style: TextStyle(
                    color: cores.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Se não tem registros hoje, mostra uma mensagem.
          // Se tem, mostra a lista.
          if (registrosHoje.isEmpty)
            _mensagemSemRegistros(cores)
          else
            for (RegistroAgua registro in registrosHoje)
              ItemRegistro(registro: registro),
        ],
      ),
    );
  }

  Widget _mensagemSemRegistros(ColorScheme cores) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.water_drop_outlined,
              color: cores.onSurfaceVariant,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhum registro hoje',
              style: TextStyle(
                color: cores.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toque em "Adicionar água" para registrar seu primeiro copo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cores.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
