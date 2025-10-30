import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends Booking {
  BookingModel({
    required super.id,
    required super.userId,
    required super.roomId,
    required super.roomType,
    required super.roomNumber,
    required super.price,
    required super.name,
    required super.phone,
    required super.payment,
    required super.createdAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      roomId: map['roomId'] ?? '',
      roomType: map['roomType'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      payment: map['payment'] ?? '',
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roomId': roomId,
      'roomType': roomType,
      'roomNumber': roomNumber,
      'price': price,
      'name': name,
      'phone': phone,
      'payment': payment,
      'createdAt': FieldValue.serverTimestamp(), // Đảm bảo đúng kiểu
    };
  }
}

