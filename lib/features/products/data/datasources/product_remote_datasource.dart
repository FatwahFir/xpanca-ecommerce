import 'package:xpanca_ecommerce/core/utils/api_envelope.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/product_model.dart';
part 'product_remote_datasource.g.dart';

@RestApi()
abstract class ProductRemoteDatasource {
  factory ProductRemoteDatasource(Dio dio, {String baseUrl}) =
      _ProductRemoteDatasource;

  @GET('/products')
  Future<ApiEnvelope<List<ProductModel>>> getProducts({
    @Query('page') int page = 1,
    @Query('page_size') int size = 10,
    @Query('search') String? q,
    @Query('sort') String? sort,
  });

  @GET('/products/{id}')
  Future<ApiEnvelope<ProductModel>> getProduct(@Path('id') int id);
}
