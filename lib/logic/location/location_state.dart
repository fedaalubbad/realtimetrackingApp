import 'package:equatable/equatable.dart';
import '../../data/models/location_model.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationLoadInProgress extends LocationState {}

class LocationLoadSuccess extends LocationState {
  final List<LocationModel> locations;

  LocationLoadSuccess({required this.locations});

  @override
  List<Object?> get props => [locations];
}

class LocationLoadFailure extends LocationState {
  final String error;

  LocationLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
