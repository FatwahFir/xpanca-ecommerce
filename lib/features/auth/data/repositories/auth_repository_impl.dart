import 'package:dartz/dartz.dart';
import 'package:xpanca_ecommerce/core/errors/failures.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:xpanca_ecommerce/features/auth/domain/entities/auth.dart';
import 'package:xpanca_ecommerce/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  const AuthRepositoryImpl(this._datasource);

  @override
  ResultFuture<Auth> loginWithUsernamePassword(
      String username, String password) async {
    try {
      final auth =
          await _datasource.loginWithUsernamePassword(username, password);
      return Right(auth.data!.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
