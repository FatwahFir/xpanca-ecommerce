import 'package:equatable/equatable.dart';
import 'package:xpanca_ecommerce/features/products/domain/entities/page_info.dart';

class Paged<T> extends Equatable {
  final List<T> items;
  final PageInfo pageInfo;
  const Paged({required this.items, required this.pageInfo});

  @override
  List<Object?> get props => [items, pageInfo];
}
