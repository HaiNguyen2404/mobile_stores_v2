import 'package:get_it/get_it.dart';
import 'package:mobile_store/features/home/data/datasource/api_service.dart';
import 'package:mobile_store/features/home/data/datasource/product_data_source.dart';
import 'package:mobile_store/features/home/data/repository/product_repo_impl.dart';
import 'package:mobile_store/features/home/domain/repository/product_repo.dart';
import 'package:mobile_store/features/home/domain/usecases/product_usecases.dart';
import 'package:mobile_store/features/home/presentation/cubit/product_cubit.dart';

final locator = GetIt.instance;

Future<void> init() async {
  locator.registerFactory(() => ProductCubit(
        locator<FetchProduct>(),
        locator<RefreshProduct>(),
        locator<CheckRemainProduct>(),
      ));

  locator.registerLazySingleton(() => FetchProduct(locator()));
  locator.registerLazySingleton(() => RefreshProduct(locator()));
  locator.registerLazySingleton(() => CheckRemainProduct(locator()));

  locator.registerLazySingleton<ProductRepo>(() => ProductRepoImpl(locator()));

  locator.registerLazySingleton<ProductDataSource>(
      () => ProductDataSourceImpl(locator()));

  locator.registerLazySingleton(() => ApiService());
}
