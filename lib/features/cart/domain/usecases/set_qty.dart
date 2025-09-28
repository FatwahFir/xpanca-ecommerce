import 'package:equatable/equatable.dart';
import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';

class SetQty extends UsecaseWithParams<void, SetQtyParams> {
  final CartRepository _repository;
  const SetQty(this._repository);

  @override
  ResultVoid call(SetQtyParams params) => _repository.setQty(
        productId: params.productId,
        oldQty: params.oldQty,
        newQty: params.newQty,
      );
}

class SetQtyParams extends Equatable {
  final int productId;
  final int oldQty;
  final int newQty;
  const SetQtyParams({
    required this.productId,
    required this.oldQty,
    required this.newQty,
  });

  @override
  List<Object?> get props => [productId, oldQty, newQty];
}
