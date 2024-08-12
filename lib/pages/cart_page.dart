import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/pages/layout.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/widgets/my_button.dart';
import 'package:mobile_store/widgets/order_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cartBox = Hive.box('cart_box');

  List<Map<dynamic, dynamic>> _orders = [];

  int grandTotal = 0;

  void clearCart() {
    _cartBox.deleteAll(_cartBox.keys);
  }

  List<Map<dynamic, dynamic>> getOrders() {
    return _cartBox.values.toList().cast<Map<dynamic, dynamic>>();
  }

  Map<dynamic, dynamic> convertToOrderMap(Map<dynamic, dynamic> order) {
    Map<dynamic, dynamic> orderMap = {};
    orderMap['productId'] = order['id'];
    orderMap['quantity'] = order['quantity'];
    orderMap['unitPrice'] = order['unitPrice'];

    return orderMap;
  }

  List<Map<dynamic, dynamic>> getOrderMapList(
      List<Map<dynamic, dynamic>> orders) {
    List<Map<dynamic, dynamic>> ordersMapList = [];
    for (Map<dynamic, dynamic> order in orders) {
      ordersMapList.add(convertToOrderMap(order));
    }

    return ordersMapList;
  }

  void _refreshOrders() {
    setState(() {
      _orders = getOrders();

      grandTotal = 0;

      if (_orders != []) {
        for (Map<dynamic, dynamic> order in _orders) {
          grandTotal =
              grandTotal + (order['quantity'] * order['unitPrice']) as int;
        }
      }
    });
  }

  /// Checkout cart
  Future<void> submit() async {
    const token =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsInJvbGUiOiJBRE1JTiIsImlhdCI6MTcyMzQyMDI2NSwiZXhwIjoxNzIzNDIyMDY1fQ.hS6fPjYIKrbrBYcMkt94JbzjqhJUWEI8vCJN_LlD8wo';
    final body = jsonEncode({
      'total': grandTotal.toString(),
      'paymentMethod': 2,
      'orderStatus': 1,
      'details': getOrderMapList(_orders),
    });

    final dio = Dio(BaseOptions(headers: {'Authorization': 'Bearer $token'}));

    const url = 'http://192.168.0.9:8080/api/v2/orders';
    final response = await dio.post(url, data: body);

    if (response.statusCode == 201 && mounted) {
      showMessage(AppLocalizations.of(context)!.checked_out);
      clearCart();
      _refreshOrders();
    } else {
      showMessage('Check out Failed');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              AppLocalizations.of(context)!.cart,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              AppLocalizations.of(context)!.cart_subtitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size(0, 25),
          child: SizedBox(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            color: secondaryColor,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppLocalizations.of(context)!.products,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppLocalizations.of(context)!.quantity,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppLocalizations.of(context)!.unit_price,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppLocalizations.of(context)!.details_price,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            itemCount: _orders.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return OrderTile(
                order: _orders[index],
                refresh: _refreshOrders,
              );
            },
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '${AppLocalizations.of(context)!.grand_total}: \$${grandTotal.toString()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          const SizedBox(height: 30),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: MyButton(
              text: AppLocalizations.of(context)!.clear_cart,
              color: Colors.red,
              icon: Icons.close,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(AppLocalizations.of(context)!.emty_cart),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          clearCart();
                          Navigator.pop(context);
                          _refreshOrders();
                        },
                        child: Text(AppLocalizations.of(context)!.emty),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: MyButton(
              text: AppLocalizations.of(context)!.check_out,
              color: Colors.green,
              icon: Icons.shopping_cart,
              onTap: () {
                _cartBox.isEmpty
                    ? showMessage(AppLocalizations.of(context)!.cart_is_emty)
                    : submit();
              },
            ),
          ),
          const SizedBox(height: 30),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: MyButton(
              text: AppLocalizations.of(context)!.continue_shopping,
              color: Colors.green,
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Layout()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
