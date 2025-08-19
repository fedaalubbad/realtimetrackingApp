import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// بدء التتبع
class StartTracking extends LocationEvent {
  final String userId;
  final double? latitude;
  final double? longitude;

  StartTracking({
    required this.userId,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [userId, latitude, longitude];

}
