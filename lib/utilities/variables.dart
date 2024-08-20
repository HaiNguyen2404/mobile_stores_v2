import 'package:flutter/material.dart';
import 'package:mobile_store/pages/account_page.dart';
import 'package:mobile_store/pages/cart_page.dart';
import 'package:mobile_store/pages/home_page.dart';

// Theme colors
const Color secondaryColor = Color.fromARGB(255, 238, 238, 238);

// Bottom navigation bar items
List<Widget> pages = <Widget>[
  const HomePage(),
  const CartPage(),
  const AccountPage(),
];

const String token =
    'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTcyMzYxOTQyOSwiZXhwIjoxNzIzNjIxMjI5fQ.kgNw1AxrDVLnX3vlloNLcwRiIPf06c8pGjMI5fRXCGU';

const List<Locale> locale = [
  Locale('en'),
  Locale('vi'),
];
