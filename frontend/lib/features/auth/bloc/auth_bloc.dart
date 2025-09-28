import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../repositories/auth_repository.dart';
import '../models/user.dart';
import '../models/auth_response.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterRequested(this.name, this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String token;
  final User user;
  AuthAuthenticated(this.token, this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repo;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const _tokenKey = 'jwt_token';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  AuthBloc(this._repo) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogout);
    on<CheckAuthStatus>(_onCheckAuth);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final AuthResponse res = await _repo.login(event.email, event.password);

      await _storage.write(key: _tokenKey, value: res.token);
      await _storage.write(key: _userNameKey, value: res.user.name);
      await _storage.write(key: _userEmailKey, value: res.user.email);

      emit(AuthAuthenticated(res.token, res.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final AuthResponse res =
          await _repo.register(event.name, event.email, event.password);

      await _storage.write(key: _tokenKey, value: res.token);
      await _storage.write(key: _userNameKey, value: res.user.name);
      await _storage.write(key: _userEmailKey, value: res.user.email);

      emit(AuthAuthenticated(res.token, res.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _storage.deleteAll();
    emit(AuthInitial());
  }

  Future<void> _onCheckAuth(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    final token = await _storage.read(key: _tokenKey);
    final name = await _storage.read(key: _userNameKey);
    final email = await _storage.read(key: _userEmailKey);

    if (token != null && name != null && email != null) {
      // NB: user info is beperkt, we gebruiken alleen naam/email hier
      final user = User(
        id: 0, // geen id bij bootstrap, tenzij backend endpoint voor /me
        name: name,
        email: email,
        createdAt: DateTime.now(), // dummy, want niet uit storage
      );
      emit(AuthAuthenticated(token, user));
    } else {
      emit(AuthInitial());
    }
  }
}
