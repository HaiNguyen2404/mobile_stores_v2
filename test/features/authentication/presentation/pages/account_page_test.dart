import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_store/core/localization/presentation/local_cubit/local_cubit.dart';
import 'package:mobile_store/features/authentication/domain/entities/user.dart';
import 'package:mobile_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_store/features/authentication/presentation/pages/account_page.dart';
import 'package:mobile_store/features/authentication/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

class MockLocalCubit extends MockCubit<LocalState> implements LocalCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;
  late MockLocalCubit mockLocalCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    mockLocalCubit = MockLocalCubit();

    when(() => mockLocalCubit.checkLocal()).thenReturn('en');
    when(() => mockLocalCubit.checkLocalState()).thenAnswer((_) {});
  });
  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalCubit>.value(value: mockLocalCubit),
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
        home: AccountPage(),
      ),
    );
  }

  testWidgets('account page ...', (tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('You are not signed in'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('shows loading state', (WidgetTester tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthLoading());

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows loaded state with user name and logout',
      (WidgetTester tester) async {
    final user = User(name: 'Hai Nguyen', token: 'token');

    when(() => mockAuthCubit.state).thenReturn(AuthLoaded(user));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Hai Nguyen'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('shows error state with error message',
      (WidgetTester tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthError('An error occurred'));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('An error occurred'), findsOneWidget);
  });

  testWidgets('navigate to login page', (WidgetTester tester) async {
    when(() => mockAuthCubit.state).thenReturn(AuthInitial());

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Login'));

    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
