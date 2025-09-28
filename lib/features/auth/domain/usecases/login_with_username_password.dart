import 'package:xpanca_ecommerce/core/usecase/usecase.dart';
import 'package:xpanca_ecommerce/core/utils/typedefs.dart';
import 'package:xpanca_ecommerce/features/auth/domain/entities/auth.dart';
import 'package:xpanca_ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LoginWithUsernamePassword extends UsecaseWithParams<Auth, AuthParams> {
  final AuthRepository _repository;
  const LoginWithUsernamePassword(this._repository);
  @override
  ResultFuture<Auth> call(AuthParams params) =>
      _repository.loginWithUsernamePassword(params.username, params.password);
}

class AuthParams extends Equatable {
  final String username;
  final String password;
  const AuthParams({required this.username, required this.password});
  @override
  List<Object?> get props => [username, password];
}
