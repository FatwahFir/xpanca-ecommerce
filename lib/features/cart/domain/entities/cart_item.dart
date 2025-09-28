import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String name;
  final String category;
  final int price;
  final String thumbnail;
  final int qty;
  final int lineTotal;

  const CartItem({
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.qty,
    required this.lineTotal,
  });

  CartItem copyWith({
    int? productId,
    String? name,
    String? category,
    int? price,
    String? thumbnail,
    int? qty,
    int? lineTotal,
  }) =>
      CartItem(
        productId: productId ?? this.productId,
        name: name ?? this.name,
        category: category ?? this.category,
        price: price ?? this.price,
        thumbnail: thumbnail ?? this.thumbnail,
        qty: qty ?? this.qty,
        lineTotal: lineTotal ?? this.lineTotal,
      );

  @override
  List<Object?> get props =>
      [productId, name, category, price, thumbnail, qty, lineTotal];
}
