import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/paged.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  ResultFuture<Paged<Product>> getProducts({
    int page,
    int size,
    String? search,
    String? sort,
  });
  ResultFuture<Product> getProductDetail(int id);
}
