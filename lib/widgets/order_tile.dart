import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrderTile extends StatelessWidget {
  final Map<dynamic, dynamic> order;
  final Function refresh;
  OrderTile({
    super.key,
    required this.order,
    required this.refresh,
  });

  final _cartBox = Hive.box('cart_box');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // item's name
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Remove ${order['name']} from cart?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _cartBox.delete(order['id']);
                                  Navigator.pop(context);
                                  refresh();
                                },
                                child: const Text('Remove'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        order['name'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // item quantity
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  order['quantity'].toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // item unit price
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  order['unitPrice'].toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  '${order['quantity'] * order['unitPrice']}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 1,
          indent: 7,
          endIndent: 7,
        ),
      ],
    );
  }
}
