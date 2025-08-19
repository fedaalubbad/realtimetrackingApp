import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/models/location_model.dart';
import '../../data/repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;
  StreamSubscription<List<LocationModel>>? _subscription;
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child('locations');

  StreamSubscription<Position>? _positionStream;

  LocationBloc({required this.locationRepository})
      : super(LocationLoadInProgress()) {
    on<StartTracking>(_onStartTracking);
    on<_LocationsUpdated>(_onLocationsUpdated);
  }

  // Future<void> _onStartTracking(
  //     StartTracking event, Emitter<LocationState> emit) async {
  //   emit(LocationLoadInProgress());
  //
  //   try {
  //     // إرسال الموقع الأولي لو توفر
  //     if (event.latitude != null && event.longitude != null) {
  //
  //       await locationRepository.updateUserLocation(LocationModel(
  //         userId: event.userId,
  //         latitude: event.latitude!,
  //         longitude: event.longitude!,
  //       ));
  //     }
  //
  //     // الاستماع لمواقع جميع المستخدمين
  //     _subscription?.cancel();
  //     _subscription = locationRepository.getAllUsersLocations().listen((locations) {
  //       add(_LocationsUpdated(locations));
  //     });
  //   } catch (e) {
  //     emit(LocationLoadFailure(error: e.toString()));
  //   }
  // }
  Future<void> _onStartTracking(
      StartTracking event, Emitter<LocationState> emit) async {
    emit(LocationLoadInProgress());

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(LocationLoadFailure(error:"Location services are disabled"));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(LocationLoadFailure(error:"Location permissions are denied"));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(LocationLoadFailure(error:"Location permissions are permanently denied"));
      return;
    }

    _positionStream =
        Geolocator.getPositionStream(locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        )).listen((Position position) async {
          // emit(LocationLoadSuccess(
          //   latitude: position.latitude,
          //   longitude: position.longitude,
          // ));

          // ✅ تحديث الموقع بالـ Realtime Database
          await _db.child(event.userId).update({
            "latitude": position.latitude,
            "longitude": position.longitude,
            "lastUpdated": DateTime.now().millisecondsSinceEpoch,
          });
              // الاستماع لمواقع جميع المستخدمين
              _subscription?.cancel();
              _subscription = locationRepository.getAllUsersLocations().listen((locations) {
                add(_LocationsUpdated(locations));
              });

        });
  }
  void _onLocationsUpdated(
      _LocationsUpdated event, Emitter<LocationState> emit) {
    emit(LocationLoadSuccess(locations: event.locations));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// Event داخلي للتحديث
class _LocationsUpdated extends LocationEvent {
  final List<LocationModel> locations;
  _LocationsUpdated(this.locations);

  @override
  List<Object?> get props => [locations];
}
