import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils/formatadores.dart';
import '../core/utils/mensagens.dart';
import '../core/utils/validacoes.dart';
import '../dados/dados_app.dart';
import '../widgets/cadastro_layout.dart';
import '../widgets/campo_texto.dart';

/// Cadastro - passo 2 (Figma: CadastroPasso2). Dados pessoais.
class TelaCadastroPasso2 extends StatefulWidget {
  const TelaCadastroPasso2({super.key});

  @override
  State<TelaCadastroPasso2> createState() => _TelaCadastroPasso2State();
}

class _TelaCadastroPasso2State extends State<TelaCadastroPasso2> {
  final _nomeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _nascimentoController = TextEditingController();
  final _metaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _pesoController.dispose();
    _nascimentoController.dispose();
    _metaController.dispose();
    super.dispose();
  }

  void _continuar() {
    final erro = validarNome(_nomeController.text) ??
        validarPeso(_pesoController.text) ??
        validarDataNascimento(_nascimentoController.text) ??
        validarMeta(_metaController.text);
    if (erro != null) {
      mostrarMensagem(context, erro, erro: true);
      return;
    }

    DadosApp.novoCadastro
      ..nome = _nomeController.text.trim()
      ..pesoKg = converterPeso(_pesoController.text)!
      ..dataNascimento = converterData(_nascimentoController.text)
      ..metaDiariaMl = int.parse(_metaController.text.trim());

    Navigator.pushNamed(context, '/cadastro/passo3');
  }

  @override
  Widget build(BuildContext context) {
    return CadastroLayout(
      passo: 2,
      titulo: 'Agora, vamos te conhecer melhor',
      subtitulo: 'Algumas informações para personalizar sua experiência.',
      textoBotao: 'Continuar',
      espacoLogoTitulo: 12,
      espacoAposTitulo: 49,
      onContinuar: _continuar,
      child: Column(
        children: [
          CampoTexto(
            rotulo: 'Nome*',
            dica: 'Como podemos te chamar?',
            controller: _nomeController,
          ),
          const SizedBox(height: 23),

          // Peso | Data de nascimento (duas colunas, como no Figma)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoTexto(
                  rotulo: 'Peso em kg*',
                  dica: 'Peso',
                  controller: _pesoController,
                  tipoTeclado: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  // aceita números, vírgula e ponto (ex.: 72,5)
                  formatadores: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: CampoTexto(
                  rotulo: 'Data de Nascimento*',
                  dica: 'DD/MM/AAAA',
                  controller: _nascimentoController,
                  tipoTeclado: TextInputType.number,
                  formatadores: [DataInputFormatter()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),

          // Meta diária (ocupa só a coluna da esquerda)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CampoTexto(
                  rotulo: 'Meta diária de água*',
                  dica: '0 ml',
                  controller: _metaController,
                  tipoTeclado: TextInputType.number,
                  formatadores: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 60),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}
