import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_firebase_data_source.dart';

class RoomRepositoryImpl extends RoomRepository {
  final RoomFirebaseDataSource dataSource;

  RoomRepositoryImpl(this.dataSource);

  @override
  Future<List<RoomEntity>> getRooms() => dataSource.getRooms();

  @override
  Future<List<RoomEntity>> filterRooms({
    String? type,
    double? minPrice,
    double? maxPrice,
    bool? available,
  }) => dataSource.filterRooms(
        type: type,
        minPrice: minPrice,
        maxPrice: maxPrice,
        available: available,
      );
}
