import 'package:flutter/material.dart';
import '../core/utils/mensagens.dart';
import '../core/utils/validacoes.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../widgets/campo_texto.dart';
import '../widgets/recuperacao_layout.dart';

/// Recuperação de senha - nova senha (Figma: NovaSenha).
class TelaNovaSenha extends StatefulWidget {
  const TelaNovaSenha({super.key});

  @override
  State<TelaNovaSenha> createState() => _TelaNovaSenhaState();
}

class _TelaNovaSenhaState extends State<TelaNovaSenha> {
  final _senhaController = TextEditingController();
  final _confirmaController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmaController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    final erro = validarSenha(_senhaController.text) ??
        validarConfirmacaoSenha(
          _senhaController.text,
          _confirmaController.text,
        );
    if (erro != null) {
      mostrarMensagem(context, erro, erro: true);
      return;
    }

    // E-mail e código vêm da tela anterior
    final argumento = ModalRoute.of(context)?.settings.arguments;
    final dados = argumento is Map ? argumento : const {};
    final email = (dados['email'] ?? '') as String;
    final codigo = (dados['codigo'] ?? '') as String;

    setState(() => _carregando = true);
    try {
      await AuthService.redefinirSenha(
        email: email,
        codigo: codigo,
        novaSenha: _senhaController.text,
      );
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        mostrarMensagem(context, e.mensagem, erro: true);
      }
      return;
    }
    if (!mounted) return;

    mostrarMensagem(context, 'Senha alterada com sucesso!');
    // Volta para o login, limpando as telas de recuperação
    Navigator.popUntil(context, ModalRoute.withName('/login'));
  }

  @override
  Widget build(BuildContext context) {
    return RecuperacaoLayout(
      icone: Icons.shield_outlined,
      proporcaoIcone: 0.6,
      titulo: 'Digite sua nova senha',
      textoBotao: 'Confirmar alteração',
      espacoAposTitulo: 38,
      espacoAntesBotao: 38,
      carregando: _carregando,
      onContinuar: _confirmar,
      child: Column(
        children: [
          CampoTexto(
            rotulo: 'Nova senha*',
            dica: 'Informe sua nova senha',
            controller: _senhaController,
            obscuro: true,
          ),
          const SizedBox(height: 17),
          CampoTexto(
            rotulo: 'Confirme sua senha*',
            dica: 'Confirme sua senha',
            controller: _confirmaController,
            obscuro: true,
          ),
        ],
      ),
    );
  }
}
