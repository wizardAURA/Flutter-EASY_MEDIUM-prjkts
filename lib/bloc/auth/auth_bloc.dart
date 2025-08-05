import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    _authSubscription = _authRepository.user.listen((user) {
      if (user != null) {
        add(AuthUserChanged(user));
      } else {
        if (state is! Unauthenticated) {
          add(AuthLogOutRequested());
        }
      }
    });

    on<AuthLogInRequested>(_onLogInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthLogOutRequested>(_onLogOutRequested);
    on<AuthUserChanged>(_onUserChanged);
  }

  Future<void> _onLogInRequested(
    AuthLogInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.logIn(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(Authenticated(user.uid));
      } else {
        emit(AuthError('Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(Authenticated(user.uid));
      } else {
        emit(AuthError('Sign up failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogOutRequested(
    AuthLogOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authRepository.logOut();
    emit(Unauthenticated());
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    emit(Authenticated(event.user.uid));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
