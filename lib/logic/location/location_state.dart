import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoadInProgress extends LocationState {}

class LocationLoadSuccess extends LocationState {

  final double latitude;
  final double longitude;

  LocationLoadSuccess(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}

class LocationLoadFailure extends LocationState {
  final String error;

  LocationLoadFailure(this.error);

  @override
  List<Object?> get props => [error];
}
