import 'package:flutter/material.dart';

import '../dados/dados_app.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/item_registro.dart';

/// Tela 5 - Histórico.
/// Mostra os registros organizados por dia, com o total do dia
/// e quanto da meta foi alcançado. Toque em um dia para ver os registros.
///
/// BACK-END (futuro): esta tela vai RECEBER a lista de registros.
class TelaHistorico extends StatelessWidget {
  const TelaHistorico({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    List<DateTime> dias = DadosApp.diasComRegistro();

    // Soma de tudo o que foi registrado
    int totalGeral = 0;
    for (RegistroAgua registro in DadosApp.registros) {
      totalGeral = totalGeral + registro.quantidadeMl;
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              ),
            ),
            Text(
              'Histórico',
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Seus registros de consumo organizados por dia.',
              style: TextStyle(color: cores.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            if (dias.isEmpty)
              _mensagemSemRegistros(cores)
            else ...[
              // Resumo geral
              Text(
                'Total registrado: ${DadosApp.formatarQuantidade(totalGeral)} '
                'em ${dias.length} dia(s)',
                style: TextStyle(
                  color: cores.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              // Um cartão para cada dia
              for (DateTime dia in dias) _cartaoDia(context, dia, cores),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacao(indiceAtual: 0),
    );
  }

  /// Cartão de um dia. Ao tocar, abre a lista de registros daquele dia.
  Widget _cartaoDia(BuildContext context, DateTime dia, ColorScheme cores) {
    int total = DadosApp.totalDoDia(dia);
    int porcentagem = DadosApp.porcentagemDaMeta(total);
    bool metaAtingida = total >= DadosApp.metaDiariaMl;
    Color corDestaque = metaAtingida ? AppColors.verde : cores.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      decoration: AppTheme.decoracaoCartao(context),
      // ExpansionTile: um item que abre e fecha ao ser tocado
      child: ExpansionTile(
        shape: const Border(), // remove as linhas padrão
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cores.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            metaAtingida ? Icons.check_rounded : Icons.water_drop_outlined,
            color: corDestaque,
            size: 22,
          ),
        ),
        title: Text(
          DadosApp.formatarData(dia),
          style: TextStyle(
            color: cores.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${DadosApp.formatarQuantidade(total)} • $porcentagem% da meta',
              style: TextStyle(color: cores.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: DadosApp.progressoDaMeta(total),
              minHeight: 6,
              borderRadius: BorderRadius.circular(6),
              color: corDestaque,
              backgroundColor: cores.primaryContainer,
            ),
          ],
        ),
        children: [
          for (RegistroAgua registro in DadosApp.registrosDoDia(dia))
            ItemRegistro(registro: registro),
        ],
      ),
    );
  }

  Widget _mensagemSemRegistros(ColorScheme cores) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: cores.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history, color: cores.primary, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum registro encontrado',
            style: TextStyle(
              color: cores.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Quando você registrar água, o histórico aparecerá aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cores.onSurfaceVariant, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
