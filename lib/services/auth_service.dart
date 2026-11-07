import '../core/config/app_config.dart';
import '../dados/dados_app.dart';
import '../models/novo_cadastro.dart';
import '../models/usuario.dart';
import 'api_client.dart';

/// Login, cadastro e recuperação de senha.
///
/// Com AppConfig.usarMock = true, tudo funciona sem servidor.
/// Com false, cada método chama o endpoint indicado em AppConfig.
class AuthService {
  AuthService._();

  // Pequena espera só para o mock parecer uma chamada de rede de verdade
  static Future<void> _espera() =>
      Future.delayed(const Duration(milliseconds: 600));

  /// POST /auth/login
  ///   envia:   {"email": "...", "senha": "..."}
  ///   recebe:  {"token": "<jwt>", "usuario": { ...Usuario... }}
  static Future<void> login({
    required String email,
    required String senha,
  }) async {
    if (AppConfig.usarMock) {
      await _espera();
      // Mock: aceita qualquer e-mail/senha.
      if (DadosApp.usuario.email != email) {
        DadosApp.usuario = Usuario(nome: 'Usuário', email: email);
      }
      DadosApp.carregarDadosDemonstracao();
      return;
    }

    // TODO (back-end): conferir o formato da resposta com o app.
    final json = await ApiClient.post(AppConfig.epLogin, {
      'email': email,
      'senha': senha,
    });
    _guardarSessao(json);
  }

  /// POST /usuarios
  ///   envia:   NovoCadastro.toJson() (inclui a senha)
  ///   recebe:  igual ao login: {"token": "...", "usuario": {...}}
  ///            (a pessoa já fica logada depois de cadastrar)
  static Future<void> cadastrar(NovoCadastro cadastro) async {
    if (AppConfig.usarMock) {
      await _espera();
      DadosApp.usuario = cadastro.paraUsuario();
      DadosApp.registros = []; // conta nova começa sem registros
      return;
    }

    final json = await ApiClient.post(AppConfig.epCadastro, cadastro.toJson());
    _guardarSessao(json);
  }

  /// POST /auth/recuperar-senha
  ///   envia:   {"email": "..."}
  ///   efeito:  a API gera um código de 6 dígitos, guarda (com validade) e
  ///            envia por e-mail. Responde 200 mesmo que o e-mail não exista
  ///            (assim ninguém descobre quem tem conta).
  static Future<void> solicitarCodigo(String email) async {
    if (AppConfig.usarMock) {
      await _espera();
      return;
    }
    await ApiClient.post(AppConfig.epSolicitarCodigo, {'email': email});
  }

  /// POST /auth/validar-codigo
  ///   envia:   {"email": "...", "codigo": "123456"}
  ///   recebe:  200 se o código estiver certo e dentro da validade;
  ///            400 com {"mensagem": "Código inválido"} caso contrário.
  static Future<void> validarCodigo(String email, String codigo) async {
    if (AppConfig.usarMock) {
      await _espera();
      return; // mock: aceita qualquer código de 6 dígitos
    }
    await ApiClient.post(AppConfig.epValidarCodigo, {
      'email': email,
      'codigo': codigo,
    });
  }

  /// POST /auth/nova-senha
  ///   envia:   {"email": "...", "codigo": "123456", "novaSenha": "..."}
  ///   efeito:  a API troca o hash da senha no MySQL e invalida o código.
  static Future<void> redefinirSenha({
    required String email,
    required String codigo,
    required String novaSenha,
  }) async {
    if (AppConfig.usarMock) {
      await _espera();
      return;
    }
    await ApiClient.post(AppConfig.epNovaSenha, {
      'email': email,
      'codigo': codigo,
      'novaSenha': novaSenha,
    });
  }

  /// Sair da conta: apaga token e dados da memória.
  static void logout() {
    ApiClient.token = null;
    DadosApp.limpar();
  }

  static void _guardarSessao(dynamic json) {
    ApiClient.token = json['token'] as String?;
    DadosApp.usuario = Usuario.fromJson(json['usuario'] as Map<String, dynamic>);
    DadosApp.registros = [];
  }
}
