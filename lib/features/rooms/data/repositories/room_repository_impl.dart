import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_remote_datasource.dart';
import '../models/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Room>> getRoomsStream() => remoteDataSource.getRoomsStream();

  @override
  Future<void> addRoom(Room room) async {
    await remoteDataSource.addRoom(RoomModel(
      id: room.id,
      soPhong: room.soPhong,
      tang: room.tang,
      loaiPhong: room.loaiPhong,
      giaDem: room.giaDem,
      tinhTrang: room.tinhTrang,
      anhPhong: room.anhPhong,
      moTa: room.moTa,
    ));
  }

  @override
  Future<void> updateRoom(Room room) async {
    await remoteDataSource.updateRoom(RoomModel(
      id: room.id,
      soPhong: room.soPhong,
      tang: room.tang,
      loaiPhong: room.loaiPhong,
      giaDem: room.giaDem,
      tinhTrang: room.tinhTrang,
      anhPhong: room.anhPhong,
      moTa: room.moTa,
    ));
  }

  @override
  Future<void> deleteRoom(String id) => remoteDataSource.deleteRoom(id);
}
