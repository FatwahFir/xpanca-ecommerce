import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  final int id;
  final String url;
  final bool isThumbnail;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductImage({
    required this.id,
    required this.url,
    required this.isThumbnail,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, url, isThumbnail, createdAt, updatedAt];
}
