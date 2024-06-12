import 'package:flutter/material.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/widgets/my_button.dart';

class DetailsPage extends StatelessWidget {
  final Function addOrder;
  const DetailsPage({
    super.key,
    required this.product,
    required this.addOrder,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            centerTitle: true,
            title: Text(
              'Products',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            floating: true,
            expandedHeight: 60,
            backgroundColor: secondaryColor,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 350,
                  padding: const EdgeInsets.all(20),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 15, height: 2),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            'Item Code: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 1,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange[300],
                            ),
                            child: Text(
                              '15264403828${product.id.toString()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Manufacturer: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: product.manufacturer,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Category: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: product.category,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Available units in stock: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: product.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Price: ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${product.price.toString()} USD',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          text: 'Back',
                          color: Colors.green,
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: MyButton(
                          text: 'Order Now',
                          color: Colors.orange[300],
                          icon: Icons.shopping_cart,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
