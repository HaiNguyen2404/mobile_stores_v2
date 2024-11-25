import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_store/features/authentication/presentation/pages/account_page.dart';
import 'package:mobile_store/features/cart/presentation/widgets/order_tile.dart';
import 'package:mobile_store/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration test', () {
    testWidgets('Initialize app', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 2));

      await tester.pumpAndSettle();

      expect(find.text('Iphone 15'), findsOneWidget);
      expect(find.text('Samsung Galaxy S23 Ultra 15G'), findsOneWidget);

      final listFinder = find.byType(CustomScrollView);

      await tester.drag(listFinder, const Offset(0, -700));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));
      await tester.drag(listFinder, const Offset(0, -700));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));
      await tester.drag(listFinder, const Offset(0, -700));
      await tester.pumpAndSettle();
      expect(find.text('No more data to load'), findsOneWidget);

      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.text('Order Now').at(1));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.shopping_cart_sharp));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(
        tester.widget<OrderTile>(find.byType(OrderTile)).order.name,
        'Redmi Turbo 3',
      );

      await tester.tap(find.byIcon(Icons.close).at(0));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.byType(OrderTile), findsNothing);

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text('You are not signed in'), findsOneWidget);

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.enterText(
        find.byType(TextField).at(0),
        'hainm',
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await tester.enterText(
        find.byType(TextField).at(1),
        '12345',
      );
      await Future.delayed(const Duration(milliseconds: 500));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextField).at(1), '123456');
      await Future.delayed(const Duration(milliseconds: 500));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 1));
      expect(find.byType(AccountPage), findsOneWidget);
      expect(find.text('Nguyen Minh Hai'), findsOneWidget);
    });
  });
}
