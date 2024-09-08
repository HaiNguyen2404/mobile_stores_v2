import 'package:dio/dio.dart';

class RemoteData {
  static const endpoint =
      'https://currency-api.pages.dev/v1/currencies/usd.json';
  final dio = Dio();
  double unitValue = 1;

  Future<double> getConvertAmount(String local) async {
    if (local != 'en') {
      try {
        String locale = 'vnd';
        final response = await dio.get(endpoint);

        if (response.statusCode == 200) {
          unitValue = double.parse(
            response.data['usd'][locale].toStringAsFixed(1),
          );
        }
        return unitValue;
      } on Exception catch (e) {
        throw Exception('Failed to get convert value: $e');
      }
    } else {
      return 1;
    }
  }
}
