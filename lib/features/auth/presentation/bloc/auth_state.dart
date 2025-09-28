part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final bool loading;
  final bool authenticated;
  final String? token;
  final String? error;
  final User? user;

  const AuthState._({
    this.loading = false,
    this.authenticated = false,
    this.token,
    this.error,
    this.user,
  });

  const AuthState.unknown() : this._();
  const AuthState.loading() : this._(loading: true);
  const AuthState.unauthenticated()
      : this._(authenticated: false, user: null, token: null);
  const AuthState.authenticated(String token, User user)
      : this._(token: token, user: user, authenticated: true);
  const AuthState.failure(String msg) : this._(error: msg);

  bool get isAuthenticated => token != null && user != null;

  @override
  List<Object?> get props => [loading, authenticated, token, error, user];
}
