import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<List<RoomEntity>> getRooms();
  Future<List<RoomEntity>> filterRooms({
    String? type,
    double? minPrice,
    double? maxPrice,
    bool? available,
  });
}
