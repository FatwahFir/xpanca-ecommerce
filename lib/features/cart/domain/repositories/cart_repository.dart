import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  ResultFuture<Cart> getCart();
  ResultVoid add(int productId, int qty);
  ResultVoid inc(int productId);
  ResultVoid dec(int productId);
  ResultVoid remove(int productId);

  ResultVoid setQty(
      {required int productId, required int oldQty, required int newQty});
}
