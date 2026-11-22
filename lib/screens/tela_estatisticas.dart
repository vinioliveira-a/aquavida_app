import 'package:flutter/material.dart';

import '../dados/dados_app.dart';
import '../core/theme/app_theme.dart';
import '../widgets/barra_navegacao.dart';

/// Tela 6 - Estatísticas.
/// Mostra média diária, melhor dia, dias com meta atingida e um gráfico
/// simples de barras com o consumo dos últimos 7 dias.
///
/// BACK-END (futuro): esta tela vai RECEBER os registros (ou os
/// números já calculados) para montar as estatísticas.
class TelaEstatisticas extends StatefulWidget {
  const TelaEstatisticas({super.key});

  @override
  State<TelaEstatisticas> createState() => _TelaEstatisticasState();
}

class _TelaEstatisticasState extends State<TelaEstatisticas> {
  // Períodos do seletor: nome que aparece e quantidade de dias
  final List<String> _nomesPeriodos = ['Semana', 'Mês', 'Ano'];
  final List<int> _diasPeriodos = [7, 30, 365];
  final List<String> _legendasPeriodos = [
    'últimos 7 dias',
    'últimos 30 dias',
    'últimos 12 meses',
  ];

  int _periodoSelecionado = 0; // 0 = Semana, 1 = Mês, 2 = Ano

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    // Cálculos feitos com os dados de demonstração
    int dias = _diasPeriodos[_periodoSelecionado];
    int media = DadosApp.mediaDiaria(dias);
    DateTime? melhorDia = DadosApp.melhorDia(dias);
    int diasRegistrados = DadosApp.diasDoPeriodo(dias).length;
    int diasMeta = DadosApp.diasComMetaAtingida(dias);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            Text(
              'Estatísticas',
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            _seletorPeriodo(cores),
            const SizedBox(height: 20),

            // ---------- Média diária ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.decoracaoCartao(context),
              child: Row(
                children: [
                  Expanded(
                    child: _textosInfo(
                      'Média diária',
                      DadosApp.formatarQuantidade(media),
                      _legendasPeriodos[_periodoSelecionado],
                      cores,
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: cores.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.water_drop_outlined,
                      color: cores.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ---------- Melhor dia e dias com meta (lado a lado) ----------
            // IntrinsicHeight deixa os dois cartões com a mesma altura
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: AppTheme.decoracaoCartao(context),
                      child: _textosInfo(
                        'Melhor dia',
                        melhorDia == null
                            ? '-'
                            : DadosApp.formatarQuantidade(
                                DadosApp.totalDoDia(melhorDia),
                              ),
                        melhorDia == null
                            ? 'sem registros'
                            : DadosApp.formatarDataCurta(melhorDia),
                        cores,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: AppTheme.decoracaoCartao(context),
                      child: _textosInfo(
                        'Dias com meta atingida',
                        '$diasMeta/$diasRegistrados dias',
                        'dias com registro',
                        cores,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ---------- Gráfico semanal ----------
            Text(
              'Consumo da semana (${DadosApp.unidade})',
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _graficoSemanal(cores),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacao(indiceAtual: 1),
    );
  }

  /// Seletor "Semana | Mês | Ano".
  Widget _seletorPeriodo(ColorScheme cores) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: AppTheme.decoracaoCartao(context),
      child: Row(
        children: [
          for (int i = 0; i < _nomesPeriodos.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _periodoSelecionado = i;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    // Só o período selecionado fica azul
                    color: i == _periodoSelecionado
                        ? cores.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _nomesPeriodos[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: i == _periodoSelecionado
                          ? Colors.white
                          : cores.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Três textos empilhados: título pequeno, valor grande e legenda.
  Widget _textosInfo(
    String titulo,
    String valor,
    String legenda,
    ColorScheme cores,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(color: cores.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            color: cores.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          legenda,
          style: TextStyle(color: cores.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }

  /// Gráfico de barras horizontais feito só com Containers.
  /// Cada barra tem a largura proporcional ao consumo do dia.
  Widget _graficoSemanal(ColorScheme cores) {
    List<DateTime> semana = DadosApp.ultimos7Dias();

    // Descobre o maior valor da semana para calcular o tamanho das barras
    int maior = 0;
    for (DateTime dia in semana) {
      int total = DadosApp.totalDoDia(dia);
      if (total > maior) {
        maior = total;
      }
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.decoracaoCartao(context),
      child: Column(
        children: [
          for (DateTime dia in semana)
            _barraDoDia(dia, maior, cores),
        ],
      ),
    );
  }

  Widget _barraDoDia(DateTime dia, int maior, ColorScheme cores) {
    int total = DadosApp.totalDoDia(dia);
    bool ehHoje = DadosApp.mesmoDia(dia, DateTime.now());

    // Fração da barra: de 0.0 (vazia) até 1.0 (maior valor da semana)
    double fracao = 0;
    if (maior > 0) {
      fracao = total / maior;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Nome do dia
          SizedBox(
            width: 40,
            child: Text(
              ehHoje ? 'Hoje' : DadosApp.nomeDoDia(dia),
              style: TextStyle(
                color: ehHoje ? cores.primary : cores.onSurfaceVariant,
                fontSize: 11,
                fontWeight: ehHoje ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          // Barra + valor
          Expanded(
            child: Row(
              children: [
                Flexible(
                  // FractionallySizedBox ocupa uma fração da largura disponível
                  child: FractionallySizedBox(
                    widthFactor: fracao,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: cores.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  DadosApp.formatarValor(total),
                  style: TextStyle(
                    color: cores.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
