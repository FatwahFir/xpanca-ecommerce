import 'package:equatable/equatable.dart';
import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';

class AddToCart extends UsecaseWithParams<void, AddToCartParams> {
  final CartRepository _repository;
  const AddToCart(this._repository);

  @override
  ResultVoid call(AddToCartParams params) =>
      _repository.add(params.productId, params.qty);
}

class AddToCartParams extends Equatable {
  final int productId;
  final int qty;
  const AddToCartParams({required this.productId, required this.qty});

  @override
  List<Object?> get props => [productId, qty];
}
