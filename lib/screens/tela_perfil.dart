import 'package:flutter/material.dart';

import '../dados/dados_app.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/formatadores.dart';
import '../core/utils/mensagens.dart';
import '../core/utils/validacoes.dart';
import '../services/api_client.dart';
import '../services/usuario_service.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/seletor_chips.dart';

/// Tela de perfil (aberta pelo botão "Editar perfil" nas configurações).
/// Permite consultar e alterar os dados informados no cadastro.
///
/// BACK-END (futuro): esta tela vai RECEBER os dados do usuário
/// e ENVIAR as alterações.
class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _chaveFormulario = GlobalKey<FormState>();

  final _campoNome = TextEditingController();
  final _campoNascimento = TextEditingController();
  final _campoPeso = TextEditingController();

  String _nivelAtividade = 'Moderado';

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados atuais do usuário
    _campoNome.text = DadosApp.nome;
    final nascimento = DadosApp.usuario.dataNascimento;
    _campoNascimento.text = nascimento == null ? '' : dataParaTexto(nascimento);
    _campoPeso.text = DadosApp.formatarPeso(DadosApp.peso);
    _nivelAtividade = DadosApp.nivelAtividade;
  }

  @override
  void dispose() {
    _campoNome.dispose();
    _campoNascimento.dispose();
    _campoPeso.dispose();
    super.dispose();
  }

  Future<void> _finalizarAlteracoes() async {
    if (!_chaveFormulario.currentState!.validate()) {
      mostrarMensagem(context, 'Verifique os campos destacados.', erro: true);
      return;
    }

    final atualizado = DadosApp.usuario.copyWith(
      nome: _campoNome.text.trim(),
      pesoKg: converterPeso(_campoPeso.text)!,
      dataNascimento: converterData(_campoNascimento.text),
      nivelAtividade: _nivelAtividade,
    );

    try {
      // Em modo mock só atualiza a memória; com a API ligada, envia
      // as alterações ao back-end (PUT /usuarios/me).
      await UsuarioService.atualizar(atualizado);
    } on ApiException catch (erro) {
      if (mounted) mostrarMensagem(context, erro.mensagem, erro: true);
      return;
    }
    if (!mounted) return;

    mostrarMensagem(context, 'Perfil atualizado!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    // Letra do avatar acompanha o nome digitado
    String inicial = _campoNome.text.trim().isEmpty
        ? 'U'
        : _campoNome.text.trim()[0].toUpperCase();

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _chaveFormulario,
          // SingleChildScrollView + Column: todos os campos ficam sempre
          // montados, então o validate() confere todos eles.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                ),
                Text(
                  'Perfil',
                  style: TextStyle(
                    color: cores.onSurface,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                // Avatar com a primeira letra do nome
                Center(
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: cores.primaryContainer,
                    child: Text(
                      inicial,
                      style: TextStyle(
                        color: cores.onPrimaryContainer,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                _rotulo('Nome', cores),
                TextFormField(
                  controller: _campoNome,
                  textCapitalization: TextCapitalization.words,
                  decoration: AppTheme.decoracaoCampo(context, dica: 'Seu nome'),
                  validator: validarNome,
                  onChanged: (texto) => setState(() {}), // atualiza o avatar
                ),
                const SizedBox(height: 18),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rotulo('Data de nascimento', cores),
                          TextFormField(
                            controller: _campoNascimento,
                            keyboardType: TextInputType.number,
                            inputFormatters: [DataInputFormatter()],
                            decoration: AppTheme.decoracaoCampo(
                              context,
                              dica: 'DD/MM/AAAA',
                            ),
                            validator: validarDataNascimento,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rotulo('Peso', cores),
                          TextFormField(
                            controller: _campoPeso,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: AppTheme.decoracaoCampo(
                              context,
                              dica: 'Ex.: 70',
                              sufixo: 'kg',
                            ),
                            validator: validarPeso,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                _rotulo('Nível de atividade física', cores),
                SeletorChips(
                  opcoes: DadosApp.niveisAtividade,
                  valorSelecionado: _nivelAtividade,
                  aoMudar: (novoNivel) {
                    setState(() {
                      _nivelAtividade = novoNivel;
                    });
                  },
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _finalizarAlteracoes,
                  child: const Text('Finalizar alterações'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BarraNavegacao(indiceAtual: 2),
    );
  }

  Widget _rotulo(String texto, ColorScheme cores) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: TextStyle(
          color: cores.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
