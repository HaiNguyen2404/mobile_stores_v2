import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:mobile_store/core/localization/presentation/local_cubit/local_cubit.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';

import 'package:mobile_store/features/home/presentation/cubit/product_cubit.dart';
import 'package:mobile_store/features/home/presentation/pages/home_page.dart';
import 'package:mobile_store/features/home/presentation/widgets/product_tile.dart';
import 'package:mocktail/mocktail.dart';

class MockProductCubit extends MockCubit<ProductState>
    implements ProductCubit {}

class MockLocalCubit extends MockCubit<LocalState> implements LocalCubit {}

void main() {
  late MockProductCubit mockProductCubit;
  late MockLocalCubit mockLocalCubit;

  setUp(() {
    mockProductCubit = MockProductCubit();
    mockLocalCubit = MockLocalCubit();
    when(() => mockProductCubit.fetchProducts()).thenAnswer((_) async {});
    when(() => mockProductCubit.checkRemainProducts()).thenReturn(true);
  });
  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales: const [Locale('en')],
      home: BlocProvider<ProductCubit>(
        create: (_) => mockProductCubit,
        child: const HomePage(),
      ),
    );
  }

  Widget createLocalizeWidget() {
    return MaterialApp(
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales: const [Locale('en')],
      home: BlocProvider<ProductCubit>(
        create: (_) => mockProductCubit,
        child: BlocProvider<LocalCubit>(
          create: (context) => mockLocalCubit,
          child: const HomePage(),
        ),
      ),
    );
  }

  testWidgets('renders loading state', (WidgetTester tester) async {
    whenListen(
      mockProductCubit,
      Stream.fromIterable([LoadingState()]),
      initialState: LoadingState(),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders loaded state with products',
      (WidgetTester tester) async {
    final products = [
      Product(
        name: 'Product 1',
        id: 1,
        price: 1,
        quantity: 1,
        description: '',
        manufacturer: '',
        category: '',
        condition: '',
      ),
      Product(
        name: 'Product 2',
        quantity: 2,
        description: '',
        manufacturer: '',
        category: '',
        condition: '',
        id: 2,
        price: 2,
      ),
    ];
    whenListen(
      mockProductCubit,
      Stream.fromIterable([LoadedProductState(products)]),
      initialState: LoadedProductState(products),
    );
    whenListen(
      mockLocalCubit,
      Stream.fromIterable([English('en')]),
      initialState: English('en'),
    );
    await tester.pumpWidget(createLocalizeWidget());
    expect(find.byType(ProductTile), findsNWidgets(2));
  });

  testWidgets('renders empty state', (WidgetTester tester) async {
    whenListen(
      mockProductCubit,
      Stream.fromIterable([EmptyState()]),
      initialState: EmptyState(),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Empty'), findsOneWidget);
  });

  testWidgets('renders error state', (WidgetTester tester) async {
    const message = 'Error loading product';

    whenListen(
      mockProductCubit,
      Stream.fromIterable([ErrorState(message)]),
      initialState: ErrorState(message),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text(message), findsOneWidget);
  });

  testWidgets('check if products are in right order',
      (WidgetTester tester) async {
    final products = [
      Product(
        name: 'Product 1',
        id: 1,
        price: 1,
        quantity: 1,
        description: 'description1',
        manufacturer: 'manufacturer1',
        category: 'category1',
        condition: 'condition1',
      ),
      Product(
        name: 'Product 2',
        quantity: 2,
        description: 'description1',
        manufacturer: 'manufacturer2',
        category: 'category2',
        condition: 'condition2',
        id: 2,
        price: 2,
      ),
    ];

    whenListen(
      mockProductCubit,
      Stream.fromIterable([LoadedProductState(products)]),
      initialState: LoadedProductState(products),
    );
    whenListen(
      mockLocalCubit,
      Stream.fromIterable([English('en')]),
      initialState: English('en'),
    );

    await tester.pumpWidget(createLocalizeWidget());

    final productWidgets = find.byType(ProductTile);

    expect(tester.widgetList(productWidgets).elementAt(0), isA<ProductTile>());
    expect(tester.widget<ProductTile>(productWidgets.at(0)).product.name,
        equals('Product 1'));

    expect(tester.widgetList(productWidgets).elementAt(1), isA<ProductTile>());
    expect(tester.widget<ProductTile>(productWidgets.at(1)).product.name,
        equals('Product 2'));
  });
}
