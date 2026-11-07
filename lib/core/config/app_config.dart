/// Configurações do app em um lugar só.
///
/// >>> EQUIPE DO BACK-END (Java + MySQL): é aqui que vocês mexem. <<<
///
/// Fluxo: App Flutter -> (HTTP/JSON) -> API Java -> MySQL.
/// O app NUNCA conversa direto com o banco, só com a API.
class AppConfig {
  AppConfig._();

  /// true  = dados de mentira (o app funciona sem servidor).
  /// false = o app chama a API Java de verdade.
  /// TODO (back-end): trocar para false quando a API estiver no ar.
  static const bool usarMock = true;

  /// Endereço base da API.
  ///  - Emulador Android ........ http://10.0.2.2:8080/api  (10.0.2.2 = o PC)
  ///  - Simulador iOS / web ..... http://localhost:8080/api
  ///  - Celular de verdade ...... http://IP-DO-PC:8080/api (mesma rede Wi-Fi)
  /// TODO (back-end): ajustar porta e prefixo conforme o Spring Boot.
  static const String apiBaseUrl = 'http://10.0.2.2:8080/api';

  /// Tempo máximo de espera por uma resposta da API.
  static const Duration timeout = Duration(seconds: 15);

  // ---------------- ENDPOINTS (caminhos depois da URL base) ----------------
  // Autenticação
  static const String epLogin = '/auth/login'; // POST
  static const String epCadastro = '/usuarios'; // POST
  static const String epSolicitarCodigo = '/auth/recuperar-senha'; // POST
  static const String epValidarCodigo = '/auth/validar-codigo'; // POST
  static const String epNovaSenha = '/auth/nova-senha'; // POST

  // Usuário logado
  static const String epUsuarioAtual = '/usuarios/me'; // GET e PUT

  // Registros de água do usuário logado
  static const String epRegistrosAgua = '/registros-agua'; // GET e POST
}
