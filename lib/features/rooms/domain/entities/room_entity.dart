class Room {
  final String id;
  final String soPhong;
  final String tang;
  final String loaiPhong;
  final double giaDem;
  final String tinhTrang; // Trống / Đã đặt
  final String anhPhong;
  final String moTa;

  Room({
    required this.id,
    required this.soPhong,
    required this.tang,
    required this.loaiPhong,
    required this.giaDem,
    required this.tinhTrang,
    required this.anhPhong,
    required this.moTa,
  });
}
