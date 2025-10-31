import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class GetRoomsStream {
  final RoomRepository repository;
  GetRoomsStream(this.repository);

  Stream<List<Room>> call() => repository.getRoomsStream();
}
