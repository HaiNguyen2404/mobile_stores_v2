import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/cubit/cart_cubit.dart';
import 'package:mobile_store/cubit/local_cubit.dart';
import 'package:mobile_store/cubit/local_state.dart';
import 'package:mobile_store/pages/layout.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_store/utilities/variables.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open the boxes
  await Hive.openBox('cart_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
            create: (context) => CartCubit(
                cartBox: Hive.box('cart_box'),
                dio: Dio(
                    BaseOptions(headers: {'Authorization': 'Bearer $token'})))),
        BlocProvider<LocalCubit>(create: (context) => LocalCubit()),
      ],
      child: BlocBuilder<LocalCubit, LocalState>(
        builder: (_, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Locale(state.local),
            supportedLocales: locale,
            home: const Layout(),
          );
        },
      ),
    );
  }
}
