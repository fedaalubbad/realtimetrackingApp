import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_event.dart';
import '../../logic/auth/auth_state.dart';
import '../../logic/location/location_bloc.dart';
import '../../logic/location/location_event.dart';
import '../../logic/location/location_state.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({required this.userId, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    // ابدأ تتبع الموقع
    context.read<LocationBloc>().add(StartTracking());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutRequested());
              },
            ),
          ],
        ),
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LocationLoadSuccess) {
              final LatLng currentPosition = LatLng(
                state.latitude,
                state.longitude,
              );

              return GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  _mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: currentPosition, zoom: 15),
                    ),
                  );
                },
                initialCameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("me"),
                    position: currentPosition,
                    infoWindow: const InfoWindow(title: "You are here"),
                  ),
                },
              );
            } else if (state is LocationLoadFailure) {
              return Center(child: Text("Error: ${state.error}"));
            }

            return const Center(child: Text("Loading location..."));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
