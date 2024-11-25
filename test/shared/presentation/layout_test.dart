import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_store/core/localization/presentation/local_cubit/local_cubit.dart';
import 'package:mobile_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_store/features/cart/presentation/cart_cubit/cart_cubit.dart';
import 'package:mobile_store/features/home/presentation/cubit/product_cubit.dart';
import 'package:mobile_store/shared/presentation/layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalCubit extends MockCubit<LocalState> implements LocalCubit {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockProductCubit extends MockCubit<ProductState>
    implements ProductCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockLocalCubit mockLocalCubit;
  late MockAuthCubit mockAuthCubit;
  late MockProductCubit mockProductCubit;
  late MockCartCubit mockCartCubit;

  setUpAll(() {
    mockLocalCubit = MockLocalCubit();
    mockAuthCubit = MockAuthCubit();
    mockProductCubit = MockProductCubit();
    mockCartCubit = MockCartCubit();

    when(() => mockAuthCubit.state).thenAnswer((_) => AuthInitial());
    when(() => mockAuthCubit.checkUserState()).thenAnswer((_) async => true);
    when(() => mockLocalCubit.checkLocalState()).thenAnswer((_) async => 'en');
    when(() => mockLocalCubit.checkLocal()).thenReturn('en');
    when(() => mockProductCubit.state).thenAnswer((_) => LoadingState());
    when(() => mockCartCubit.state).thenAnswer((_) => CartLoading());

    when(() => mockProductCubit.fetchProducts()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('vi')],
      locale: const Locale('en'),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LocalCubit>.value(value: mockLocalCubit),
          BlocProvider<AuthCubit>.value(value: mockAuthCubit),
          BlocProvider<ProductCubit>.value(value: mockProductCubit),
          BlocProvider<CartCubit>.value(value: mockCartCubit),
        ],
        child: const Layout(),
      ),
    );
  }

  testWidgets('renders and navigates between pages',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify initial state
    expect(find.byIcon(Icons.home), findsNothing);
    expect(find.byIcon(Icons.shopping_cart_sharp), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    var iconFinder = find.byType(BottomNavigationBar);

    var iconWidget = tester.widget<BottomNavigationBar>(iconFinder);

    expect(iconWidget.selectedItemColor, equals(Colors.blue));
  });
}
