
import 'config_lembrete.dart';

/// Usuário do AquaVida.
class Usuario {
  int? id;
  String nomeUsuario;
  String email;
  String nome;
  double pesoKg;
  DateTime? dataNascimento;
  String nivelAtividade;
  int metaDiariaMl;
  ConfigLembrete lembretes;

  Usuario({
    this.id,
    this.nomeUsuario = '',
    this.email = '',
    this.nome = 'Usuário',
    this.pesoKg = 70,
    this.dataNascimento,
    this.nivelAtividade = 'Moderado',
    this.metaDiariaMl = 2000,
    ConfigLembrete? lembretes,
  }) : lembretes = lembretes ?? ConfigLembrete();

  int? get idade {
    if (dataNascimento == null) return null;

    final hoje = DateTime.now();
    int anos = hoje.year - dataNascimento!.year;

    final fezAniversario = hoje.month > dataNascimento!.month ||
        (hoje.month == dataNascimento!.month &&
            hoje.day >= dataNascimento!.day);

    if (!fezAniversario) anos--;

    return anos;
  }

  Usuario copyWith({
    String? nomeUsuario,
    String? email,
    String? nome,
    double? pesoKg,
    DateTime? dataNascimento,
    String? nivelAtividade,
    int? metaDiariaMl,
    ConfigLembrete? lembretes,
  }) {
    return Usuario(
      id: id,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      pesoKg: pesoKg ?? this.pesoKg,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      nivelAtividade: nivelAtividade ?? this.nivelAtividade,
      metaDiariaMl: metaDiariaMl ?? this.metaDiariaMl,
      lembretes: lembretes ?? this.lembretes,
    );
  }

  /// Recebe os campos separados enviados pelo Java.
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: (json['id'] as num?)?.toInt(),
      nomeUsuario: json['nomeUsuario'] as String? ?? '',
      email: json['email'] as String? ?? '',
      nome: json['nome'] as String? ?? 'Usuário',
      pesoKg: (json['pesoKg'] as num?)?.toDouble() ?? 70,
      dataNascimento: json['dataNascimento'] == null
          ? null
          : DateTime.parse(json['dataNascimento'] as String),
      nivelAtividade: json['nivelAtividade'] as String? ?? 'Moderado',
      metaDiariaMl: (json['metaDiariaMl'] as num?)?.toInt() ?? 2000,
      lembretes: ConfigLembrete(
        ativo: json['lembretesAtivo'] as bool? ?? false,
        inicio: json['lembretesInicio'] as String?,
        fim: json['lembretesFim'] as String?,
        intervaloMin:
            (json['lembretesIntervaloMin'] as num?)?.toInt() ?? 10,
      ),
    );
  }

  /// Envia os campos no formato esperado pelo Java.
  Map<String, dynamic> toJson() => {
        'nome': nome,
        'pesoKg': pesoKg,
        'dataNascimento': dataNascimento == null
            ? null
            : dataNascimento!.toIso8601String().substring(0, 10),
        'nivelAtividade': nivelAtividade,
        'metaDiariaMl': metaDiariaMl,
        'lembretesAtivo': lembretes.ativo,
        'lembretesInicio': lembretes.inicio,
        'lembretesFim': lembretes.fim,
        'lembretesIntervaloMin': lembretes.intervaloMin,
      };
}
