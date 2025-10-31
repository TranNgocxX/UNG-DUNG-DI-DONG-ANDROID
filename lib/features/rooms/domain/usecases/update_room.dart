import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class UpdateRoom {
  final RoomRepository repository;
  UpdateRoom(this.repository);

  Future<void> call(Room room) => repository.updateRoom(room);
}
