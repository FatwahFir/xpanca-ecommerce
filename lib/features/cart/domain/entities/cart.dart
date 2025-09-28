import 'package:equatable/equatable.dart';
import 'package:xpanca_ecommerce/features/cart/domain/entities/cart_item.dart';

class Cart extends Equatable {
  final List<CartItem> items;
  final int subtotal;
  final int count;

  const Cart(
      {required this.items, required this.subtotal, required this.count});

  @override
  List<Object?> get props => [items, subtotal, count];
}
