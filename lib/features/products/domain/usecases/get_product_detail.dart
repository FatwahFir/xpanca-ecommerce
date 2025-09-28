import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/product.dart';
import 'package:xpanca_ecommerce/features/products/domain/repositories/product_repository.dart';

class GetProductDetail extends UsecaseWithParams<Product, int> {
  final ProductRepository repo;
  GetProductDetail(this.repo);
  @override
  ResultFuture<Product> call(int params) => repo.getProductDetail(params);
}
