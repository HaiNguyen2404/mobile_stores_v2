import 'package:flutter/material.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/models/product_repository.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/widgets/product_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductRepository productRepository = ProductRepository();
  late Future<List<Product>> futureProducts;

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureProducts = productRepository.fetchProducts();
    _scrollController.addListener(scrollNotify);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.products,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  AppLocalizations.of(context)!.home_subtitle,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            floating: true,
            // flexibleSpace: Placeholder(),
            expandedHeight: 80,
            backgroundColor: secondaryColor,
          ),
          FutureBuilder(
            future: futureProducts,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                    child: Text('Retrieve Failed ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final List<Product> products = snapshot.data!;

                return SliverList.builder(
                    itemCount: products.length + 1,
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        return ProductTile(
                          product: products[index],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: productRepository.hasMore
                              ? const Center(child: CircularProgressIndicator())
                              : const Center(
                                  child: Text('No more data to load')),
                        );
                      }
                    });
              } else {
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
        ],
      ),
    );
  }

  void scrollNotify() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        futureProducts = productRepository.fetchProducts();
      });
    }
  }

  Future<void> refresh() async {
    setState(() {
      productRepository.productsRefresh();
      futureProducts = productRepository.fetchProducts();
    });
  }
}
