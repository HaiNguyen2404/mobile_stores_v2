import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_store/core/localization/presentation/local_cubit/local_cubit.dart';
import 'package:mobile_store/features/authentication/domain/entities/user.dart';
import 'package:mobile_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_store/features/authentication/presentation/pages/login_page.dart';
import 'package:mobile_store/features/cart/domain/entities/cart.dart';
import 'package:mobile_store/features/cart/domain/entities/order.dart';
import 'package:mobile_store/features/cart/presentation/cart_cubit/cart_cubit.dart';
import 'package:mobile_store/features/cart/presentation/pages/cart_page.dart';
import 'package:mobile_store/features/cart/presentation/widgets/grand_total.dart';
import 'package:mobile_store/features/cart/presentation/widgets/order_tile.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockLocalCubit extends MockCubit<LocalState> implements LocalCubit {}

void main() {
  late MockCartCubit mockCartCubit;
  late MockAuthCubit mockAuthCubit;
  late MockLocalCubit mockLocalCubit;

  setUp(() {
    mockCartCubit = MockCartCubit();
    mockAuthCubit = MockAuthCubit();
    mockLocalCubit = MockLocalCubit();

    when(() => mockAuthCubit.state).thenAnswer((_) => AuthInitial());
    when(() => mockAuthCubit.checkUserState()).thenAnswer((_) async => true);
    when(() => mockLocalCubit.checkLocalState()).thenAnswer((_) async => 'en');
    when(() => mockLocalCubit.checkLocal()).thenReturn('en');
    when(() => mockLocalCubit.state).thenAnswer((_) => English('en'));

    when(() => mockCartCubit.deleteOrders())
        .thenAnswer((_) async => mockCartCubit);

    when(() => mockCartCubit.checkCartEmty()).thenReturn(false);
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalCubit>.value(value: mockLocalCubit),
        BlocProvider<CartCubit>.value(value: mockCartCubit),
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
      ],
      child: const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
        ],
        locale: Locale('en'),
        home: CartPage(),
      ),
    );
  }

  testWidgets('Cart Loaded', (tester) async {
    final orders = [
      Order(id: 1, name: 'Product1', price: 10, quantity: 2),
      Order(id: 2, name: 'Product2', price: 20, quantity: 1),
    ];

    final cart = Cart(orderList: orders);
    when(() => mockCartCubit.state).thenReturn(CartLoaded(cart));

    await tester.pumpWidget(createWidgetUnderTest());

    final orderWidgets = find.byType(OrderTile);

    // Check 1st OrderTile
    expect(tester.widgetList(orderWidgets).elementAt(0), isA<OrderTile>());
    expect(tester.widget<OrderTile>(orderWidgets.at(0)).order.name,
        equals('Product1'));
    expect(
        tester.widget<OrderTile>(orderWidgets.at(0)).order.price, equals(10));
    expect(
        tester.widget<OrderTile>(orderWidgets.at(0)).order.quantity, equals(2));

    // Check 2nd OrderTile
    expect(tester.widgetList(orderWidgets).elementAt(1), isA<OrderTile>());
    expect(tester.widget<OrderTile>(orderWidgets.at(1)).order.name,
        equals('Product2'));
    expect(
        tester.widget<OrderTile>(orderWidgets.at(1)).order.price, equals(20));
    expect(
        tester.widget<OrderTile>(orderWidgets.at(1)).order.quantity, equals(1));

    // Check Grand Total
    final grandTotalWidget = find.byType(GrandTotal);
    expect((tester.widget(grandTotalWidget) as GrandTotal).grandTotal, 40);
  });

  testWidgets('clears cart', (tester) async {
    final orders = [
      Order(id: 1, name: 'Product1', price: 10, quantity: 2),
      Order(id: 2, name: 'Product2', price: 20, quantity: 1),
    ];

    when(() => mockCartCubit.state)
        .thenReturn(CartLoaded(Cart(orderList: orders)));

    whenListen(
      mockCartCubit,
      Stream.fromIterable([
        CartLoaded(Cart(orderList: orders)),
        CartLoaded(Cart(orderList: [])),
      ]),
      initialState: CartLoaded(Cart(orderList: orders)),
    );

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Clear Cart'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Emty'));
    await tester.pumpAndSettle();

    verify(() => mockCartCubit.deleteOrders()).called(1);

    final orderFinder = find.byType(OrderTile);
    expect(orderFinder, findsNothing);
  });

  testWidgets('shows error state', (WidgetTester tester) async {
    when(() => mockCartCubit.state).thenReturn(CartError('An error occurred'));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('An error occurred'), findsOneWidget);
  });

  testWidgets('navigates to login on checkout if not authenticated',
      (WidgetTester tester) async {
    when(() => mockCartCubit.state).thenReturn(CartLoaded(Cart(orderList: [])));

    when(() => mockAuthCubit.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Check out'));

    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('shows snackbar message on checkout success',
      (WidgetTester tester) async {
    final orders = [
      Order(name: 'Product 1', quantity: 1, price: 100, id: 1),
      Order(name: 'Product 2', quantity: 2, price: 200, id: 2),
    ];
    final cart = Cart(orderList: orders);
    final user = User(token: 'token', name: 'Hai');

    when(() => mockCartCubit.state).thenReturn(CartLoaded(cart));
    when(() => mockAuthCubit.state).thenReturn(AuthLoaded(user));
    when(() => mockCartCubit.checkoutAndClearCart('token'))
        .thenAnswer((_) async => true);

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Check out'));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);

    expect(find.text('Checked out!'), findsOneWidget);
  });
}
