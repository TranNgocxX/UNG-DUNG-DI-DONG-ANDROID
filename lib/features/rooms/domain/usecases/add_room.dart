import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class AddRoom {
  final RoomRepository repository;
  AddRoom(this.repository);

  Future<void> call(Room room) => repository.addRoom(room);
}
