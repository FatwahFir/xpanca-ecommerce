import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProducts _usecase;
  ProductListBloc(this._usecase) : super(const ProductListState()) {
    on<ProductListFetched>((e, emit) async {
      emit(state.copyWith(
        loading: true,
        error: null,
        page: 1,
        hasMore: true,
        search: e.search ?? state.search,
        sort: e.sort ?? state.sort,
      ));

      final res = await _usecase(GetProductsParams(
        page: 1,
        size: state.size,
        search: e.search ?? state.search,
        sort: e.sort ?? state.sort,
      ));

      res.fold(
        (l) => emit(state.copyWith(
          loading: false,
          error: l.message,
          items: const [],
          page: 1,
          total: 0,
          hasMore: true,
        )),
        (paged) {
          final items = paged.items;
          final total = paged.pageInfo.total;
          emit(state.copyWith(
            loading: false,
            items: items,
            page: 1,
            total: total,
            hasMore: items.length < total,
            error: null,
          ));
        },
      );
    });

    on<ProductListLoadMore>((e, emit) async {
      if (state.loadingMore || state.loading || !state.hasMore) return;

      emit(state.copyWith(loadingMore: true, error: null));
      final nextPage = state.page + 1;

      final res = await _usecase(GetProductsParams(
        page: nextPage,
        size: state.size,
        search: state.search,
        sort: state.sort,
      ));

      res.fold(
        (l) => emit(state.copyWith(loadingMore: false, error: l.message)),
        (paged) {
          final merged = [...state.items, ...paged.items];
          final total = paged.pageInfo.total;
          emit(state.copyWith(
            loadingMore: false,
            items: merged,
            page: nextPage,
            total: total,
            hasMore: merged.length < total,
            error: null,
          ));
        },
      );
    });
  }
}
