import 'package:json_annotation/json_annotation.dart';

part 'cart_item_request.g.dart';

@JsonSerializable()
class CartItemRequest {
  @JsonKey(name: 'product_id')
  final int productId;
  final int qty;

  CartItemRequest({required this.productId, required this.qty});

  factory CartItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CartItemRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemRequestToJson(this);
}
