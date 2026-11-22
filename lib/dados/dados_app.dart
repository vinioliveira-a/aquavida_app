import 'package:flutter/material.dart';

import '../models/novo_cadastro.dart';
import '../models/registro_agua.dart';
import '../models/usuario.dart';

// As telas importam só este arquivo e já enxergam o RegistroAgua.
export '../models/registro_agua.dart';

/// Guarda os dados do app ENQUANTO ele está aberto (estado em memória).
///
/// Como funciona:
///  - As telas LEEM daqui (ex.: DadosApp.nome, DadosApp.registros).
///  - Para ALTERAR dados, as telas chamam os serviços (pasta services/).
///    Os serviços falam com a API e atualizam esta classe.
///
/// >>> EQUIPE DO BACK-END: não precisa mexer aqui. Veja `services/`. <<<
class DadosApp {
  DadosApp._();

  // =============================================================
  // USUÁRIO LOGADO
  // =============================================================
  static Usuario usuario = Usuario();

  // Atalhos de leitura usados pelas telas
  static String get nome => usuario.nome;
  static double get peso => usuario.pesoKg;
  static String get nivelAtividade => usuario.nivelAtividade;
  static int get metaDiariaMl => usuario.metaDiariaMl;

  /// Ex.: "20 anos • 70 kg • Moderado" (a idade some se não houver nascimento).
  static String resumoPerfil() {
    final idade = usuario.idade;
    final partes = [
      if (idade != null) '$idade anos',
      '${formatarPeso(peso)} kg',
      nivelAtividade,
    ];
    return partes.join(' • ');
  }

  // Dados preenchidos durante o cadastro (passos 1 a 3)
  static NovoCadastro novoCadastro = NovoCadastro();

  // Opções de nível de atividade física
  static const List<String> niveisAtividade = [
    'Sedentário',
    'Leve',
    'Moderado',
    'Intenso',
  ];

  // =============================================================
  // PREFERÊNCIAS SOMENTE DO APARELHO (não vão para o servidor)
  // =============================================================
  static String unidade = 'ml'; // 'ml' (mililitros) ou 'L' (litros)

  // ValueNotifier "avisa" quando muda. O main.dart escuta esta variável
  // para trocar o tema do app inteiro (claro/escuro).
  static final ValueNotifier<bool> temaEscuro = ValueNotifier<bool>(false);

  // =============================================================
  // REGISTROS DE CONSUMO
  // =============================================================
  static List<RegistroAgua> registros = [];

  /// Volta tudo ao estado inicial (usado ao sair da conta).
  static void limpar() {
    usuario = Usuario();
    novoCadastro = NovoCadastro();
    registros = [];
    unidade = 'ml';
    temaEscuro.value = false;
  }

  // =============================================================
  // DADOS DE DEMONSTRAÇÃO (só usados quando AppConfig.usarMock = true)
  // =============================================================

  /// Cria registros fictícios dos últimos 14 dias para demonstrar
  /// o histórico e as estatísticas. O dia de hoje começa vazio.
  ///
  /// BACK-END: no futuro, os registros serão buscados no back-end.
  static void carregarDadosDemonstracao() {
    registros.clear();

    // Cada lista representa um dia, com os copos de água bebidos (em ml).
    List<List<int>> diasExemplo = [
      [300, 500, 200, 750, 300], // total: 2.050 ml
      [500, 500, 300, 750, 200, 500], // total: 2.750 ml
      [200, 300, 500, 300], // total: 1.300 ml
      [750, 500, 300, 500, 300], // total: 2.350 ml
      [500, 750, 500, 750, 300, 300], // total: 3.100 ml
      [300, 200, 500, 300, 500], // total: 1.800 ml
      [500, 300, 750, 500], // total: 2.050 ml
    ];

    // Horários em que cada copo foi "bebido"
    List<int> horarios = [8, 10, 12, 15, 17, 19, 21];

    DateTime hoje = DateTime.now();

    // dia = 1 é ontem, dia = 2 é anteontem, e assim por diante.
    for (int dia = 1; dia <= 14; dia++) {
      DateTime data = DateTime(hoje.year, hoje.month, hoje.day - dia);
      List<int> copos = diasExemplo[dia % diasExemplo.length];

      for (int i = 0; i < copos.length; i++) {
        DateTime dataHora = DateTime(
          data.year,
          data.month,
          data.day,
          horarios[i],
        );
        registros.add(RegistroAgua(copos[i], dataHora));
      }
    }
  }

