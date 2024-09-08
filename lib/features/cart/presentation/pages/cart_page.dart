import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/pages/layout.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/features/cart/presentation/widgets/grand_total.dart';
import 'package:mobile_store/features/cart/presentation/widgets/order_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../shared/presentation/my_button.dart';
import '../cart_cubit/cart_cubit.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    getOrders();
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
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: Text('There nothing!'),
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is CartLoaded) {
                return Column(
                  children: [
                    ListView.builder(
                      itemCount: state.cart.orderList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return OrderTile(
                          order: state.cart.orderList[index],
                        );
                      },
                    ),
                    GrandTotal(grandTotal: state.cart.grandTotal()),
                  ],
                );
              }
              return const SizedBox();
            },
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
                          clearAllItems();
                          Navigator.pop(context);
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
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220),
                child: MyButton(
                  text: AppLocalizations.of(context)!.check_out,
                  color: Colors.green,
                  icon: Icons.shopping_cart,
                  onTap: () {
                    if (state is CartLoaded) {
                      if (state.cart.orderList.isEmpty) {
                        showMessage('Cart is empty!');
                      } else {
                        checkout();
                      }
                    }
                  },
                ),
              );
            },
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

  getOrders() {
    context.read<CartCubit>().loadCart();
  }

  clearAllItems() {
    context.read<CartCubit>().deleteOrders();
  }

  checkout() async {
    var response = await context.read<CartCubit>().checkoutAndClearCart();
    if (response && mounted) {
      showMessage(AppLocalizations.of(context)!.checked_out);
    } else {
      showMessage('Failed');
    }
  }
}
