import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:xpanca_ecommerce/core/utils/api_envelope.dart';
import 'package:xpanca_ecommerce/features/cart/data/models/cart_model.dart';
import 'package:xpanca_ecommerce/features/cart/data/request/cart_item_request.dart';

part 'cart_remote_datasource.g.dart';

@RestApi()
abstract class CartRemoteDatasource {
  factory CartRemoteDatasource(Dio dio, {String baseUrl}) =
      _CartRemoteDatasource;

  @GET('/cart')
  Future<ApiEnvelope<CartModel>> getCart();

  @POST('/cart/add')
  Future<ApiEnvelope<MessageModel>> add(@Body() CartItemRequest body);

  @POST('/cart/{pid}/inc')
  Future<ApiEnvelope<MessageModel>> inc(@Path('pid') int productId);

  @POST('/cart/{pid}/dec')
  Future<ApiEnvelope<MessageModel>> dec(@Path('pid') int productId);

  @DELETE('/cart/{pid}')
  Future<ApiEnvelope<MessageModel>> remove(@Path('pid') int productId);
}
