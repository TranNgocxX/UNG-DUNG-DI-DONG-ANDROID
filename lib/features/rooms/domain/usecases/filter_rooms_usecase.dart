import '../entities/room_entity.dart';
import '../repositories/room_repository.dart';

class FilterRoomsUseCase {
  final RoomRepository repository;
  FilterRoomsUseCase(this.repository);

  Future<List<RoomEntity>> call({
    String? type,
    double? minPrice,
    double? maxPrice,
    bool? available,
  }) {
    return repository.filterRooms(
      type: type,
      minPrice: minPrice,
      maxPrice: maxPrice,
      available: available,
    );
  }
}
