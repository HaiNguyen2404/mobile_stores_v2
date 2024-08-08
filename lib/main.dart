import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/pages/layout.dart';
import 'package:mobile_store/listview_paging.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open the box
  await Hive.openBox('cart_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Layout(),
    );
  }
}
