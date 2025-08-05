// auth_event.dart

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthLogInRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLogInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLogOutRequested extends AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User user;

  AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user.uid];
}
