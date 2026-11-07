// Funções que validam os campos dos formulários.
// Cada função recebe o texto digitado e devolve:
//   - null  -> quando o valor está correto
//   - texto -> mensagem de erro para mostrar ao usuário

String? validarUsuario(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe um nome de usuário.';
  }
  if (valor.trim().length < 3) {
    return 'O usuário precisa ter pelo menos 3 caracteres.';
  }
  return null;
}

String? validarEmail(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe o e-mail.';
  }
  final formato = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!formato.hasMatch(valor.trim())) {
    return 'E-mail inválido.';
  }
  return null;
}

String? validarSenha(String? valor) {
  if (valor == null || valor.isEmpty) {
    return 'Informe a senha.';
  }
  if (valor.length < 6) {
    return 'A senha precisa ter pelo menos 6 caracteres.';
  }
  return null;
}

String? validarConfirmacaoSenha(String senha, String confirmacao) {
  if (confirmacao.isEmpty) {
    return 'Confirme a senha.';
  }
  if (senha != confirmacao) {
    return 'As senhas não conferem.';
  }
  return null;
}

String? validarNome(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe o seu nome.';
  }
  if (valor.trim().length < 2) {
    return 'O nome precisa ter pelo menos 2 letras.';
  }
  return null;
}

/// Converte o texto do peso em número. Aceita vírgula ou ponto (72,5 ou 72.5).
double? converterPeso(String texto) {
  return double.tryParse(texto.trim().replaceAll(',', '.'));
}

String? validarPeso(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe o peso.';
  }
  double? peso = converterPeso(valor);
  if (peso == null || peso < 20 || peso > 300) {
    return 'Peso inválido.';
  }
  return null;
}

/// Converte "DD/MM/AAAA" em data. Devolve null se não for uma data real.
DateTime? converterData(String texto) {
  final partes = texto.trim().split('/');
  if (partes.length != 3) return null;
  final dia = int.tryParse(partes[0]);
  final mes = int.tryParse(partes[1]);
  final ano = int.tryParse(partes[2]);
  if (dia == null || mes == null || ano == null || partes[2].length != 4) {
    return null;
  }
  final data = DateTime(ano, mes, dia);
  // DateTime "corrige" datas impossíveis (31/02 vira março), então conferimos
  if (data.day != dia || data.month != mes || data.year != ano) return null;
  return data;
}

String? validarDataNascimento(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe a data de nascimento.';
  }
  final data = converterData(valor);
  if (data == null) {
    return 'Data inválida. Use DD/MM/AAAA.';
  }
  final agora = DateTime.now();
  if (data.isAfter(agora) || agora.year - data.year > 120) {
    return 'Data de nascimento inválida.';
  }
  return null;
}

String? validarMeta(String? valor) {
  if (valor == null || valor.trim().isEmpty) {
    return 'Informe a meta diária.';
  }
  int? meta = int.tryParse(valor.trim());
  if (meta == null) {
    return 'Digite apenas números.';
  }
  if (meta < 500) {
    return 'A meta mínima é 500 ml.';
  }
  if (meta > 6000) {
    return 'A meta máxima é 6.000 ml.';
  }
  return null;
}
