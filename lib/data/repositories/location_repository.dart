import 'package:firebase_database/firebase_database.dart';
import '../models/location_model.dart';

class LocationRepository {
  final DatabaseReference _db = FirebaseDatabase.instance.ref().child('locations');

  // تحديث موقع المستخدم
  Future<void> updateUserLocation(LocationModel location) async {
    await _db.child(location.userId).set(location.toMap());


  }

  // استمع لمواقع جميع المستخدمين realtime
  Stream<List<LocationModel>> getAllUsersLocations() {
    return _db.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final List<LocationModel> locations = [];
      data.forEach((key, value) {
        locations.add(LocationModel.fromMap(key, Map<String, dynamic>.from(value)));
      });
      return locations;
    });
  }

  void dispose() {
    // إذا كنت بحاجة لإلغاء أي StreamController داخلي (حالياً لا يوجد)
  }
}
