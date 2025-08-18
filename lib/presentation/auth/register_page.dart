import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtimetracker/logic/auth/auth_event.dart';

import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';
import '../home/home_page.dart';
import 'login_page.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),

      body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // الانتقال إلى HomePage بعد تسجيل الدخول
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomePage(userId: state.userId),
                ),
              );
            }
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
                TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(RegisterRequested(
                      emailController.text,
                      passwordController.text,
                    ));
                  },
                  child: Text("Register"),
                ),
              ],
            ),
        );}
      ),
    );
  }
}
