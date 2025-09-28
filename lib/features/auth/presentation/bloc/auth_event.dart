part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthCheckStatus extends AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  final String username, password;
  AuthLoginRequested(this.username, this.password);
}

final class AuthLogoutRequested extends AuthEvent {}
