import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/app_config.dart';

/// Erro mostrado ao usuário quando a API falha (rede, senha errada etc.).
class ApiException implements Exception {
  final String mensagem;
  final int? statusCode;

  ApiException(this.mensagem, {this.statusCode});

  @override
  String toString() => mensagem;
}

/// Cliente HTTP único do app. Todos os serviços passam por aqui.
///
/// >>> EQUIPE DO BACK-END: veja `AppConfig` para URL e endpoints. <<<
///
/// Convenções esperadas da API:
///  - Corpo e resposta em JSON (UTF-8).
///  - Sucesso: status 2xx.
///  - Erro: status 4xx/5xx com {"mensagem": "texto para o usuário"}.
///  - Rotas protegidas: header  Authorization: Bearer <token JWT>.
class ApiClient {
  ApiClient._();

  /// Token JWT devolvido no login (null = ninguém logado).
  static String? token;

  static Map<String, String> get _cabecalhos => {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Uri _uri(String caminho) =>
      Uri.parse('${AppConfig.apiBaseUrl}$caminho');

  static Future<dynamic> get(String caminho) {
    return _enviar(() => http.get(_uri(caminho), headers: _cabecalhos));
  }

  static Future<dynamic> post(String caminho, [Map<String, dynamic>? corpo]) {
    return _enviar(
      () => http.post(
        _uri(caminho),
        headers: _cabecalhos,
        body: jsonEncode(corpo ?? {}),
      ),
    );
  }

  static Future<dynamic> put(String caminho, Map<String, dynamic> corpo) {
    return _enviar(
      () => http.put(
        _uri(caminho),
        headers: _cabecalhos,
        body: jsonEncode(corpo),
      ),
    );
  }

  /// Envia a requisição, trata erros e devolve o JSON já convertido.
  static Future<dynamic> _enviar(
    Future<http.Response> Function() requisicao,
  ) async {
    try {
      final resposta = await requisicao().timeout(AppConfig.timeout);
      final texto = utf8.decode(resposta.bodyBytes);
      final corpo = texto.isEmpty ? null : jsonDecode(texto);

      if (resposta.statusCode >= 200 && resposta.statusCode < 300) {
        return corpo;
      }

      final mensagem = (corpo is Map && corpo['mensagem'] is String)
          ? corpo['mensagem'] as String
          : 'Erro ${resposta.statusCode} no servidor.';
      throw ApiException(mensagem, statusCode: resposta.statusCode);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('O servidor demorou demais para responder.');
    } on FormatException {
      throw ApiException('Resposta inválida do servidor.');
    } catch (_) {
      throw ApiException('Não foi possível conectar ao servidor.');
    }
  }
}
