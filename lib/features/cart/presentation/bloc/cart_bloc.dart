import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpanca_ecommerce/core/errors/failures.dart';
import 'package:xpanca_ecommerce/features/cart/domain/entities/cart.dart';
import 'package:xpanca_ecommerce/features/cart/domain/entities/cart_item.dart';

// USECASES
import 'package:xpanca_ecommerce/features/cart/domain/usecases/get_cart.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/add_to_cart.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/remove_item.dart';
import 'package:xpanca_ecommerce/features/cart/domain/usecases/set_qty.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCart _getCart;
  final AddToCart _addToCart;
  final RemoveItem _removeItem;
  final SetQty _setQty;

  CartBloc({
    required GetCart getCart,
    required AddToCart addToCart,
    required RemoveItem removeItem,
    required SetQty setQty,
  })  : _getCart = getCart,
        _addToCart = addToCart,
        _removeItem = removeItem,
        _setQty = setQty,
        super(const CartState.initial()) {
    on<CartStarted>(_onStarted);
    on<CartRefreshed>(_onRefreshed);
    on<CartItemAdded>(_onAdded);
    on<CartItemRemoved>(_onRemoved);
    on<CartQtyChanged>(_onQtyChanged);
    on<CartReset>((e, emit) {
      emit(const CartState.initial());
    });
  }

  CartState _failure(Failure f) =>
      state.copyWith(status: CartStatus.failure, error: f.message);

  Future<void> _load(Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final either = await _getCart();
    either.fold(
      (l) => emit(_failure(l)),
      (cart) => emit(CartState.fromCart(cart)),
    );
  }

  Future<void> _onStarted(CartStarted e, Emitter<CartState> emit) =>
      _load(emit);

  Future<void> _onRefreshed(CartRefreshed e, Emitter<CartState> emit) =>
      _load(emit);

  Future<void> _onAdded(CartItemAdded e, Emitter<CartState> emit) async {
    final either =
        await _addToCart(AddToCartParams(productId: e.productId, qty: e.qty));

    await either.fold(
      (l) async => emit(_failure(l)),
      (_) => _load(emit), // <-- awaited via fold 'await'
    );
  }

  Future<void> _onRemoved(CartItemRemoved e, Emitter<CartState> emit) async {
    final removed = state.items.firstWhere(
      (x) => x.productId == e.productId,
      orElse: () => CartItemView.empty(e.productId),
    );

    final newItems =
        state.items.where((x) => x.productId != e.productId).toList();
    final newSubtotal = state.subtotal - removed.lineTotal;
    final newCount = state.count > 0 ? state.count - 1 : 0;

    emit(state.copyWith(
      items: newItems,
      subtotal: newSubtotal,
      count: newCount,
    ));

    final either = await _removeItem(RemoveItemParams(e.productId));

    await either.fold(
      (l) async {
        emit(_failure(l));
        await _load(emit);
      },
      (_) async {
        await _load(emit);
      },
    );
  }

  Future<void> _onQtyChanged(CartQtyChanged e, Emitter<CartState> emit) async {
    final old = state.items.firstWhere(
      (x) => x.productId == e.productId,
      orElse: () => CartItemView.empty(e.productId),
    );

    final either = await _setQty(SetQtyParams(
      productId: e.productId,
      oldQty: old.qty,
      newQty: e.qty,
    ));

    await either.fold(
      (l) async => emit(_failure(l)),
      (_) => _load(emit),
    );
  }
}
