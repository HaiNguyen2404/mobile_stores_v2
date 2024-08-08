import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/widgets/product_tile.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Paging variables
  int page = 1;
  static const limit = 2;
  bool hasMore = true;

  // Products list fetching
  late Future<List<Product>> futureProducts;
  List<Product> currentProducts = [];

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
    _scrollController.addListener(scrollNotify);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverAppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'Products',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  'All available product in our store',
                  style: TextStyle(fontSize: 18),
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
                          child: hasMore
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

  Future<List<Product>> fetchProducts() async {
    final url =
        'http://192.168.0.9:8080/api/v2/products?page=$page&limit=$limit';
    // final uri = Uri.parse(url);
    // final response = await http.get(uri);

    final dio = Dio(BaseOptions(responseType: ResponseType.plain));
    final response = await dio.get(url);

    final data = jsonDecode(response.data);
    final products = data['content']
        .map<Product>((product) => Product.fromJson(product))
        .toList();

    if (response.statusCode == 200) {
      if (products.length < limit) {
        hasMore = false;
      }

      page++;
      currentProducts.addAll(products);

      return currentProducts;
    } else {
      throw Exception('Failed to load Products');
    }
  }

  void scrollNotify() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        futureProducts = fetchProducts();
      });
    }
  }

  Future<void> refresh() async {
    setState(() {
      page = 1;
      currentProducts.clear();
      futureProducts = fetchProducts();
      hasMore = true;
    });
  }
}
