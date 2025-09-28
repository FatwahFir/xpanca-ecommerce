import 'package:json_annotation/json_annotation.dart';
import 'package:xpanca_ecommerce/features/cart/domain/entities/cart_item.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  @JsonKey(name: 'product_id')
  final int productId;
  final String name;
  final String category;
  final int price; // int64 di BE -> int di Dart
  final String? thumbnail;
  final int qty;
  @JsonKey(name: 'line_total')
  final int lineTotal;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    this.thumbnail,
    required this.qty,
    required this.lineTotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItem toEntity() => CartItem(
        productId: productId,
        name: name,
        category: category,
        price: price,
        thumbnail: thumbnail ?? '',
        qty: qty,
        lineTotal: lineTotal,
      );
}
