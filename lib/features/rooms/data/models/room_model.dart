import '../../domain/entities/room_entity.dart';

class RoomModel extends Room {
  RoomModel({
    required super.id,
    required super.soPhong,
    required super.tang,
    required super.loaiPhong,
    required super.giaDem,
    required super.tinhTrang,
    required super.anhPhong,
    required super.moTa,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map, String docId) {
    return RoomModel(
      id: docId,
      soPhong: map['soPhong'],
      tang: map['tang'],
      loaiPhong: map['loaiPhong'],
      giaDem: (map['giaDem'] ?? 0).toDouble(),
      tinhTrang: map['tinhTrang'],
      anhPhong: map['anhPhong'],
      moTa: map['moTa'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'soPhong': soPhong,
      'tang': tang,
      'loaiPhong': loaiPhong,
      'giaDem': giaDem,
      'tinhTrang': tinhTrang,
      'anhPhong': anhPhong,
      'moTa': moTa,
    };
  }
}
