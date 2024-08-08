import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/pages/layout.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/widgets/my_button.dart';
import 'package:mobile_store/widgets/order_tile.dart';
import 'package:dio/dio.dart';

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
    final body = jsonEncode({
      'total': grandTotal.toString(),
      'details': getOrderMapList(_orders),
    });

    const url = 'http://192.168.0.9:8080/api/v1/orders';
    final response = await Dio().post(url, data: body);

    if (response.statusCode == 201 && mounted) {
      showMessage('Checked out!');
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
        title: const Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              "Cart",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              "All products selected are in your cart",
              style: TextStyle(
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
                    child: const Text(
                      'Product',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                    child: const Text(
                      'Qty',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                    child: const Text(
                      'Unit Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                    child: const Text(
                      'Price',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                'Grand Total: \$${grandTotal.toString()}',
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
              text: 'Clear Cart',
              color: Colors.red,
              icon: Icons.close,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Emty cart?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          clearCart();
                          Navigator.pop(context);
                          _refreshOrders();
                        },
                        child: const Text('Emty'),
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
              text: 'Check Out',
              color: Colors.green,
              icon: Icons.shopping_cart,
              onTap: () {
                _cartBox.isEmpty ? showMessage('Cart is emty!') : submit();
              },
            ),
          ),
          const SizedBox(height: 30),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: MyButton(
              text: 'Continue Shopping',
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