  /// Apaga todos os registros (útil para mostrar as telas vazias).
  static void apagarRegistros() {
    registros.clear();
  }

  // =============================================================
  // CÁLCULOS DO DIA
  // =============================================================

  /// Verifica se duas datas são do mesmo dia (ignora o horário).
  static bool mesmoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Retorna os registros de um dia, do mais recente para o mais antigo.
  static List<RegistroAgua> registrosDoDia(DateTime dia) {
    List<RegistroAgua> lista = [];
    for (RegistroAgua registro in registros) {
      if (mesmoDia(registro.dataHora, dia)) {
        lista.add(registro);
      }
    }
    lista.sort((a, b) => b.dataHora.compareTo(a.dataHora));
    return lista;
  }

  /// Soma de água (em ml) consumida em um dia.
  static int totalDoDia(DateTime dia) {
    int total = 0;
    for (RegistroAgua registro in registros) {
      if (mesmoDia(registro.dataHora, dia)) {
        total = total + registro.quantidadeMl;
      }
    }
    return total;
  }

  /// Quanto o usuário já bebeu hoje (em ml).
  static int consumoHoje() {
    return totalDoDia(DateTime.now());
  }

  /// Porcentagem da meta (pode passar de 100%).
  static int porcentagemDaMeta(int totalMl) {
    if (metaDiariaMl <= 0) {
      return 0;
    }
    return (totalMl * 100 / metaDiariaMl).round();
  }

  /// Progresso de 0.0 a 1.0, usado nas barras e no círculo de progresso.
  static double progressoDaMeta(int totalMl) {
    if (metaDiariaMl <= 0) {
      return 0;
    }
    double progresso = totalMl / metaDiariaMl;
    if (progresso > 1) {
      progresso = 1;
    }
    return progresso;
  }

  // =============================================================
  // HISTÓRICO E ESTATÍSTICAS
  // =============================================================

  /// Lista com os dias que possuem registros (do mais recente para o mais antigo).
  static List<DateTime> diasComRegistro() {
    List<DateTime> dias = [];
    for (RegistroAgua registro in registros) {
      DateTime dia = DateTime(
        registro.dataHora.year,
        registro.dataHora.month,
        registro.dataHora.day,
      );
      if (!dias.contains(dia)) {
        dias.add(dia);
      }
    }
    dias.sort((a, b) => b.compareTo(a));
    return dias;
  }

  /// Dias com registro dentro dos últimos [quantidadeDias] dias (contando hoje).
  /// Exemplo: quantidadeDias = 7 considera a última semana.
  static List<DateTime> diasDoPeriodo(int quantidadeDias) {
    DateTime hoje = DateTime.now();
    DateTime inicio = DateTime(
      hoje.year,
      hoje.month,
      hoje.day - (quantidadeDias - 1),
    );

    List<DateTime> lista = [];
    for (DateTime dia in diasComRegistro()) {
      if (!dia.isBefore(inicio)) {
        lista.add(dia);
      }
    }
    return lista;
  }

  /// Média de consumo por dia (considera apenas os dias com registro).
  static int mediaDiaria(int quantidadeDias) {
    List<DateTime> dias = diasDoPeriodo(quantidadeDias);
    if (dias.isEmpty) {
      return 0;
    }
    int soma = 0;
    for (DateTime dia in dias) {
      soma = soma + totalDoDia(dia);
    }
    return (soma / dias.length).round();
  }

  /// Dia com o maior consumo no período (ou null se não houver registros).
  static DateTime? melhorDia(int quantidadeDias) {
    DateTime? melhor;
    int maiorTotal = 0;
    for (DateTime dia in diasDoPeriodo(quantidadeDias)) {
      int total = totalDoDia(dia);
      if (total > maiorTotal) {
        maiorTotal = total;
        melhor = dia;
      }
    }
    return melhor;
  }

  /// Quantos dias do período atingiram a meta diária.
  static int diasComMetaAtingida(int quantidadeDias) {
    int contador = 0;
    for (DateTime dia in diasDoPeriodo(quantidadeDias)) {
      if (totalDoDia(dia) >= metaDiariaMl) {
        contador++;
      }
    }
    return contador;
  }

