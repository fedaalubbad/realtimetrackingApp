import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref().child("users");

  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final user = _auth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user.uid));
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        await Future.delayed(Duration(seconds: 2)); // محاكاة عملية تسجيل
        emit(AuthAuthenticated(userCredential.user!.uid));
      } catch (e) {
        emit(AuthFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);

          _dbRef.child(userCredential.user!.uid).set({
            "email": event.email,
            "timestamp": DateTime.now().millisecondsSinceEpoch,
          });

        await Future.delayed(Duration(seconds: 2));
        emit(AuthAuthenticated(userCredential.user!.uid));
      } catch (e) {
        emit(AuthFailure(e.toString()));
        emit(AuthUnauthenticated());
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await _auth.signOut();
      await Future.delayed(Duration(seconds: 1)); // محاكاة تسجيل الخروج
      emit(AuthUnauthenticated());
    });
  }
}
