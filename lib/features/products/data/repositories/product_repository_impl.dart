import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:xpanca_ecommerce/core/errors/failures.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/products/data/datasources/product_remote_datasource.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/page_info.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/paged.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/product.dart';
import 'package:xpanca_ecommerce/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource _datasource;
  ProductRepositoryImpl(this._datasource);

  @override
  ResultFuture<Paged<Product>> getProducts({
    int page = 1,
    int size = 10,
    String? search,
    String? sort,
  }) async {
    try {
      final res = await _datasource.getProducts(
        page: page,
        size: size,
        q: search,
        sort: sort,
      );

      final models = res.data ?? const [];
      final items = models.map((e) => e.toEntity()).toList();

      final p = res.pagination;
      final pageInfo = PageInfo(
        page: p?.page ?? page,
        pageSize: p?.pageSize ?? size,
        total: p?.total ?? items.length,
        totalPages: p?.totalPages ?? (items.isEmpty ? 1 : 1),
      );

      return Right(Paged<Product>(items: items, pageInfo: pageInfo));
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    }
  }

  @override
  ResultFuture<Product> getProductDetail(int id) async {
    try {
      final res = await _datasource.getProduct(id);
      if (res.data == null) {
        return const Left(ServerFailure(
          message: 'Product not found',
          statusCode: 404,
        ));
      }
      return Right(res.data!.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(
          message: e.message ?? 'error',
          statusCode: e.response?.statusCode ?? 500));
    }
  }
}
