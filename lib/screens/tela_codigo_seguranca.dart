import 'package:flutter/material.dart';
import '../core/utils/mensagens.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../widgets/codigo_verificacao.dart';
import '../widgets/recuperacao_layout.dart';
import '../widgets/texto_com_link.dart';

/// Recuperação de senha - código (Figma: CódigoSegurança).
class TelaCodigoSeguranca extends StatefulWidget {
  const TelaCodigoSeguranca({super.key});

  @override
  State<TelaCodigoSeguranca> createState() => _TelaCodigoSegurancaState();
}

class _TelaCodigoSegurancaState extends State<TelaCodigoSeguranca> {
  String _codigo = '';
  bool _carregando = false;

  /// E-mail digitado na tela anterior (vem como argumento da rota).
  String get _email {
    final argumento = ModalRoute.of(context)?.settings.arguments;
    return (argumento is String && argumento.isNotEmpty)
        ? argumento
        : 'exemplo@email.com';
  }

  Future<void> _validar() async {
    if (_codigo.length != 6) {
      mostrarMensagem(context, 'Digite os 6 dígitos do código.', erro: true);
      return;
    }

    final email = _email;
    setState(() => _carregando = true);
    try {
      await AuthService.validarCodigo(email, _codigo);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        mostrarMensagem(context, e.mensagem, erro: true);
      }
      return;
    }
    if (!mounted) return;

    setState(() => _carregando = false);
    // A tela da nova senha precisa do e-mail e do código
    Navigator.pushNamed(
      context,
      '/recuperar-senha/nova',
      arguments: {'email': email, 'codigo': _codigo},
    );
  }

  Future<void> _reenviar() async {
    try {
      await AuthService.solicitarCodigo(_email);
      if (mounted) mostrarMensagem(context, 'Código reenviado!');
    } on ApiException catch (e) {
      if (mounted) mostrarMensagem(context, e.mensagem, erro: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RecuperacaoLayout(
      icone: Icons.shield_outlined,
      proporcaoIcone: 0.6,
      titulo: 'Digite o código',
      subtitulo: 'Enviamos um código de 6 dígitos para',
      destaque: _email,
      textoBotao: 'Enviar código',
      espacoAposTitulo: 63,
      espacoAntesBotao: 45,
      carregando: _carregando,
      onContinuar: _validar,
      child: Column(
        children: [
          CodigoVerificacao(onChanged: (codigo) => _codigo = codigo),
          const SizedBox(height: 8),
          TextoComLink(
            texto: 'Não recebeu?',
            link: 'Reenviar',
            onTap: _reenviar,
          ),
        ],
      ),
    );
  }
}
