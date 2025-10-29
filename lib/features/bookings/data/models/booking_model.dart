import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.roomId,
    required super.userId,
    required super.checkInDate,
    required super.checkOutDate,
    required super.note,
    required super.roomName,
    required super.price,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      roomId: map['roomId'] ?? '',
      userId: map['userId'] ?? '',
      checkInDate: (map['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (map['checkOutDate'] as Timestamp).toDate(),
      note: map['note'] ?? '',
      roomName: map['roomName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'userId': userId,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'note': note,
      'roomName': roomName,
      'price': price,
    };
  }
}
