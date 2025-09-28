import 'package:dio/dio.dart';
import 'package:xpanca_ecommerce/app/di/injector.dart';
import 'package:xpanca_ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart'; // kDebugMode, debugPrint
import 'secure_storage.dart';

class DioClient {
  final Dio dio;
  DioClient._(this.dio);

  static DioClient create(String baseUrl, SecureStorage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          options.extra['startTime'] = DateTime.now();

          if (kDebugMode) {
            debugPrint('→ ${options.method} ${options.uri}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            final start =
                response.requestOptions.extra['startTime'] as DateTime?;
            final ms = start != null
                ? DateTime.now().difference(start).inMilliseconds
                : null;

            debugPrint(
              '← ${response.statusCode} '
              '${response.requestOptions.method} '
              '${response.realUri}'
              '${ms != null ? " (${ms}ms)" : ""}',
            );

            debugPrint('Response data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            final start = e.requestOptions.extra['startTime'] as DateTime?;
            final ms = start != null
                ? DateTime.now().difference(start).inMilliseconds
                : null;

            debugPrint(
              '✕ ${e.response?.statusCode ?? "-"} '
              '${e.requestOptions.method} '
              '${e.requestOptions.uri} '
              '${ms != null ? "(${ms}ms) " : ""}- ${e.message}',
            );
          }
          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            dio.options.headers.remove('Authorization');

            sl<AuthBloc>().add(AuthLogoutRequested());
          }
          handler.next(e);
        },
      ),
    );

    return DioClient._(dio);
  }
}
