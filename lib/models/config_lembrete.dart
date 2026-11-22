/// Configuração dos lembretes de água de um usuário.
///
/// MySQL (sugestão): colunas da tabela `usuarios`
///   lembrete_ativo TINYINT(1), lembrete_inicio TIME,
///   lembrete_fim TIME, lembrete_intervalo_min INT
class ConfigLembrete {
  bool ativo;

  /// Horários no formato "HH:mm" (ex.: "08:00"). Null = não definido.
  String? inicio;
  String? fim;

  /// Intervalo entre lembretes, em minutos (5, 10 ou 15).
  int intervaloMin;

  ConfigLembrete({
    this.ativo = false,
    this.inicio,
    this.fim,
    this.intervaloMin = 10,
  });

  ConfigLembrete copyWith({
    bool? ativo,
    String? inicio,
    String? fim,
    int? intervaloMin,
  }) {
    return ConfigLembrete(
      ativo: ativo ?? this.ativo,
      inicio: inicio ?? this.inicio,
      fim: fim ?? this.fim,
      intervaloMin: intervaloMin ?? this.intervaloMin,
    );
  }

  factory ConfigLembrete.fromJson(Map<String, dynamic> json) {
    return ConfigLembrete(
      ativo: json['ativo'] as bool? ?? false,
      inicio: json['inicio'] as String?,
      fim: json['fim'] as String?,
      intervaloMin: (json['intervaloMin'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        'ativo': ativo,
        'inicio': inicio,
        'fim': fim,
        'intervaloMin': intervaloMin,
      };
}
