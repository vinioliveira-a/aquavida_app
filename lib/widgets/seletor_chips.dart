import 'package:flutter/material.dart';

/// Linha de botões arredondados para escolher UMA opção.
///
/// Usado em:
///   - Cadastro e Perfil: nível de atividade física
///   - Configurações: intervalo dos lembretes (1h, 2h, 3h)
///
/// Parâmetros:
///   - opcoes: textos dos botões
///   - valorSelecionado: o texto do botão que está marcado agora
///   - aoMudar: função chamada quando o usuário toca em outro botão
class SeletorChips extends StatelessWidget {
  final List<String> opcoes;
  final String valorSelecionado;
  final ValueChanged<String> aoMudar;

  const SeletorChips({
    super.key,
    required this.opcoes,
    required this.valorSelecionado,
    required this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    // Wrap coloca os botões lado a lado e quebra a linha se faltar espaço
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (String opcao in opcoes)
          ChoiceChip(
            label: Text(opcao),
            selected: opcao == valorSelecionado,
            showCheckmark: false,
            onSelected: (valor) => aoMudar(opcao),
            selectedColor: cores.primary,
            backgroundColor: cores.surface,
            side: BorderSide(
              color: opcao == valorSelecionado
                  ? cores.primary
                  : cores.outlineVariant,
            ),
            shape: const StadiumBorder(),
            labelStyle: TextStyle(
              color: opcao == valorSelecionado ? Colors.white : cores.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
