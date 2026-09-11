import 'package:flutter_test/flutter_test.dart';
import 'package:mannona_try_e_commerce/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MannonaApp());
    expect(find.text('Mannona Try E-Commerce'), findsOneWidget);
  });
}
