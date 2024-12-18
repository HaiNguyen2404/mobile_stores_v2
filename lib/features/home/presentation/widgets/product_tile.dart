import 'package:flutter/material.dart';
import 'package:mobile_store/features/cart/presentation/cart_cubit/cart_cubit.dart';
import 'package:mobile_store/features/home/presentation/pages/details_page.dart';
import 'package:mobile_store/shared/presentation/my_button.dart';
import 'package:mobile_store/shared/constants/variables.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/presentation/local_cubit/local_cubit.dart';
import '../../domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
  });

  final Product product;

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          product.image != null
              ? Image.network(
                  product.image!,
                  fit: BoxFit.fitHeight,
                )
              : const Icon(Icons.person),
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
          BlocBuilder<LocalCubit, LocalState>(
            builder: (context, state) {
              if (state is English) {
                return Text('${product.price} USD');
              } else if (state is Vietnamese) {
                return Text('${product.price * state.convertedValue} đ');
              } else {
                return const Center(child: Text('Product price load failure'));
              }
            },
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
                    addToCart(context, product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.name} ${AppLocalizations.of(context)!.added_to_cart}',
                        ),
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

  addToCart(BuildContext context, Product product) {
    context.read<CartCubit>().addToCart(product);
  }
}
