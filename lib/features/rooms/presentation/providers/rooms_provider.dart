import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/usecases/get_rooms_usecase.dart';
import '../../domain/usecases/filter_rooms_usecase.dart';
import '../../../rooms/data/datasources/room_firebase_data_source.dart';
import '../../../rooms/data/repositories/room_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository Provider
final roomRepositoryProvider = Provider(
  (ref) => RoomRepositoryImpl(RoomFirebaseDataSource(FirebaseFirestore.instance)),
);

/// Usecases Providers
final getRoomsProvider = Provider(
  (ref) => GetRoomsUseCase(ref.read(roomRepositoryProvider)),
);

final filterRoomsProvider = Provider(
  (ref) => FilterRoomsUseCase(ref.read(roomRepositoryProvider)),
);

/// StateNotifier
class RoomsNotifier extends StateNotifier<AsyncValue<List<RoomEntity>>> {
  final GetRoomsUseCase getRooms;
  final FilterRoomsUseCase filterRooms;

  RoomsNotifier(this.getRooms, this.filterRooms) : super(const AsyncValue.loading()) {
    loadRooms();
  }

  Future<void> loadRooms() async {
    try {
      final rooms = await getRooms();
      state = AsyncValue.data(rooms);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> applyFilter({
    String? type,
    double? minPrice,
    double? maxPrice,
    bool? available,
  }) async {
    try {
      state = const AsyncValue.loading();
      final rooms = await filterRooms(
        type: type,
        minPrice: minPrice,
        maxPrice: maxPrice,
        available: available,
      );
      state = AsyncValue.data(rooms);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Global provider
final roomsProvider =
    StateNotifierProvider<RoomsNotifier, AsyncValue<List<RoomEntity>>>((ref) {
  final getRooms = ref.read(getRoomsProvider);
  final filterRooms = ref.read(filterRoomsProvider);
  return RoomsNotifier(getRooms, filterRooms);
});
