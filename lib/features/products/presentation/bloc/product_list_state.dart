part of 'product_list_bloc.dart';

class ProductListState extends Equatable {
  final bool loading;
  final bool loadingMore;
  final List<Product> items;
  final int page;
  final int size;
  final bool hasMore;
  final int total;
  final String? search;
  final String? sort;
  final String? error;

  const ProductListState({
    this.loading = false,
    this.loadingMore = false,
    this.items = const [],
    this.page = 1,
    this.size = 10,
    this.hasMore = true,
    this.total = 0,
    this.search,
    this.sort,
    this.error,
  });

  ProductListState copyWith({
    bool? loading,
    bool? loadingMore,
    List<Product>? items,
    int? page,
    int? size,
    bool? hasMore,
    int? total,
    String? search,
    String? sort,
    String? error,
  }) {
    return ProductListState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      items: items ?? this.items,
      page: page ?? this.page,
      size: size ?? this.size,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
      search: search ?? this.search,
      sort: sort ?? this.sort,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        loadingMore,
        items,
        page,
        size,
        hasMore,
        total,
        search,
        sort,
        error
      ];
}
