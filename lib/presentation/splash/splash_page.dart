import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';
import '../auth/login_page.dart';
import '../home/home_page.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => HomePage(userId: state.userId)));
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        }
      },
      child: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
