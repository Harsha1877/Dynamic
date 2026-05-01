import 'package:dynamic_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders Crimson Depth music dashboard', (tester) async {
    await tester.pumpWidget(const DynamicApp());
    await tester.pumpAndSettle();

    expect(find.text('Dynamic'), findsOneWidget);
    expect(find.text('Good Evening'), findsOneWidget);
    expect(find.text('Midnight Signal'), findsWidgets);
    expect(find.text('Recently Played'), findsOneWidget);
  });
}
