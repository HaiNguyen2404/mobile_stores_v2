import 'package:flutter/material.dart';
import 'package:mobile_store/features/home/presentation/cubit/product_cubit.dart';
import 'package:mobile_store/features/home/presentation/widgets/product_tile.dart';
import 'package:mobile_store/shared/constants/variables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late Future<List<Product>> futureProducts;
  // ProductRepository productRepository = ProductRepository(
  //     dio: Dio(BaseOptions(responseType: ResponseType.plain)));

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // futureProducts = productRepository.fetchProducts();
    refresh();
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
          // FutureBuilder(
          //   future: futureProducts,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasError) {
          //       return SliverToBoxAdapter(
          //           child: Text('Retrieve Failed ${snapshot.error}'));
          //     } else if (snapshot.hasData) {
          //       final List<Product> products = snapshot.data!;

          //       return SliverList.builder(
          //           itemCount: products.length + 1,
          //           itemBuilder: (context, index) {
          //             if (index < products.length) {
          //               return ProductTile(
          //                 product: products[index],
          //               );
          //             } else {
          //               return Padding(
          //                 padding: const EdgeInsets.symmetric(vertical: 20),
          //                 child: productRepository.hasMore
          //                     ? const Center(child: CircularProgressIndicator())
          //                     : Center(
          //                         child: Text(AppLocalizations.of(context)!
          //                             .no_more_data),
          //                       ),
          //               );
          //             }
          //           });
          //     } else {
          //       return const SliverToBoxAdapter(
          //           child: Center(child: CircularProgressIndicator()));
          //     }
          //   },
          // ),

          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state is EmptyState) {
                return const Center(child: Text('Empty'));
              } else if (state is LoadedProductState) {
                return SliverList.builder(
                  itemCount: state.products.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.products.length) {
                      return ProductTile(product: state.products[index]);
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: hasMore()
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                child: Text(
                                    AppLocalizations.of(context)!.no_more_data),
                              ),
                      );
                    }
                  },
                );
              } else if (state is ErrorState) {
                return SliverToBoxAdapter(
                  child: Center(child: Text(state.message)),
                );
              } else {
                return const Center(child: Text('Wrong state!'));
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
      fetchProducts();
    }
  }

  Future<void> refresh() async {
    context.read<ProductCubit>().refreshProducts();
    fetchProducts();
  }

  fetchProducts() {
    context.read<ProductCubit>().fetchProducts();
  }

  bool hasMore() {
    return context.read<ProductCubit>().checkRemainProducts();
  }
}
