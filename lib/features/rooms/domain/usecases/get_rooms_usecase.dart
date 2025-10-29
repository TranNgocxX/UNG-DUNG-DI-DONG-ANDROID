import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class GetRoomsUseCase {
  final RoomRepository repository;
  GetRoomsUseCase(this.repository);

  Future<List<RoomEntity>> call() => repository.getRooms();
}
