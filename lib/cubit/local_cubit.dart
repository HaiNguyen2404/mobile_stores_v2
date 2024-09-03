import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/cubit/local_state.dart';

class LocalCubit extends Cubit<LocalState> {
  LocalCubit({required this.localBox})
      : super(LocalState(local: localBox.get("language")));

  final Box localBox;

  checkLocal() async {
    if (localBox.get("language") == "vi") {
      double currencyValue = await getConvertAmount('vnd');
      emit(Vietnamese(local: 'vi', currencyValue: currencyValue));
    } else {
      emit(English(local: 'en'));
    }
  }

  changeLanguage() async {
    String locale = localBox.get("language");
    if (locale == 'en') {
      localBox.put("language", "en");
      emit(English(local: localBox.get("language")));
    } else {
      localBox.put("language", "vi");
      double currencyValue = await getConvertAmount('vnd');
      emit(Vietnamese(
        local: localBox.get("language"),
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
        unitValue = double.parse(
            jsonDecode(response.data)['usd'][currency].toStringAsFixed(1));
      }

      return unitValue;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get convert value');
      }
    }
  }
}
