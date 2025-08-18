abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}  // حالة جديدة

class AuthAuthenticated extends AuthState {
  final String userId;
  AuthAuthenticated(this.userId);
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
