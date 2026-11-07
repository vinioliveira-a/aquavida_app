import 'package:flutter/material.dart';
import '../core/utils/mensagens.dart';
import '../core/utils/validacoes.dart';
import '../dados/dados_app.dart';
import '../widgets/cadastro_layout.dart';
import '../widgets/campo_texto.dart';

/// Cadastro - passo 1 (Figma: CadastroPasso1). Dados de acesso.
class TelaCadastroPasso1 extends StatefulWidget {
  const TelaCadastroPasso1({super.key});

  @override
  State<TelaCadastroPasso1> createState() => _TelaCadastroPasso1State();
}

class _TelaCadastroPasso1State extends State<TelaCadastroPasso1> {
  final _usuarioController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  void _continuar() {
    // Mostra o primeiro erro encontrado (se houver)
    final erro = validarUsuario(_usuarioController.text) ??
        validarEmail(_emailController.text) ??
        validarSenha(_senhaController.text) ??
        validarConfirmacaoSenha(
          _senhaController.text,
          _confirmaSenhaController.text,
        );
    if (erro != null) {
      mostrarMensagem(context, erro, erro: true);
      return;
    }

    // Guarda os dados deste passo; o envio acontece só no passo 3
    DadosApp.novoCadastro
      ..nomeUsuario = _usuarioController.text.trim()
      ..email = _emailController.text.trim()
      ..senha = _senhaController.text;

    Navigator.pushNamed(context, '/cadastro/passo2');
  }

  @override
  Widget build(BuildContext context) {
    return CadastroLayout(
      passo: 1,
      titulo: 'Vamos te conhecer',
      subtitulo: 'Insira seus dados de acesso para começar.',
      textoBotao: 'Continuar',
      espacoLogoTitulo: 12,
      espacoAposTitulo: 53,
      onContinuar: _continuar,
      child: Column(
        children: [
          CampoTexto(
            rotulo: 'Nome de usuário*',
            dica: 'Digite seu usuário',
            controller: _usuarioController,
          ),
          const SizedBox(height: 17),
          CampoTexto(
            rotulo: 'E-mail*',
            dica: 'Informe seu e-mail',
            controller: _emailController,
            tipoTeclado: TextInputType.emailAddress,
          ),
          const SizedBox(height: 17),
          CampoTexto(
            rotulo: 'Senha*',
            dica: 'Informe sua senha',
            controller: _senhaController,
            obscuro: true,
          ),
          const SizedBox(height: 17),
          CampoTexto(
            rotulo: 'Confirme sua senha*',
            dica: 'Confirme sua senha',
            controller: _confirmaSenhaController,
            obscuro: true,
          ),
        ],
      ),
    );
  }
}
