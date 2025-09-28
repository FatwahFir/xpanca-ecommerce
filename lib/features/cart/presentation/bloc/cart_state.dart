part of 'cart_bloc.dart';

enum CartStatus { idle, loading, success, failure }

class CartItemView extends Equatable {
  final int productId;
  final String name;
  final String category;
  final int price;
  final String thumbnail;
  final int qty;
  final int lineTotal;

  const CartItemView({
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.qty,
    required this.lineTotal,
  });

  factory CartItemView.fromEntity(CartItem e) => CartItemView(
        productId: e.productId,
        name: e.name,
        category: e.category,
        price: e.price,
        thumbnail: e.thumbnail,
        qty: e.qty,
        lineTotal: e.lineTotal,
      );

  factory CartItemView.empty(int productId) => CartItemView(
        productId: productId,
        name: '',
        category: '',
        price: 0,
        thumbnail: '',
        qty: 0,
        lineTotal: 0,
      );

  @override
  List<Object?> get props =>
      [productId, name, category, price, thumbnail, qty, lineTotal];
}

class CartState extends Equatable {
  final CartStatus status;
  final List<CartItemView> items;
  final int subtotal;
  final int count;
  final String? error;

  const CartState({
    required this.status,
    required this.items,
    required this.subtotal,
    required this.count,
    this.error,
  });

  const CartState.initial()
      : status = CartStatus.idle,
        items = const [],
        subtotal = 0,
        count = 0,
        error = null;

  factory CartState.fromCart(Cart c) => CartState(
        status: CartStatus.success,
        items: c.items.map(CartItemView.fromEntity).toList(),
        subtotal: c.subtotal,
        count: c.count,
      );

  CartState copyWith({
    CartStatus? status,
    List<CartItemView>? items,
    int? subtotal,
    int? count,
    String? error,
  }) =>
      CartState(
        status: status ?? this.status,
        items: items ?? this.items,
        subtotal: subtotal ?? this.subtotal,
        count: count ?? this.count,
        error: error,
      );

  @override
  List<Object?> get props => [status, items, subtotal, count, error];
}
