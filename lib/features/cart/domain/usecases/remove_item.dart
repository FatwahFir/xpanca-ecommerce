import 'package:equatable/equatable.dart';
import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';

class RemoveItem extends UsecaseWithParams<void, RemoveItemParams> {
  final CartRepository _repository;
  const RemoveItem(this._repository);

  @override
  ResultVoid call(RemoveItemParams params) =>
      _repository.remove(params.productId);
}

class RemoveItemParams extends Equatable {
  final int productId;
  const RemoveItemParams(this.productId);

  @override
  List<Object?> get props => [productId];
}
