import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';

/// Caixinhas para digitar o código (6 dígitos por padrão).
/// Pula para a próxima ao digitar e volta ao apagar.
class CodigoVerificacao extends StatefulWidget {
  const CodigoVerificacao({super.key, this.tamanho = 6, this.onChanged});

  final int tamanho;

  /// Chamado a cada mudança, com o código digitado até agora.
  final ValueChanged<String>? onChanged;

  @override
  State<CodigoVerificacao> createState() => _CodigoVerificacaoState();
}

class _CodigoVerificacaoState extends State<CodigoVerificacao> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focos;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.tamanho, (_) => TextEditingController());
    _focos = List.generate(widget.tamanho, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focos) {
      f.dispose();
    }
    super.dispose();
  }

  String get _codigo => _controllers.map((c) => c.text).join();

  OutlineInputBorder _borda(Color cor) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4), // 12px no Figma
        borderSide: BorderSide(color: cor, width: 1),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.tamanho; i++) ...[
          if (i > 0) const SizedBox(width: 7),
          Expanded(
            child: SizedBox(
              height: 40, // 120px no Figma
              child: Focus(
                // Backspace em caixinha vazia volta para a anterior
                onKeyEvent: (node, evento) {
                  if (evento is KeyDownEvent &&
                      evento.logicalKey == LogicalKeyboardKey.backspace &&
                      _controllers[i].text.isEmpty &&
                      i > 0) {
                    _focos[i - 1].requestFocus();
                    _controllers[i - 1].clear();
                    widget.onChanged?.call(_codigo);
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: TextField(
                  controller: _controllers[i],
                  focusNode: _focos[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.azulEscuro,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.branco,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: _borda(AppColors.bordaInput),
                    focusedBorder: _borda(AppColors.azulPrimario),
                  ),
                  onChanged: (valor) {
                    if (valor.isNotEmpty && i < widget.tamanho - 1) {
                      _focos[i + 1].requestFocus();
                    } else if (valor.isNotEmpty) {
                      _focos[i].unfocus(); // última caixinha preenchida
                    }
                    widget.onChanged?.call(_codigo);
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
