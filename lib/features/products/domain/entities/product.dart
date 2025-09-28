import 'package:equatable/equatable.dart';
import 'product_image.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String category;
  final int price;
  final String description;
  final List<ProductImage> images; // ← semua gambar untuk detail

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.images,
  });

  String get thumbnailUrl {
    final thumb =
        images.where((e) => e.isThumbnail).cast<ProductImage?>().firstOrNull;
    if (thumb != null) return thumb.url;
    if (images.isNotEmpty) return images.first.url;
    return '';
  }

  @override
  List<Object?> get props => [id, name, category, price, description, images];
}

extension _IterableX<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
