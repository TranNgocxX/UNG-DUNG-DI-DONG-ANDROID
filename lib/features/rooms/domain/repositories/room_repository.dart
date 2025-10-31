import '../entities/room_entity.dart';

abstract class RoomRepository {
  Stream<List<Room>> getRoomsStream();
  Future<void> addRoom(Room room);
  Future<void> updateRoom(Room room);
  Future<void> deleteRoom(String id);
}
