import '../core/config/app_config.dart';
import '../dados/dados_app.dart';
import '../models/usuario.dart';
import 'api_client.dart';

/// Perfil, meta diária e lembretes do usuário logado.
class UsuarioService {
  UsuarioService._();

  /// PUT /usuarios/me
  ///   envia:   Usuario.toJson() com os campos já alterados
  ///   recebe:  o Usuario atualizado
  ///
  /// Serve para TODAS as alterações: editar perfil, trocar a meta diária e
  /// mudar os lembretes. A tela monta uma cópia (usuario.copyWith(...)) e
  /// chama este método.
  static Future<void> atualizar(Usuario novo) async {
    if (AppConfig.usarMock) {
      await Future.delayed(const Duration(milliseconds: 300));
      DadosApp.usuario = novo;
      return;
    }

    final json = await ApiClient.put(AppConfig.epUsuarioAtual, novo.toJson());
    DadosApp.usuario = Usuario.fromJson(json as Map<String, dynamic>);
  }

  /// GET /usuarios/me  ->  o Usuario atual.
  /// (Opcional: útil para recarregar os dados ao abrir o app.)
  static Future<void> carregar() async {
    if (AppConfig.usarMock) return;

    final json = await ApiClient.get(AppConfig.epUsuarioAtual);
    DadosApp.usuario = Usuario.fromJson(json as Map<String, dynamic>);
  }
}
