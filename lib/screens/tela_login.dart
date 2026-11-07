import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/mensagens.dart';
import '../core/utils/validacoes.dart';
import '../services/api_client.dart';
import '../services/auth_service.dart';
import '../services/registro_agua_service.dart';
import '../widgets/botao_primario.dart';
import '../widgets/campo_texto.dart';
import '../widgets/gota_avatar.dart';
import '../widgets/texto_com_link.dart';

/// Tela de login (Figma: Login, frame 1080x2400 = escala ~3x).
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _lembrar = false; // TODO: guardar o login no aparelho (opcional)
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    final erro = validarEmail(email) ??
        (senha.isEmpty ? 'Informe a senha.' : null);
    if (erro != null) {
      mostrarMensagem(context, erro, erro: true);
      return;
    }

    setState(() => _carregando = true);
    try {
      await AuthService.login(email: email, senha: senha);
      await RegistroAguaService.carregar();
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _carregando = false);
        mostrarMensagem(context, e.mensagem, erro: true);
      }
      return;
    }
    if (!mounted) return;

    // Vai para a tela principal e limpa as telas de entrada da pilha
    Navigator.pushNamedAndRemoveUntil(context, '/home', (rota) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundoTela,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const GotaAvatar(),
              const SizedBox(height: 27),

              // Cabeçalho
              Text(
                'Que bom te ver de volta!',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 20, // 56px no Figma
                  fontWeight: FontWeight.w600,
                  color: AppColors.azulEscuro,
                  letterSpacing: 0.26,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Insira seus dados para voltar a cuidar da sua hidratação.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 11, // 30px no Figma
                  fontWeight: FontWeight.w600,
                  color: AppColors.cinzaTexto,
                  letterSpacing: 0.14,
                ),
              ),
              const SizedBox(height: 27),

              // Campos
              CampoTexto(
                rotulo: 'E-mail*',
                dica: 'Informe seu e-mail',
                controller: _emailController,
                tipoTeclado: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CampoTexto(
                rotulo: 'Senha*',
                dica: 'Informe sua senha',
                controller: _senhaController,
                obscuro: true,
              ),
              const SizedBox(height: 8),

              // Lembrar de mim / Esqueceu a senha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => setState(() => _lembrar = !_lembrar),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: _lembrar,
                            onChanged: (v) =>
                                setState(() => _lembrar = v ?? false),
                            activeColor: AppColors.azulPrimario,
                            side: const BorderSide(
                              color: AppColors.azulEscuro,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lembrar de mim',
                          style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.azulEscuro,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/recuperar-senha');
                    },
                    child: Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.azulLink,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Botão Entrar
              BotaoPrimario(
                texto: 'Entrar',
                carregando: _carregando,
                onPressed: _entrar,
              ),
              const SizedBox(height: 8),

              // Link para cadastro
              TextoComLink(
                texto: 'Ainda não possui conta?',
                link: 'Registre-se',
                onTap: () => Navigator.pushNamed(context, '/cadastro/passo1'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
