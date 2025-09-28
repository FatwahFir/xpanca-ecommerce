import 'package:xpanca_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:xpanca_ecommerce/features/cart/data/datasource/cart_remote_datasource.dart';
import 'package:xpanca_ecommerce/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/add_to_cart.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/get_cart.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/remove_item.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/set_qty.dart';
import 'package:xpanca_ecommerce/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:xpanca_ecommerce/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:xpanca_ecommerce/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../core/services/dio_client.dart';
import '../../core/services/secure_storage.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_with_username_password.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/get_product_detail.dart';

final sl = GetIt.instance;

Future<void> initDI(String baseUrl) async {
  sl
    ..registerLazySingleton<SecureStorage>(() => SecureStorageImpl())
    ..registerLazySingleton<Dio>(
        () => DioClient.create(baseUrl, sl<SecureStorage>()).dio)
    // ..registerFactory(() => AuthBloc(sl(), sl()))
    ..registerLazySingleton<AuthBloc>(() => AuthBloc(sl(), sl()))
    ..registerLazySingleton(() => LoginWithUsernamePassword(sl()))
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthRemoteDatasource>()))
    ..registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(sl<AuthApi>(), sl<Dio>()))
    ..registerLazySingleton<AuthApi>(() => AuthApi(sl<Dio>()))
    ..registerFactory(() => ProductListBloc(sl()))
    ..registerLazySingleton(() => GetProducts(sl()))
    ..registerFactory(() => ProductDetailBloc(sl()))
    ..registerLazySingleton(() => GetProductDetail(sl()))
    ..registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(sl<ProductRemoteDatasource>()))
    ..registerLazySingleton<ProductRemoteDatasource>(
        () => ProductRemoteDatasource(sl<Dio>()))
    ..registerLazySingleton(() => CartBloc(
          getCart: sl<GetCart>(),
          addToCart: sl<AddToCart>(),
          removeItem: sl<RemoveItem>(),
          setQty: sl<SetQty>(),
        ))
    ..registerLazySingleton(() => GetCart(sl()))
    ..registerLazySingleton(() => AddToCart(sl()))
    ..registerLazySingleton(() => RemoveItem(sl()))
    ..registerLazySingleton(() => SetQty(sl()))
    ..registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()))
    ..registerLazySingleton<CartRemoteDatasource>(
      () => CartRemoteDatasource(
        sl(),
      ),
    );
}
