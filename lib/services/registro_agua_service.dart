import '../core/config/app_config.dart';
import '../dados/dados_app.dart';
import '../models/registro_agua.dart';
import 'api_client.dart';

/// Registros de consumo de água do usuário logado.
class RegistroAguaService {
  RegistroAguaService._();

  /// GET /registros-agua
  ///   recebe:  lista de {"id", "quantidadeMl", "dataHora"}
  ///   (o histórico e as estatísticas são calculados no app a partir dela;
  ///    se preferirem, a API pode devolver os números prontos)
  static Future<void> carregar() async {
    if (AppConfig.usarMock) return; // mock: já está na memória

    final json = await ApiClient.get(AppConfig.epRegistrosAgua) as List<dynamic>;
    DadosApp.registros = json
        .map((item) => RegistroAgua.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /registros-agua
  ///   envia:   {"quantidadeMl": 300, "dataHora": "2026-11-06T10:30:00"}
  ///   recebe:  o registro criado (com "id")
  static Future<void> adicionar(int quantidadeMl) async {
    final novo = RegistroAgua(quantidadeMl, DateTime.now());

    if (AppConfig.usarMock) {
      DadosApp.registros.add(novo);
      return;
    }

    final json = await ApiClient.post(AppConfig.epRegistrosAgua, novo.toJson());
    DadosApp.registros.add(RegistroAgua.fromJson(json as Map<String, dynamic>));
  }
}
