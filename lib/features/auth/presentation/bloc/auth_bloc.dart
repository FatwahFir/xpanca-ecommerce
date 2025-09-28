import 'package:xpanca_ecommerce/features/auth/data/models/user_model.dart';
import 'package:xpanca_ecommerce/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/secure_storage.dart';
import '../../domain/usecases/login_with_username_password.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithUsernamePassword loginUsecase;
  final SecureStorage storage;
  AuthBloc(this.loginUsecase, this.storage) : super(const AuthState.unknown()) {
    on<AuthLoginRequested>(_onLogin);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthCheckStatus>(_onCheck);
  }

  Future<void> _onCheck(AuthCheckStatus e, Emitter<AuthState> emit) async {
    final token = await storage.readToken();
    final userModel = await storage.readUser();
    if (token != null && userModel != null) {
      emit(AuthState.authenticated(token, userModel.toEntity()));
    } else {
      await storage.clear();
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogin(AuthLoginRequested e, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    final result = await loginUsecase(
      AuthParams(username: e.username, password: e.password),
    );

    await result.fold<Future<void>>(
      (l) async {
        if (emit.isDone) return;
        emit(AuthState.failure(l.message));
      },
      (auth) async {
        await storage.writeToken(auth.token);
        final userModel = UserModel(
          id: auth.user.id,
          username: auth.user.username,
          role: auth.user.role,
        );
        await storage.writeUser(userModel);

        if (emit.isDone) return;
        emit(AuthState.authenticated(auth.token, auth.user));
      },
    );
  }

  Future<void> _onLogout(AuthLogoutRequested e, Emitter<AuthState> emit) async {
    await storage.clear();
    emit(const AuthState.unauthenticated());
  }
}
