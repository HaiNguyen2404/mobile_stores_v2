import 'package:flutter/material.dart';
import 'package:mobile_store/features/authentication/presentation/pages/account_page.dart';
import 'package:mobile_store/features/home/presentation/pages/home_page.dart';
import 'package:mobile_store/features/cart/presentation/pages/cart_page.dart';

// Theme colors
const Color secondaryColor = Color.fromARGB(255, 238, 238, 238);

// Bottom navigation bar items
List<Widget> pages = <Widget>[
  const HomePage(),
  const CartPage(),
  const AccountPage(),
];

const List<Locale> locale = [
  Locale('en'),
  Locale('vi'),
];

const String baseUrl = 'http://10.0.2.2:8080/api/v2';
