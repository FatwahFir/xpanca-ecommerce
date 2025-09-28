import 'package:xpanca_ecommerce/features/products/data/models/product_image_model.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/product_image.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final int id;
  final String name;
  final String category;
  final int price;
  final String description;

  final List<ProductImageModel> images;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  Product toEntity() => Product(
        id: id,
        name: name,
        category: category,
        price: price,
        description: description,
        images: images
            .map((img) => ProductImage(
                  id: img.id,
                  url: img.url,
                  isThumbnail: img.isThumbnail,
                  createdAt: img.createdAt,
                  updatedAt: img.updatedAt,
                ))
            .toList(),
      );
}
