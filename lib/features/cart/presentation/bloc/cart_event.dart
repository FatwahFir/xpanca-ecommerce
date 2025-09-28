part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {}

class CartRefreshed extends CartEvent {}

class CartReset extends CartEvent {}

class CartItemAdded extends CartEvent {
  final int productId;
  final int qty;
  CartItemAdded(this.productId, this.qty);
  @override
  List<Object?> get props => [productId, qty];
}

class CartItemRemoved extends CartEvent {
  final int productId;
  CartItemRemoved(this.productId);
  @override
  List<Object?> get props => [productId];
}

class CartQtyChanged extends CartEvent {
  final int productId, qty;
  CartQtyChanged(this.productId, this.qty);
  @override
  List<Object?> get props => [productId, qty];
}
