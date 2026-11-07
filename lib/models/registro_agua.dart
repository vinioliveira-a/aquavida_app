/// UM registro de consumo de água (um copo, uma garrafa...).
///
/// MySQL (sugestão): tabela `registros_agua`
///   id, usuario_id (FK), quantidade_ml INT, data_hora DATETIME
class RegistroAgua {
  int? id;
  int quantidadeMl; // quantidade em mililitros
  DateTime dataHora; // dia e horário do registro

  RegistroAgua(this.quantidadeMl, this.dataHora, {this.id});

  factory RegistroAgua.fromJson(Map<String, dynamic> json) {
    return RegistroAgua(
      (json['quantidadeMl'] as num).toInt(),
      DateTime.parse(json['dataHora'] as String),
      id: (json['id'] as num?)?.toInt(),
    );
  }

  /// dataHora vai como "AAAA-MM-DDTHH:mm:ss" (Java LocalDateTime).
  Map<String, dynamic> toJson() => {
        'id': id,
        'quantidadeMl': quantidadeMl,
        'dataHora': dataHora.toIso8601String().substring(0, 19),
      };
}
