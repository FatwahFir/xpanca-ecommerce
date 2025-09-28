part of 'product_detail_bloc.dart';
sealed class ProductDetailEvent extends Equatable { @override List<Object?> get props => []; }
class ProductDetailOpened extends ProductDetailEvent { final int id; ProductDetailOpened(this.id); }
