import 'package:json_annotation/json_annotation.dart';
import 'package:xpanca_ecommerce/features/cart/data/models/cart_item_model.dart';
import 'package:xpanca_ecommerce/features/cart/domain/entities/cart.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  @JsonKey(fromJson: _itemsFromJson, toJson: _itemsToJson)
  final List<CartItemModel> items;

  @JsonKey(defaultValue: 0)
  final int subtotal;

  @JsonKey(defaultValue: 0)
  final int count;

  CartModel({
    required this.items,
    required this.subtotal,
    required this.count,
  });

  static List<CartItemModel> _itemsFromJson(Object? json) {
    if (json is List) {
      return json
          .whereType<Map<String, dynamic>>()
          .map(CartItemModel.fromJson)
          .toList();
    }
    return <CartItemModel>[];
  }

  static Object _itemsToJson(List<CartItemModel> items) =>
      items.map((e) => e.toJson()).toList();

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  Cart toEntity() => Cart(
        items: items.map((e) => e.toEntity()).toList(),
        subtotal: subtotal,
        count: count,
      );
}
