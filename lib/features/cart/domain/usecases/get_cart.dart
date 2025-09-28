import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/domain/entities/cart.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';

class GetCart extends UsecaseWithoutParams<Cart> {
  final CartRepository _repository;
  const GetCart(this._repository);

  @override
  ResultFuture<Cart> call() => _repository.getCart();
}
