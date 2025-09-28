import 'package:equatable/equatable.dart';

class PageInfo extends Equatable {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  const PageInfo({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [page, pageSize, total, totalPages];
}
