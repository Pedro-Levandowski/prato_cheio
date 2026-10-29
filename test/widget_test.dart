import 'package:flutter_test/flutter_test.dart';
import 'package:prato_cheio/main.dart';

void main() {
  testWidgets('Tela principal mostra o nome do app', (tester) async {
    await tester.pumpWidget(const PratoCheioApp());
    expect(find.text('Prato Cheio'), findsOneWidget);
    expect(find.text('Buscar receitas'), findsOneWidget);
    expect(find.text('Receitas disponíveis'), findsOneWidget);
  });
}
