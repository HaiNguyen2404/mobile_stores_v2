import 'package:flutter/material.dart';
import 'package:mobile_store/features/authentication/account_page.dart';
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

const String token =
    'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTcyNTcxODM5MCwiZXhwIjoxNzI1NzIwMTkwfQ.IDWN05j2Ud1vVMVhcVwtU3MHN6N51RXtf48SUFFWYs4';

const List<Locale> locale = [
  Locale('en'),
  Locale('vi'),
];
