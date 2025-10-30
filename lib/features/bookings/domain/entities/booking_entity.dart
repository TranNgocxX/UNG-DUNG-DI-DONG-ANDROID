class Booking {
  final String id;
  final String userId;
  final String roomId;
  final String roomType;
  final String roomNumber;
  final double price;
  final String name;
  final String phone;
  final String payment;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.roomId,
    required this.roomType,
    required this.roomNumber,
    required this.price,
    required this.name,
    required this.phone,
    required this.payment,
    required this.createdAt,
  });
}
