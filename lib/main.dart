import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'logic/auth/auth_bloc.dart';
import 'logic/auth/auth_event.dart';
import 'logic/auth/auth_state.dart';
import 'logic/location/location_bloc.dart';
import 'data/repositories/location_repository.dart';
import 'presentation/auth/login_page.dart';
import 'presentation/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final locationRepository = LocationRepository();

  runApp(MyApp(locationRepository: locationRepository));
}

class MyApp extends StatelessWidget {
  final LocationRepository locationRepository;

  const MyApp({super.key, required this.locationRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc()..add(AppStarted()),
        ),
        BlocProvider<LocationBloc>(
          create: (_) => LocationBloc(locationRepository: locationRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return HomePage(userId: state.userId);
            } else if (state is AuthUnauthenticated) {
              return LoginPage();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
