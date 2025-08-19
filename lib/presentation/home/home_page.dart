import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realtimetracker/data/models/user_model.dart';
import '../../data/models/location_model.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_event.dart';
import '../../logic/auth/auth_state.dart';
import '../../logic/location/location_bloc.dart';
import '../../logic/location/location_event.dart';
import '../../logic/location/location_state.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({required this.userId, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
   LocationModel? _currentUser;

  @override
  void initState() {
    super.initState();

    context.read<LocationBloc>().add(StartTracking(userId: widget.userId));

  }
  void _updateMarkers(List<LocationModel> locations) {
    _markers.clear();
    for (var loc in locations) {
      _markers.add(
        Marker(
          markerId: MarkerId(loc.userId),
          position: LatLng(loc.latitude, loc.longitude),
          infoWindow: InfoWindow(
            title: loc.userId == widget.userId ? "You" : loc.userId,
          ),
          icon: loc.userId == widget.userId
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)
              : BitmapDescriptor.defaultMarker,
        ),
      );
    }
    print("markers${_markers.length}");

    // حدّث الكاميرا لموقع المستخدم الحالي
    _currentUser = locations.firstWhere(
          (loc) => loc.userId == widget.userId,
      orElse: () => locations.first,
    );
    // أول ما يدخل المستخدم نرسل حدث لبدء التتبع

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_currentUser!.latitude, _currentUser!.longitude), zoom: 14),
      ),
    );

    // setState(() {});
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
          title: const Text("Home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
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
              _updateMarkers(state.locations); // تحديث الماركرز

              return GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (state.locations.isNotEmpty) {
                            _mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(_currentUser!.latitude, _currentUser!.longitude),
                          zoom: 14,
                        ),
                      ),
                    );
                  }
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 2,
                ),
                markers: _markers,
                // markers: state.locations.map((loc) {
                //   return Marker(
                //     markerId: MarkerId(loc.userId),
                //     position: LatLng(loc.latitude, loc.longitude),
                //     infoWindow: InfoWindow(
                //       title: loc.userId == widget.userId
                //           ? "Me"
                //           : "User: ${loc.userId}",
                //     ),
                //     icon: loc.userId == widget.userId
                //         ? BitmapDescriptor.defaultMarkerWithHue(
                //       BitmapDescriptor.hueAzure,
                //     )
                //         : BitmapDescriptor.defaultMarker,
                //   );
                // }).toSet(),
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
    // _mapController?.dispose();
    super.dispose();
  }
}
