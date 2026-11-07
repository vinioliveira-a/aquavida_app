import 'config_lembrete.dart';
import 'usuario.dart';

/// Dados que a pessoa vai preenchendo nos 3 passos do cadastro.
/// No final (passo 3) tudo é enviado de uma vez: POST /usuarios.
class NovoCadastro {
  // Passo 1
  String nomeUsuario = '';
  String email = '';
  String senha = '';

  // Passo 2
  String nome = '';
  double pesoKg = 70;
  DateTime? dataNascimento;
  int metaDiariaMl = 2000;

  // Passo 3
  ConfigLembrete lembretes = ConfigLembrete();

  /// Corpo (JSON) enviado à API. Contém a senha: use sempre HTTPS em produção
  /// e guarde apenas o hash dela no MySQL.
  Map<String, dynamic> toJson() => {
        'nomeUsuario': nomeUsuario,
        'email': email,
        'senha': senha,
        'nome': nome,
        'pesoKg': pesoKg,
        'dataNascimento': dataNascimento == null
            ? null
            : dataNascimento!.toIso8601String().substring(0, 10),
        'metaDiariaMl': metaDiariaMl,
        'lembretes': lembretes.toJson(),
      };

  /// Usado no modo mock (sem servidor): vira o usuário logado.
  Usuario paraUsuario() => Usuario(
        nomeUsuario: nomeUsuario,
        email: email,
        nome: nome,
        pesoKg: pesoKg,
        dataNascimento: dataNascimento,
        metaDiariaMl: metaDiariaMl,
        lembretes: lembretes,
      );
}
