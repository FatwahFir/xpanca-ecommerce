import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_detail.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetail _usecase;
  ProductDetailBloc(this._usecase):super(const ProductDetailState()){
    on<ProductDetailOpened>((e,emit) async {
      emit(state.copyWith(loading:true));
      final res = await _usecase(e.id);
      res.fold(
        (l)=>emit(state.copyWith(error:l.message, loading:false)),
        (item)=>emit(state.copyWith(product:item, loading:false, error:null)),
      );
    });
  }
}
