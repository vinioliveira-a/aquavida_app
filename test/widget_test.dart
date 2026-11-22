// Testes automáticos simples do AquaVida.
// Para rodar: flutter test

import 'package:flutter_test/flutter_test.dart';

import 'package:aquavida/core/utils/validacoes.dart';
import 'package:aquavida/dados/dados_app.dart';
import 'package:aquavida/main.dart';

void main() {
  // Antes de cada teste, volta os dados ao estado inicial
  setUp(() {
    DadosApp.limpar();
    DadosApp.carregarDadosDemonstracao();
  });

  test('formata números com ponto de milhar', () {
    expect(DadosApp.formatarNumero(500), '500');
    expect(DadosApp.formatarNumero(2393), '2.393');
    expect(DadosApp.formatarNumero(1000000), '1.000.000');
  });

  test('registrar água aumenta o consumo de hoje', () {
    int antes = DadosApp.consumoHoje();
    DadosApp.registros.add(RegistroAgua(300, DateTime.now()));
    expect(DadosApp.consumoHoje(), antes + 300);
  });

  test('porcentagem da meta (meta padrão: 2000 ml)', () {
    expect(DadosApp.porcentagemDaMeta(1000), 50);
    expect(DadosApp.porcentagemDaMeta(2000), 100);
  });

  test('valida data de nascimento', () {
    expect(validarDataNascimento('15/03/2000'), isNull);
    expect(validarDataNascimento('31/02/2000'), isNotNull); // data impossível
    expect(validarDataNascimento('15/03/2999'), isNotNull); // no futuro
    expect(validarDataNascimento(''), isNotNull);
  });

  test('valida e-mail e senha', () {
    expect(validarEmail('ana@email.com'), isNull);
    expect(validarEmail('ana@'), isNotNull);
    expect(validarSenha('12345'), isNotNull);
    expect(validarConfirmacaoSenha('abcdef', 'abcdeg'), isNotNull);
  });

  testWidgets('botão Começar abre o login', (tester) async {
    await tester.pumpWidget(const AquaVidaApp());
    expect(find.text('Começar'), findsOneWidget);

    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();

    expect(find.text('Que bom te ver de volta!'), findsOneWidget);
  });
}
