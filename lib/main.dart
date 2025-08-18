import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtimetracker/presentation/splash/splash_page.dart';
import 'data/repositories/location_repository.dart';
import 'firebase_options.dart';
import 'logic/auth/auth_event.dart';
import 'logic/location/location_bloc.dart';
import 'logic/location/location_event.dart';
import 'logic/auth/auth_bloc.dart'; // لازم تكون عندك

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final LocationRepository _locationRepository = LocationRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc()..add(AppStarted()), // عندك AuthBloc
        ),
        BlocProvider(
          create: (_) => LocationBloc(_locationRepository)..add(StartTracking()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashPage(), // ابدأ بالـ SplashPage
      ),
    );
  }
}
