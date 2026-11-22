import 'package:flutter/material.dart';
import '../core/utils/mensagens.dart';
import '../core/utils/validacoes.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../widgets/campo_texto.dart';
import '../widgets/recuperacao_layout.dart';
import '../widgets/texto_com_link.dart';

/// Recuperação de senha - e-mail (Figma: Recuperação de senha).
class TelaRecuperarSenha extends StatefulWidget {
  const TelaRecuperarSenha({super.key});

  @override
  State<TelaRecuperarSenha> createState() => _TelaRecuperarSenhaState();
}

class _TelaRecuperarSenhaState extends State<TelaRecuperarSenha> {
  final _emailController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _enviarCodigo() async {
    final email = _emailController.text.trim();
    final erro = validarEmail(email);
    if (erro != null) {
      mostrarMensagem(context, erro, erro: true);
      return;
    }

    setState(() => _carregando = true);
    try {
      await AuthService.solicitarCodigo(email);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        mostrarMensagem(context, e.mensagem, erro: true);
      }
      return;
    }
    if (!mounted) return;

    setState(() => _carregando = false);
    // O e-mail segue para a próxima tela como argumento da rota
    Navigator.pushNamed(context, '/recuperar-senha/codigo', arguments: email);
  }

  @override
  Widget build(BuildContext context) {
    return RecuperacaoLayout(
      icone: Icons.lock_outline_rounded,
      titulo: 'Esqueceu sua senha?',
      subtitulo:
          'Informe seu e-mail cadastrado para receber o código de recuperação',
      textoBotao: 'Enviar código',
      espacoAposTitulo: 38,
      espacoAntesBotao: 66,
      carregando: _carregando,
      onContinuar: _enviarCodigo,
      rodape: TextoComLink(
        texto: 'Lembrou a senha?',
        link: 'Entrar',
        onTap: () => Navigator.maybePop(context),
      ),
      child: CampoTexto(
        rotulo: 'E-mail*',
        dica: 'Informe seu e-mail',
        controller: _emailController,
        tipoTeclado: TextInputType.emailAddress,
      ),
    );
  }
}
