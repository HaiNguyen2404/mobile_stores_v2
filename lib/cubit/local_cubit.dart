import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/cubit/local_state.dart';

class LocalCubit extends Cubit<LocalState> {
  LocalCubit() : super(LocalState(local: 'en'));
  String local = 'en';
  static double usdValue = 1;

  changeLanguage(Locale locale) {
    if (locale == const Locale('en')) {
      local = 'en';
      emit(English(
        local: local,
        currencyValue: usdValue,
      ));
    } else {
      local = 'vi';
      double currencyValue = getConvertAmount('vnd');
      emit(Vietnamese(
        local: local,
        currencyValue: currencyValue,
      ));
    }
  }

  getConvertAmount(String currency) async {
    double unitValue = 1;
    const endPoint = 'https://currency-api.pages.dev/v1/currencies/';

    final dio = Dio(BaseOptions(responseType: ResponseType.plain));

    try {
      final response = await dio.get('${endPoint}usd.json');

      if (response.statusCode == 200) {
        unitValue =
            double.parse(jsonDecode(response.data)['usd'][currency].toString());
      }

      return unitValue;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get convert value');
      }
    }
  }
}
