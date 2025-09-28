import 'package:json_annotation/json_annotation.dart';

part 'product_image_model.g.dart';

@JsonSerializable()
class ProductImageModel {
  final int id;
  final String url;

  @JsonKey(name: 'is_thumbnail')
  final bool isThumbnail;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ProductImageModel({
    required this.id,
    required this.url,
    required this.isThumbnail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageModelToJson(this);
}
