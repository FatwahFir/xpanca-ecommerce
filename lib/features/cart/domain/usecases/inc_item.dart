import 'package:equatable/equatable.dart';
import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';

class IncItem extends UsecaseWithParams<void, ItemIdParams> {
  final CartRepository _repository;
  const IncItem(this._repository);

  @override
  ResultVoid call(ItemIdParams params) => _repository.inc(params.productId);
}

class ItemIdParams extends Equatable {
  final int productId;
  const ItemIdParams(this.productId);
  @override
  List<Object?> get props => [productId];
}
