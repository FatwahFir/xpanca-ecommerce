part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductListFetched extends ProductListEvent {
  final String? search;
  final String? sort;
  ProductListFetched({this.search, this.sort});
}

class ProductListLoadMore extends ProductListEvent {}
