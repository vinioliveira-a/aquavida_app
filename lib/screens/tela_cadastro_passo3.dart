import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/formatadores.dart';
import '../core/utils/mensagens.dart';
import '../dados/dados_app.dart';
import '../models/config_lembrete.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../widgets/cadastro_layout.dart';
import '../widgets/cartao_switch.dart';
import '../widgets/seletor_horario.dart';
import '../widgets/seletor_opcoes.dart';

/// Cadastro - passo 3 (Figma: CadastroPasso3). Configuração dos lembretes.
/// Ao finalizar, envia o cadastro completo (passos 1 a 3) para a API.
class TelaCadastroPasso3 extends StatefulWidget {
  const TelaCadastroPasso3({super.key});

  @override
  State<TelaCadastroPasso3> createState() => _TelaCadastroPasso3State();
}

class _TelaCadastroPasso3State extends State<TelaCadastroPasso3> {
  bool _lembretesAtivos = false;
  TimeOfDay? _inicio;
  TimeOfDay? _fim;
  int _intervalo = 10; // minutos
  bool _carregando = false;

  TextStyle get _estiloRotulo => const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.azulEscuro,
      );

  Future<void> _finalizar() async {
    if (_lembretesAtivos && (_inicio == null || _fim == null)) {
      mostrarMensagem(
        context,
        'Escolha o horário de início e de fim dos lembretes.',
        erro: true,
      );
      return;
    }

    DadosApp.novoCadastro.lembretes = ConfigLembrete(
      ativo: _lembretesAtivos,
      inicio: _inicio == null ? null : horaParaTexto(_inicio!),
      fim: _fim == null ? null : horaParaTexto(_fim!),
      intervaloMin: _intervalo,
    );

    setState(() => _carregando = true);
    try {
      // Envia o cadastro (em modo mock só guarda na memória).
      await AuthService.cadastrar(DadosApp.novoCadastro);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        mostrarMensagem(context, e.mensagem, erro: true);
      }
      return;
    }
    if (!mounted) return;

    mostrarMensagem(context, 'Cadastro concluído! Bem-vindo(a).');
    Navigator.pushNamedAndRemoveUntil(context, '/home', (rota) => false);
  }

  @override
  Widget build(BuildContext context) {
    return CadastroLayout(
      passo: 3,
      titulo: 'Como quer ser Lembrado?',
      subtitulo: 'Configure seus lembretes para manter a hidratação.',
      textoBotao: 'Finalizar',
      espacoLogoTitulo: 27,
      espacoAposTitulo: 20,
      carregando: _carregando,
      onContinuar: _finalizar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CartaoSwitch(
            texto: 'Ativar lembretes',
            valor: _lembretesAtivos,
            onChanged: (v) => setState(() => _lembretesAtivos = v),
          ),
          const SizedBox(height: 26),

          Text('Janela de Notificação', style: _estiloRotulo),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SeletorHorario(
                  rotulo: 'Início',
                  valor: _inicio,
                  onChanged: (h) => setState(() => _inicio = h),
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: SeletorHorario(
                  rotulo: 'Fim',
                  valor: _fim,
                  onChanged: (h) => setState(() => _fim = h),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),

          Text('Tempo de notificação', style: _estiloRotulo),
          const SizedBox(height: 7),
          SeletorOpcoes(
            opcoes: const [5, 10, 15],
            selecionada: _intervalo,
            onChanged: (m) => setState(() => _intervalo = m),
          ),
          const SizedBox(height: 13),

          Text(
            'Você receberá notificações a cada $_intervalo minutos '
            'durante o seu período de atividade.',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.cinzaTexto,
            ),
          ),
        ],
      ),
    );
  }
}
