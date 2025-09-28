import 'package:dio/dio.dart';
import 'package:xpanca_ecommerce/core/errors/exceptions.dart';
import 'package:xpanca_ecommerce/core/utils/api_envelope.dart';
import 'package:retrofit/retrofit.dart';
import '../models/auth_model.dart';
part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;
  @POST('/auth/login')
  Future<ApiEnvelope<AuthPayloadModel>> login(
      @Body() Map<String, dynamic> body);
}

abstract class AuthRemoteDatasource {
  Future<ApiEnvelope<AuthPayloadModel>> loginWithUsernamePassword(
      String username, String password);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final AuthApi _api;
  final Dio _dio;
  AuthRemoteDatasourceImpl(this._api, this._dio);

  @override
  Future<ApiEnvelope<AuthPayloadModel>> loginWithUsernamePassword(
      String username, String password) async {
    try {
      final res = await _api.login({
        'username': username,
        'password': password,
      });
      _dio.options.headers['Authorization'] = 'Bearer ${res.data?.token}';
      _dio.options.headers['Accept'] = 'application/json';
      return res;
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message']?.toString() ?? 'Terjadi kesalahan.')
          : 'Terjadi kesalahan.';
      throw ServerException(
          message: msg, statusCode: e.response?.statusCode ?? 500);
    }
  }
}
