import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth.dart';

abstract class AuthRepository {
  Future<Either<Failure, Auth>> loginWithUsernamePassword(
      String username, String password);
}
