import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

class RoomFirebaseDataSource {
  final FirebaseFirestore firestore;

  RoomFirebaseDataSource(this.firestore);

  Future<List<RoomModel>> getRooms() async {
    final snapshot = await firestore.collection('rooms').get();
    return snapshot.docs
        .map((doc) => RoomModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<RoomModel>> filterRooms({
    String? type,
    double? minPrice,
    double? maxPrice,
    bool? available,
  }) async {
    Query<Map<String, dynamic>> query = firestore.collection('rooms');

    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }
    if (minPrice != null) {
      query = query.where('price', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('price', isLessThanOrEqualTo: maxPrice);
    }
    if (available != null) {
      query = query.where('available', isEqualTo: available);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => RoomModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
