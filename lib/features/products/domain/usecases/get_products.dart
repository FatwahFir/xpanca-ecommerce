import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/paged.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/product.dart';
import 'package:xpanca_ecommerce/features/products/domain/repositories/product_repository.dart';

class GetProductsParams {
  final int page, size;
  final String? search;
  final String? sort;
  const GetProductsParams(
      {this.page = 1, this.size = 10, this.search, this.sort});
}

class GetProducts extends UsecaseWithParams<Paged<Product>, GetProductsParams> {
  final ProductRepository repo;
  GetProducts(this.repo);
  @override
  ResultFuture<Paged<Product>> call(GetProductsParams params) =>
      repo.getProducts(
        page: params.page,
        size: params.size,
        search: params.search,
        sort: params.sort,
      );
}
