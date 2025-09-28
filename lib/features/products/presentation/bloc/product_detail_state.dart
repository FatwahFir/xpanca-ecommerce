part of 'product_detail_bloc.dart';
class ProductDetailState extends Equatable {
  final bool loading;
  final Product? product;
  final String? error;
  const ProductDetailState({this.loading=false, this.product, this.error});
  ProductDetailState copyWith({bool? loading, Product? product, String? error}) =>
      ProductDetailState(loading: loading??this.loading, product: product??this.product, error: error);
  @override List<Object?> get props => [loading, product, error];
}
