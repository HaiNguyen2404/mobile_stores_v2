import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/pages/details_page.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/widgets/my_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductTile extends StatelessWidget {
  ProductTile({
    super.key,
    required this.product,
  });

  final Product product;

  final _cartBox = Hive.box('cart_box');

  void writeData(int key, Map<String, dynamic> value) {
    _cartBox.put(key, value);
  }

  Map<dynamic, dynamic> getProductMap() {
    return _cartBox.get(product.id);
  }

  List<int> getProductId() {
    return _cartBox.keys.toList().cast<int>();
  }

  void addOrder() {
    List<int> productIds = getProductId();
    if (productIds.contains(product.id)) {
      int quantity = getProductMap()['quantity'];
      quantity++;
      writeData(product.id, {
        'id': product.id,
        'name': product.name,
        'quantity': quantity,
        'unitPrice': product.price,
      });
    } else {
      writeData(
        product.id,
        {
          'id': product.id,
          'name': product.name,
          'quantity': 1,
          'unitPrice': product.price,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: secondaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        // shape: BoxShape.circle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            product.image,
            fit: BoxFit.fitHeight,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                height: 1.2,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '\$${product.price.toString()} USD',
          ),
          Text(
            '${product.quantity.toString()} ${AppLocalizations.of(context)!.remains}',
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: MyButton(
                  text: AppLocalizations.of(context)!.details,
                  color: Colors.blue,
                  icon: Icons.info,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        product: product,
                        addOrder: () {
                          addOrder();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: MyButton(
                  text: AppLocalizations.of(context)!.order,
                  color: Colors.orange[300],
                  icon: Icons.shopping_cart_rounded,
                  onTap: () {
                    addOrder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to cart'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
