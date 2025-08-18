import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;

  LocationBloc(this.locationRepository) : super(LocationInitial()) {
    on<StartTracking>((event, emit) async {
      emit(LocationLoadInProgress());
      try {
        final position = await locationRepository.getCurrentLocation();
        emit(LocationLoadSuccess(position.latitude, position.longitude));
      } catch (e) {
        emit(LocationLoadFailure(e.toString()));
      }
    });
  }
}
