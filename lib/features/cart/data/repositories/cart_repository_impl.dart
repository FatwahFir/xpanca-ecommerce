import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:xpanca_ecommerce/core/errors/failures.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/cart/data/datasource/cart_remote_datasource.dart';
import 'package:xpanca_ecommerce/features/cart/data/request/cart_item_request.dart';

import 'package:xpanca_ecommerce/features/cart/domain/entities/cart.dart';
import 'package:xpanca_ecommerce/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDatasource _datasource;
  CartRepositoryImpl(this._datasource);

  @override
  ResultFuture<Cart> getCart() async {
    try {
      final res = await _datasource.getCart();
      if (res.data == null) {
        return const Left(ServerFailure(
          message: 'Cart not found',
          statusCode: 404,
        ));
      }
      return Right(res.data!.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      print("here");
      print(e);
      return const Left(
          ServerFailure(message: 'Unknown error', statusCode: 500));
    }
  }

  @override
  ResultVoid add(int productId, int qty) async {
    try {
      await _datasource.add(CartItemRequest(productId: productId, qty: qty));
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Unknown error', statusCode: 500));
    }
  }

  @override
  ResultVoid inc(int productId) async {
    try {
      await _datasource.inc(productId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Unknown error', statusCode: 500));
    }
  }

  @override
  ResultVoid dec(int productId) async {
    try {
      await _datasource.dec(productId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Unknown error', statusCode: 500));
    }
  }

  @override
  ResultVoid remove(int productId) async {
    try {
      await _datasource.remove(productId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Unknown error', statusCode: 500));
    }
  }

  @override
  ResultVoid setQty({
    required int productId,
    required int oldQty,
    required int newQty,
  }) async {
    try {
      if (newQty == oldQty) return const Right(null);

      if (newQty > oldQty) {
        final delta = newQty - oldQty;
        await _datasource
            .add(CartItemRequest(productId: productId, qty: delta));
        return const Right(null);
      } else {
        final delta = oldQty - newQty;
        for (var i = 0; i < delta; i++) {
          await _datasource.dec(productId);
        }
        return const Right(null);
      }
    } on DioException catch (e) {
      return Left(ServerFailure(
        message: e.message ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      ));
    } catch (e) {
      return const Left(
          ServerFailure(message: 'Unknown error', statusCode: 500));
    }
  }
}
