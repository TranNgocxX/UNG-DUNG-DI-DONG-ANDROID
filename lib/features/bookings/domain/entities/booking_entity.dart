import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final String id;
  final String roomId;
  final String userId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String note;
  final String roomName;
  final double price;

  const BookingEntity({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.note,
    required this.roomName,
    required this.price,
  });

  @override
  List<Object?> get props =>
      [id, roomId, userId, checkInDate, checkOutDate, note, roomName, price];
}
