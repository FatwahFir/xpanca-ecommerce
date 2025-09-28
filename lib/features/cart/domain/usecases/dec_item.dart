import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/inc_item.dart';

class DecItem extends UsecaseWithParams<void, ItemIdParams> {
  final CartRepository _repository;
  const DecItem(this._repository);

  @override
  ResultVoid call(ItemIdParams params) => _repository.dec(params.productId);
}
