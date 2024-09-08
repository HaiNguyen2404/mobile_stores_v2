import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/features/cart/domain/entities/order.dart';
import 'package:mobile_store/features/cart/presentation/cart_cubit/cart_cubit.dart';
import 'package:mobile_store/features/cart/presentation/widgets/price.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  const OrderTile({
    super.key,
    required this.order,
  });

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
                            title: Text('Remove ${order.name} from cart?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  removeItem(context, order);
                                  Navigator.pop(context);
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
                        order.name,
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
                  order.quantity.toString(),
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
                child: Price(price: order.price),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Price(price: (order.quantity * order.price)),
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

  removeItem(BuildContext context, Order order) {
    context.read<CartCubit>().deleteAnOrder(order);
  }
}
