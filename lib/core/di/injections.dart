import 'package:get_it/get_it.dart';
import 'package:mobile_store/core/localization/data/local_data_sources/local_data.dart';
import 'package:mobile_store/core/localization/data/local_data_sources/remote_data.dart';
import 'package:mobile_store/core/localization/data/repositories/local_repo_impl.dart';
import 'package:mobile_store/core/localization/domain/repositories/local_repo.dart';
import 'package:mobile_store/core/localization/domain/usecases/local_usecases.dart';
import 'package:mobile_store/core/localization/presentation/local_cubit/local_cubit.dart';
import 'package:mobile_store/features/authentication/data/datasources/auth_datasource.dart';
import 'package:mobile_store/features/authentication/data/repository/auth_repo_impl.dart';
import 'package:mobile_store/features/authentication/domain/repository/auth_repo.dart';
import 'package:mobile_store/features/authentication/domain/usecases/auth_usecases.dart';
import 'package:mobile_store/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:mobile_store/features/cart/data/datasources/order_data_source.dart';
import 'package:mobile_store/features/cart/data/repositories/cart_repo_impl.dart';
import 'package:mobile_store/features/cart/domain/repositories/cart_repo.dart';
import 'package:mobile_store/features/cart/domain/usecases/cart_usecases.dart';
import 'package:mobile_store/features/cart/presentation/cart_cubit/cart_cubit.dart';
import 'package:mobile_store/features/home/data/datasource/api_service.dart';
import 'package:mobile_store/features/home/data/datasource/product_data_source.dart';
import 'package:mobile_store/features/home/data/repository/product_repo_impl.dart';
import 'package:mobile_store/features/home/domain/repository/product_repo.dart';
import 'package:mobile_store/features/home/domain/usecases/product_usecases.dart';
import 'package:mobile_store/features/home/presentation/cubit/product_cubit.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Fetch Products injections
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

  // Cart injections
  locator.registerFactory(() => CartCubit(
        locator<GetCart>(),
        locator<AddOrder>(),
        locator<DeleteOrder>(),
        locator<ClearCart>(),
        locator<Checkout>(),
      ));

  locator.registerLazySingleton(() => GetCart(locator()));
  locator.registerLazySingleton(() => AddOrder(locator()));
  locator.registerLazySingleton(() => DeleteOrder(locator()));
  locator.registerLazySingleton(() => ClearCart(locator()));
  locator.registerLazySingleton(() => Checkout(locator()));

  locator.registerLazySingleton<CartRepo>(() => CartRepoImpl(locator()));

  locator.registerLazySingleton<OrderDataSource>(
      () => OrderDataSourceImpl(locator()));

  locator.registerFactory(() => LocalCubit(
        locator<GetLocal>(),
        locator<ChangeLocal>(),
        locator<GetConvertedValue>(),
      ));

  locator.registerLazySingleton(() => GetLocal(locator()));
  locator.registerLazySingleton(() => ChangeLocal(locator()));
  locator.registerLazySingleton(() => GetConvertedValue(locator()));

  locator.registerLazySingleton<LocalRepo>(() => LocalRepoImpl(
        locator<LocalData>(),
        locator<RemoteData>(),
      ));

  locator.registerLazySingleton(() => LocalData());
  locator.registerLazySingleton(() => RemoteData());

  locator.registerFactory(() => AuthCubit(
        locator<Login>(),
        locator<Logout>(),
        locator<GetCurrentUser>(),
        locator<Register>(),
      ));

  locator.registerLazySingleton(() => Login(locator()));
  locator.registerLazySingleton(() => Logout(locator()));
  locator.registerLazySingleton(() => GetCurrentUser(locator()));
  locator.registerLazySingleton(() => Register(locator()));

  locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(locator()));
  locator.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl());
}
