import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_store/core/localization/presentation/local_cubit/local_cubit.dart';
import 'package:mobile_store/features/cart/presentation/cart_cubit/cart_cubit.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';
import 'package:mobile_store/features/home/presentation/widgets/product_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_store/shared/presentation/my_button.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalCubit extends MockCubit<LocalState> implements LocalCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockLocalCubit mockLocalCubit;
  late MockCartCubit mockCartCubit;

  setUp(() {
    mockLocalCubit = MockLocalCubit();
    mockCartCubit = MockCartCubit();
  });

  Widget createWidgetUnderTest(Product product) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LocalCubit>.value(value: mockLocalCubit),
          BlocProvider<CartCubit>.value(value: mockCartCubit),
        ],
        child: Scaffold(body: ProductTile(product: product)),
      ),
    );
  }

  testWidgets('Check product with USD price', (tester) async {
    final product = Product(
      name: 'Test Product',
      price: 100,
      quantity: 10,
      id: 1,
      description: '',
      manufacturer: '',
      category: '',
      condition: '',
    );

    when(() => mockLocalCubit.state).thenAnswer((_) => English('en'));

    await tester.pumpWidget(createWidgetUnderTest(product));

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('100 USD'), findsOneWidget);

    expect(find.byType(MyButton), findsNWidgets(2));
  });

  testWidgets('Check product with VND price', (tester) async {
    final product = Product(
      name: 'Test Product',
      price: 100,
      quantity: 10,
      id: 1,
      description: '',
      manufacturer: '',
      category: '',
      condition: '',
    );

    whenListen(
      mockLocalCubit,
      Stream.fromIterable([Vietnamese('vi', 25000)]),
      initialState: Vietnamese('vi', 25000),
    );

    await tester.pumpWidget(createWidgetUnderTest(product));

    await tester.pump();

    expect(find.text('Test Product'), findsOneWidget);
    expect(mockLocalCubit.state, isA<Vietnamese>());

    expect(find.text('${100 * 25000}.0 đ'), findsOneWidget);

    expect(find.byType(MyButton), findsNWidgets(2));
  });

  testWidgets('calls addToCart when order button is tapped',
      (WidgetTester tester) async {
    final product = Product(
      name: 'Test Product',
      price: 100,
      quantity: 10,
      id: 1,
      description: 'description',
      manufacturer: 'manufacturer',
      category: 'category',
      condition: 'condition',
    );
    when(() => mockLocalCubit.state).thenReturn(English('en'));

    await tester.pumpWidget(createWidgetUnderTest(product));

    await tester.tap(find.text(
        AppLocalizations.of(tester.element(find.byType(ProductTile)))!.order));

    verify(() => mockCartCubit.addToCart(product)).called(1);
  });

  testWidgets('verify if the components are right',
      (WidgetTester tester) async {
    final product = Product(
      name: 'Test Product',
      price: 100,
      quantity: 10,
      id: 1,
      description: 'description',
      manufacturer: 'manufacturer',
      category: 'category',
      condition: 'condition',
    );
    when(() => mockLocalCubit.state).thenReturn(English('en'));

    await tester.pumpWidget(createWidgetUnderTest(product));

    final nameFinder = find.text('Test Product');
    final priceFinder = find.text('100 USD');
    final quantityFinder = find.text('10 units in stock');

    expect(nameFinder, findsOneWidget);
    expect(priceFinder, findsOneWidget);
    expect(quantityFinder, findsOneWidget);

    final nameOffset = tester.getTopLeft(nameFinder);
    final priceOffset = tester.getTopLeft(priceFinder);
    final quantityOffset = tester.getTopLeft(quantityFinder);

    expect(nameOffset.dy < priceOffset.dy, isTrue);
    expect(quantityOffset.dy > priceOffset.dy, isTrue);
  });
}
