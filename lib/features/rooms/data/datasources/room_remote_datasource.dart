import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

class RoomRemoteDataSource {
  final FirebaseFirestore firestore;

  RoomRemoteDataSource(this.firestore);

  Stream<List<RoomModel>> getRoomsStream() {
    return firestore.collection('rooms').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => RoomModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addRoom(RoomModel room) async {
    await firestore.collection('rooms').add(room.toMap());
  }

  Future<void> updateRoom(RoomModel room) async {
    await firestore.collection('rooms').doc(room.id).update(room.toMap());
  }

  Future<void> deleteRoom(String id) async {
    await firestore.collection('rooms').doc(id).delete();
  }
}
