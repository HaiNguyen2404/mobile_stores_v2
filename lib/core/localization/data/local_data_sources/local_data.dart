import 'package:hive_flutter/hive_flutter.dart';

class LocalData {
  final localBox = Hive.box('local_box');

  String getLocal() {
    return localBox.get(0);
  }

  void changeLocal(String local) {
    localBox.put(0, local);
  }
}
