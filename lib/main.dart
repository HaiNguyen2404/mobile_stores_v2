import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/core/localization/presentation/local_cubit/local_cubit.dart';
import 'package:mobile_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_store/features/home/presentation/cubit/product_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_store/shared/constants/variables.dart';
import 'package:mobile_store/core/di/injections.dart' as di;
import 'features/cart/presentation/cart_cubit/cart_cubit.dart';
import 'shared/presentation/layout.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await FirebaseApi().initNotifications();

  // initialize hive
  await Hive.initFlutter();

  // open the boxes
  await Hive.openBox('token_box');
  final localBox = await Hive.openBox('local_box');
  if (localBox.get(0) == null) {
    localBox.put(0, 'en');
  }

  di.init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => di.locator<CartCubit>()),
      BlocProvider(create: (context) => di.locator<LocalCubit>()),
      BlocProvider(create: (context) => di.locator<ProductCubit>()),
      BlocProvider(create: (context) => di.locator<AuthCubit>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalCubit, LocalState>(
      builder: (_, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: Locale(context.read<LocalCubit>().checkLocal()),
          supportedLocales: locale,
          navigatorKey: navigatorKey,
          home: const Layout(),
        );
      },
    );
  }
}
