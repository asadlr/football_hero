import 'package:flutter_test/flutter_test.dart';
import 'package:football_hero/main.dart';

void main() {
  testWidgets('App renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Check for widgets
    expect(find.text('כניסה'), findsOneWidget);
    expect(find.text('הצטרף לקבוצה!'), findsOneWidget);
  });
}
