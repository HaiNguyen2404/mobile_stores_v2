import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_store/features/home/domain/entities/product.dart';
import 'package:mobile_store/features/home/domain/usecases/product_usecases.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final FetchProduct fetchProduct;
  final RefreshProduct refreshProduct;
  final CheckRemainProduct checkRemainProduct;

  ProductCubit(
    this.fetchProduct,
    this.refreshProduct,
    this.checkRemainProduct,
  ) : super(LoadingState());

  Future<void> fetchProducts() async {
    try {
      final products = await fetchProduct.execute();

      if (products != []) {
        emit(LoadedProductState(products));
      } else {
        emit(EmptyState());
      }
    } catch (e) {
      emit(ErrorState('Failed to fetch: $e'));
    }
  }

  void refreshProducts() {
    refreshProduct.execute();
  }

  bool checkRemainProducts() {
    return checkRemainProduct.execute();
  }
}
