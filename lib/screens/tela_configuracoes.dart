import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../dados/dados_app.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/config/app_config.dart';
import '../core/utils/formatadores.dart';
import '../core/utils/mensagens.dart';
import '../core/utils/validacoes.dart';
import '../models/config_lembrete.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../widgets/barra_navegacao.dart';
import '../widgets/seletor_chips.dart';
import '../widgets/seletor_horario.dart';

/// Tela 7 - Configurações.
/// Perfil, meta diária, lembretes (apenas visuais), unidade de medida,
/// tema claro/escuro, redefinir dados, sobre o app e sair.
///
/// BACK-END (futuro): esta tela vai ENVIAR as alterações de meta e
/// preferências do usuário.
class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  // Controlam se as seções "Meta diária" e "Lembretes" estão abertas
  bool _metaAberta = false;
  bool _lembretesAbertos = false;

  final _campoMeta = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Preenche o campo com a meta atual
    _campoMeta.text = DadosApp.metaDiariaMl.toString();
  }

  @override
  void dispose() {
    _campoMeta.dispose();
    super.dispose();
  }

  // ===============================================================
  // AÇÕES
  // ===============================================================

  Future<void> _salvarMeta() async {
    String? erro = validarMeta(_campoMeta.text);
    if (erro != null) {
      mostrarMensagem(context, erro, erro: true);
      return;
    }
    final novaMeta = int.parse(_campoMeta.text.trim());

    try {
      // Em modo mock só atualiza a memória; com a API ligada, envia a
      // nova meta ao back-end (PUT /usuarios/me).
      await UsuarioService.atualizar(
        DadosApp.usuario.copyWith(metaDiariaMl: novaMeta),
      );
    } on ApiException catch (e) {
      if (mounted) mostrarMensagem(context, e.mensagem, erro: true);
      return;
    }
    if (!mounted) return;

    setState(() {
      _metaAberta = false;
    });
    FocusScope.of(context).unfocus(); // fecha o teclado
    mostrarMensagem(
      context,
      'Meta atualizada para ${DadosApp.formatarNumero(DadosApp.metaDiariaMl)} ml.',
    );
  }

  /// Salva os lembretes (ligar/desligar, horários e intervalo).
  Future<void> _salvarLembretes(ConfigLembrete novos) async {
    try {
      await UsuarioService.atualizar(
        DadosApp.usuario.copyWith(lembretes: novos),
      );
    } on ApiException catch (e) {
      if (mounted) mostrarMensagem(context, e.mensagem, erro: true);
      return;
    }
    if (mounted) setState(() {});
  }

  Future<void> _abrirPerfil() async {
    await Navigator.pushNamed(context, '/perfil');
    if (mounted) {
      setState(() {}); // atualiza o cartão com os dados novos
    }
  }

  void _confirmarRedefinicao() {
    showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Redefinir dados'),
          content: const Text(
            'O que deseja fazer com os registros de consumo?\n\n'
            '• Restaurar exemplo: volta aos dados de demonstração.\n'
            '• Apagar registros: deixa o app sem nenhum registro.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);
                setState(() {
                  DadosApp.apagarRegistros();
                });
                mostrarMensagem(context, 'Todos os registros foram apagados.');
              },
              child: const Text('Apagar registros'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);
                setState(() {
                  DadosApp.carregarDadosDemonstracao();
                });
                mostrarMensagem(context, 'Dados de demonstração restaurados.');
              },
              child: const Text('Restaurar exemplo'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarSobre() {
    showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Sobre o AquaVida'),
          content: const Text(
            'Versão 1.0.0\n\n'
            'Aplicativo de acompanhamento de hidratação desenvolvido como '
            'trabalho acadêmico do curso de Análise e Desenvolvimento de '
            'Sistemas (ADS).\n\n'
            'Esta versão contém apenas o front-end: os dados são fictícios, '
            'ficam guardados temporariamente na memória e voltam ao início '
            'quando o aplicativo é fechado.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarSaida() {
    showDialog(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Sair da conta'),
          content: const Text('Deseja sair da sua conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextoDialogo),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo);
                AuthService.logout(); // apaga token e dados da memória
                // Volta para o login e limpa a pilha de telas
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (rota) => false,
                );
              },
              child: const Text(
                'Sair',
                style: TextStyle(color: AppColors.vermelho),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===============================================================
  // TELA
  // ===============================================================

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 8),
            Text(
              'Configurações',
              style: TextStyle(
                color: cores.onSurface,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            _cartaoPerfil(cores),
            const SizedBox(height: 24),

            // ---------------- PREFERÊNCIAS ----------------
            _tituloSecao('Preferências', cores),
            _grupo([
              // Meta diária (abre e fecha)
              _item(
                icone: Icons.track_changes,
                titulo: 'Meta diária',
                cores: cores,
                direita: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DadosApp.formatarQuantidade(DadosApp.metaDiariaMl),
                      style: TextStyle(
                        color: cores.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      _metaAberta
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: cores.onSurfaceVariant,
                    ),
                  ],
                ),
                aoTocar: () {
                  setState(() {
                    _metaAberta = !_metaAberta;
                  });
                },
              ),
              if (_metaAberta) _conteudoMeta(cores),
              _divisoria(cores),

              // Notificações e lembretes (abre e fecha)
              _item(
                icone: Icons.notifications_none,
                titulo: 'Notificações e lembretes',
                cores: cores,
                direita: Icon(
                  _lembretesAbertos
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: cores.onSurfaceVariant,
                ),
                aoTocar: () {
                  setState(() {
                    _lembretesAbertos = !_lembretesAbertos;
                  });
                },
              ),
              if (_lembretesAbertos) _conteudoLembretes(cores),
              _divisoria(cores),

              // Unidade de medida
              _item(
                icone: Icons.straighten,
                titulo: 'Unidade de medida',
                cores: cores,
                direita: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _botaoUnidade('ml', cores),
                    const SizedBox(width: 6),
                    _botaoUnidade('L', cores),
                  ],
                ),
              ),
              _divisoria(cores),

              // Tema escuro
              _item(
                icone: Icons.palette_outlined,
                titulo: 'Tema escuro',
                cores: cores,
                direita: Switch(
                  value: DadosApp.temaEscuro.value,
                  onChanged: (ligado) {
                    setState(() {
                      // O main.dart está escutando esta variável
                      // e troca o tema do app inteiro.
                      DadosApp.temaEscuro.value = ligado;
                    });
                  },
                ),
              ),
            ]),
            const SizedBox(height: 24),

            // ---------------- OUTROS ----------------
            _tituloSecao('Outros', cores),
            _grupo([
              if (AppConfig.usarMock) ...[
                _item(
                  icone: Icons.restart_alt,
                  titulo: 'Redefinir dados de demonstração',
                  cores: cores,
                  aoTocar: _confirmarRedefinicao,
                ),
                _divisoria(cores),
              ],
              _item(
                icone: Icons.info_outline,
                titulo: 'Sobre o aplicativo',
                cores: cores,
                aoTocar: _mostrarSobre,
              ),
              _divisoria(cores),
              _item(
                icone: Icons.logout,
                titulo: 'Sair da conta',
                cores: cores,
                corDestaque: AppColors.vermelho,
                aoTocar: _confirmarSaida,
              ),
            ]),
            const SizedBox(height: 28),

            // Versão
            Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: cores.onSurfaceVariant, fontSize: 13),
                  children: [
                    const TextSpan(text: 'Versão: '),
                    TextSpan(
                      text: '1.0.0',
                      style: TextStyle(
                        color: cores.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacao(indiceAtual: 2),
    );
  }

  // ===============================================================
  // PARTES DA TELA (funções que montam pedaços da interface)
  // ===============================================================

  /// Cartão com avatar, nome, dados do usuário e o botão "Editar perfil".
  Widget _cartaoPerfil(ColorScheme cores) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 10),
      decoration: AppTheme.decoracaoCartao(context),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: cores.primaryContainer,
                child: Text(
                  DadosApp.inicialDoNome(),
                  style: TextStyle(
                    color: cores.onPrimaryContainer,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DadosApp.nome,
                      style: TextStyle(
                        color: cores.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DadosApp.resumoPerfil(),
                      style: TextStyle(
                        color: cores.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Botão "Editar perfil" no canto inferior direito
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: _abrirPerfil,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: cores.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Editar perfil',
                      style: TextStyle(
                        color: cores.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.edit, size: 13, color: cores.primary),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Campo para editar a meta (aparece quando "Meta diária" está aberta).
  Widget _conteudoMeta(ColorScheme cores) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meta diária de água*',
            style: TextStyle(
              color: cores.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _campoMeta,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: AppTheme.decoracaoCampo(
                    context,
                    dica: '2000',
                    sufixo: 'ml',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: _salvarMeta,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Opções de lembrete: ligar/desligar, janela de horário e intervalo.
  /// (Os lembretes ainda são só visuais: não enviam notificações de verdade.)
  Widget _conteudoLembretes(ColorScheme cores) {
    final lembretes = DadosApp.usuario.lembretes;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ativar lembretes',
                  style: TextStyle(color: cores.onSurface, fontSize: 13),
                ),
              ),
              Switch(
                value: lembretes.ativo,
                onChanged: (ligado) =>
                    _salvarLembretes(lembretes.copyWith(ativo: ligado)),
              ),
            ],
          ),
          if (lembretes.ativo) ...[
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SeletorHorario(
                    rotulo: 'Início',
                    valor: textoParaHora(lembretes.inicio),
                    onChanged: (h) => _salvarLembretes(
                      lembretes.copyWith(inicio: horaParaTexto(h)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SeletorHorario(
                    rotulo: 'Fim',
                    valor: textoParaHora(lembretes.fim),
                    onChanged: (h) => _salvarLembretes(
                      lembretes.copyWith(fim: horaParaTexto(h)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Lembrar a cada:',
              style: TextStyle(color: cores.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 8),
            SeletorChips(
              opcoes: const ['5 min', '10 min', '15 min'],
              valorSelecionado: '${lembretes.intervaloMin} min',
              aoMudar: (opcao) => _salvarLembretes(
                lembretes.copyWith(
                  intervaloMin: int.parse(opcao.replaceAll(' min', '')),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            'Os lembretes são apenas visuais nesta versão. '
            'As notificações ainda não foram implementadas.',
            style: TextStyle(color: cores.onSurfaceVariant, fontSize: 11),
          ),
        ],
      ),
    );
  }

  /// Botão pequeno para escolher a unidade (ml ou L).
  Widget _botaoUnidade(String unidade, ColorScheme cores) {
    bool selecionado = DadosApp.unidade == unidade;
    return GestureDetector(
      onTap: () {
        setState(() {
          DadosApp.unidade = unidade;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selecionado ? cores.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selecionado ? cores.primary : cores.outlineVariant,
          ),
        ),
        child: Text(
          unidade,
          style: TextStyle(
            color: selecionado ? Colors.white : cores.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Título pequeno de cada seção ("Preferências", "Outros").
  Widget _tituloSecao(String texto, ColorScheme cores) {
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

  /// Cartão branco que agrupa vários itens.
  Widget _grupo(List<Widget> itens) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: AppTheme.decoracaoCartao(context),
      // Material transparente: necessário para o efeito de toque (InkWell)
      child: Material(
        type: MaterialType.transparency,
        child: Column(children: itens),
      ),
    );
  }

  /// Uma linha de configuração: ícone redondo + título + algo à direita.
  Widget _item({
    required IconData icone,
    required String titulo,
    required ColorScheme cores,
    Widget? direita,
    VoidCallback? aoTocar,
    Color? corDestaque,
  }) {
    Color corIcone = corDestaque ?? cores.primary;
    Color corTexto = corDestaque ?? cores.onSurface;

    return InkWell(
      onTap: aoTocar,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: corDestaque == null
                    ? cores.primaryContainer
                    : const Color(0x1AE53935), // vermelho bem clarinho
                shape: BoxShape.circle,
              ),
              child: Icon(icone, color: corIcone, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                titulo,
                style: TextStyle(
                  color: corTexto,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (direita != null) direita,
          ],
        ),
      ),
    );
  }

  Widget _divisoria(ColorScheme cores) {
    return Divider(height: 1, thickness: 1, color: cores.outlineVariant);
  }
}
