import 'config_lembrete.dart';

/// Usuário do AquaVida.
///
/// MySQL (sugestão): tabela `usuarios`
///   id, nome_usuario, email, senha_hash, nome, peso_kg,
///   data_nascimento, nivel_atividade, meta_diaria_ml + colunas de lembrete.
/// A SENHA nunca volta para o app e só é guardada como hash (ex.: BCrypt).
class Usuario {
  int? id;
  String nomeUsuario; // usado no login/identificação
  String email;
  String nome; // como o app chama a pessoa
  double pesoKg;
  DateTime? dataNascimento;
  String nivelAtividade; // Sedentário | Leve | Moderado | Intenso
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

  /// Idade calculada a partir da data de nascimento (null se não informada).
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

  /// Datas vão e voltam como "AAAA-MM-DD" (formato padrão do Java LocalDate).
  factory Usuario.fromJson(Map<String, dynamic> json) {
    final nascimento = json['dataNascimento'] as String?;
    return Usuario(
      id: (json['id'] as num?)?.toInt(),
      nomeUsuario: json['nomeUsuario'] as String? ?? '',
      email: json['email'] as String? ?? '',
      nome: json['nome'] as String? ?? 'Usuário',
      pesoKg: (json['pesoKg'] as num?)?.toDouble() ?? 70,
      dataNascimento: nascimento == null ? null : DateTime.parse(nascimento),
      nivelAtividade: json['nivelAtividade'] as String? ?? 'Moderado',
      metaDiariaMl: (json['metaDiariaMl'] as num?)?.toInt() ?? 2000,
      lembretes: json['lembretes'] is Map<String, dynamic>
          ? ConfigLembrete.fromJson(json['lembretes'] as Map<String, dynamic>)
          : ConfigLembrete(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nomeUsuario': nomeUsuario,
        'email': email,
        'nome': nome,
        'pesoKg': pesoKg,
        'dataNascimento': dataNascimento == null
            ? null
            : dataNascimento!.toIso8601String().substring(0, 10),
        'nivelAtividade': nivelAtividade,
        'metaDiariaMl': metaDiariaMl,
        'lembretes': lembretes.toJson(),
      };
}