  /// Os últimos 7 dias, do mais antigo até hoje (usado no gráfico semanal).
  static List<DateTime> ultimos7Dias() {
    DateTime hoje = DateTime.now();
    List<DateTime> dias = [];
    for (int i = 6; i >= 0; i--) {
      dias.add(DateTime(hoje.year, hoje.month, hoje.day - i));
    }
    return dias;
  }

  // =============================================================
  // OUTROS CÁLCULOS
  // =============================================================

  /// Sugestão simples de meta: 35 ml por kg + um extra pela atividade física.
  static int calcularMetaSugerida(double pesoKg, String nivel) {
    int meta = (pesoKg * 35).round();
    if (nivel == 'Leve') {
      meta = meta + 250;
    } else if (nivel == 'Moderado') {
      meta = meta + 500;
    } else if (nivel == 'Intenso') {
      meta = meta + 750;
    }
    // Arredonda para um múltiplo de 50 (ex.: 2.437 -> 2.450)
    return (meta / 50).round() * 50;
  }

  /// Primeira letra do nome (usada no círculo do avatar).
  static String inicialDoNome() {
    String texto = nome.trim();
    if (texto.isEmpty) {
      return 'U';
    }
    return texto[0].toUpperCase();
  }

  // =============================================================
  // FORMATAÇÃO DE TEXTOS
  // =============================================================

  /// Coloca o ponto de milhar: 2393 -> "2.393".
  static String formatarNumero(int numero) {
    String texto = numero.toString();
    String resultado = '';
    int contador = 0;
    for (int i = texto.length - 1; i >= 0; i--) {
      resultado = '${texto[i]}$resultado';
      contador++;
      if (contador % 3 == 0 && i > 0) {
        resultado = '.$resultado';
      }
    }
    return resultado;
  }

  /// Número na unidade escolhida, sem o nome da unidade.
  /// Exemplo: 2350 -> "2.350" (ml) ou "2,35" (L).
  /// Os valores são sempre guardados em ml; a unidade muda só a exibição.
  static String formatarValor(int quantidadeMl) {
    if (unidade == 'L') {
      double litros = quantidadeMl / 1000;
      return litros.toStringAsFixed(2).replaceAll('.', ',');
    }
    return formatarNumero(quantidadeMl);
  }

  /// Número com a unidade. Exemplo: "2.350 ml" ou "2,35 L".
  static String formatarQuantidade(int quantidadeMl) {
    return '${formatarValor(quantidadeMl)} $unidade';
  }

  /// Peso sem casas decimais desnecessárias: 70.0 -> "70", 72.5 -> "72,5".
  static String formatarPeso(double kg) {
    if (kg == kg.roundToDouble()) {
      return kg.round().toString();
    }
    return kg.toStringAsFixed(1).replaceAll('.', ',');
  }

  static const List<String> diasDaSemana = [
    'Seg',
    'Ter',
    'Qua',
    'Qui',
    'Sex',
    'Sáb',
    'Dom',
  ];

  /// Completa com zero à esquerda: 5 -> "05".
  static String doisDigitos(int numero) {
    return numero.toString().padLeft(2, '0');
  }

  /// Nome curto do dia da semana: "Seg", "Ter"...
  static String nomeDoDia(DateTime data) {
    return diasDaSemana[data.weekday - 1];
  }

  /// Exemplo: "Seg, 27/10".
  static String formatarDataCurta(DateTime data) {
    return '${nomeDoDia(data)}, ${doisDigitos(data.day)}/${doisDigitos(data.month)}';
  }

  /// "Hoje", "Ontem" ou a data curta.
  static String formatarData(DateTime data) {
    DateTime hoje = DateTime.now();
    DateTime ontem = DateTime(hoje.year, hoje.month, hoje.day - 1);
    if (mesmoDia(data, hoje)) {
      return 'Hoje';
    }
    if (mesmoDia(data, ontem)) {
      return 'Ontem';
    }
    return formatarDataCurta(data);
  }

  /// Exemplo: "08:05".
  static String formatarHora(DateTime data) {
    return '${doisDigitos(data.hour)}:${doisDigitos(data.minute)}';
  }
}
