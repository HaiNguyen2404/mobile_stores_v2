import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_store/models/product.dart';
import 'package:mobile_store/utilities/variables.dart';
import 'package:mobile_store/widgets/product_tile.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                itemCount: products.length,
                itemBuilder: (context, index) => ProductTile(
                  product: products[index],
                ),
              );
            } else {
              return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ],
    );
  }

  Future<List<Product>> fetchProducts() async {
    const url = 'http://192.168.0.8:8080/api/v1/products';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    final data = jsonDecode(response.body);
    final products =
        data.map<Product>((product) => Product.fromJson(product)).toList();

    if (response.statusCode == 200) {
      return products;
    } else {
      throw Exception('Failed to load Products');
    }
  }
}
