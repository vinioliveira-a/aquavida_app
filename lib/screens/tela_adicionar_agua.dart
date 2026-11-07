import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dados/dados_app.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/mensagens.dart';
import '../services/api_client.dart';
import '../services/registro_agua_service.dart';
import '../widgets/barra_navegacao.dart';

/// Tela 4 - Adicionar água.
/// O usuário escolhe uma quantidade rápida (200, 300, 500 ou 750 ml)
/// ou digita outra quantidade, e confirma o registro.
///
/// BACK-END (futuro): esta tela vai ENVIAR o novo registro de consumo.
class TelaAdicionarAgua extends StatefulWidget {
  const TelaAdicionarAgua({super.key});

  @override
  State<TelaAdicionarAgua> createState() => _TelaAdicionarAguaState();
}

class _TelaAdicionarAguaState extends State<TelaAdicionarAgua> {
  // Opções da "Escolha rápida" (em ml)
  final List<int> _opcoes = [200, 300, 500, 750];

  // Quantidade que será registrada (0 = nada escolhido ainda)
  int _quantidadeMl = 0;

  final _campoPersonalizado = TextEditingController();

  @override
  void dispose() {
    _campoPersonalizado.dispose();
    super.dispose();
  }

  /// Quando o usuário toca em uma das opções rápidas.
  void _escolherOpcao(int valor) {
    setState(() {
      _quantidadeMl = valor;
      _campoPersonalizado.clear(); // limpa o campo personalizado
    });
  }

  /// Quando o usuário digita no campo personalizado.
  void _digitarQuantidade(String texto) {
    setState(() {
      _quantidadeMl = int.tryParse(texto) ?? 0;
    });
  }

  /// Quando o usuário toca no botão "Adicionar água".
  Future<void> _confirmarRegistro() async {
    if (_quantidadeMl <= 0) {
      mostrarMensagem(
        context,
        'Escolha uma quantidade ou digite um valor.',
        erro: true,
      );
      return;
    }
    if (_quantidadeMl > 2000) {
      mostrarMensagem(
        context,
        'Valor muito alto. Registre no máximo 2.000 ml por vez.',
        erro: true,
      );
      return;
    }

    try {
      // Registra o consumo. Em modo mock só guarda na memória; com a API
      // ligada, envia o registro ao back-end (POST /registros-agua).
      await RegistroAguaService.adicionar(_quantidadeMl);
    } on ApiException catch (erro) {
      if (mounted) mostrarMensagem(context, erro.mensagem, erro: true);
      return;
    }
    if (!mounted) return;

    mostrarMensagem(
      context,
      '${DadosApp.formatarQuantidade(_quantidadeMl)} registrados! '
      'Hoje: ${DadosApp.formatarQuantidade(DadosApp.consumoHoje())}',
    );

    // Volta para a tela principal (que vai se atualizar sozinha)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    int totalDepois = DadosApp.consumoHoje() + _quantidadeMl;

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

            // Ícone de gota no círculo
            Center(
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: cores.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.water_drop_outlined,
                  color: cores.primary,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Adicionar água',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Insira a quantidade de água que consumiu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cores.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // ---------- Cartão azul com a quantidade ----------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: AppTheme.gradienteAzul,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Quantidade a adicionar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DadosApp.formatarQuantidade(_quantidadeMl),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Mostra como ficará o consumo do dia após registrar
                  Text(
                    'Hoje ficará: ${DadosApp.formatarQuantidade(totalDepois)} '
                    'de ${DadosApp.formatarQuantidade(DadosApp.metaDiariaMl)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.brancoSuave,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- Escolha rápida ----------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: AppTheme.decoracaoCartao(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Escolha rápida',
                    style: TextStyle(
                      color: cores.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Grade com 2 colunas
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true, // ocupa só o espaço necessário
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.7,
                    children: [
                      for (int i = 0; i < _opcoes.length; i++)
                        _botaoOpcao(_opcoes[i], 26.0 + i * 3, cores),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- Quantidade personalizada ----------
            Text(
              'Personalizado',
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _campoPersonalizado,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: _digitarQuantidade,
              decoration: AppTheme.decoracaoCampo(
                context,
                dica: 'Informe a quantidade em ml',
                sufixo: 'ml',
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _confirmarRegistro,
              child: const Text('Adicionar água'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacao(indiceAtual: 0),
    );
  }

  /// Um botão da escolha rápida (copo + quantidade).
  /// O tamanho do ícone aumenta um pouco a cada opção (copo maior).
  Widget _botaoOpcao(int valorMl, double tamanhoIcone, ColorScheme cores) {
    bool selecionado = _quantidadeMl == valorMl &&
        _campoPersonalizado.text.isEmpty;

    return GestureDetector(
      onTap: () => _escolherOpcao(valorMl),
      child: Container(
        decoration: BoxDecoration(
          color: selecionado ? cores.primaryContainer : cores.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? cores.primary : cores.outlineVariant,
            width: selecionado ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_drink_outlined,
              size: tamanhoIcone,
              color: selecionado ? cores.primary : cores.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              '$valorMl ml',
              style: TextStyle(
                color: selecionado ? cores.primary : cores.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
