
import 'package:flutter/material.dart';
import '../../domain/entities/booking_entity.dart'; 

class BookingCard extends StatelessWidget {
  final Booking booking; 
  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${booking.createdAt.day}/${booking.createdAt.month}/${booking.createdAt.year}';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(
          Icons.hotel,
          color: Color.fromARGB(255, 221, 160, 232),
          size: 36,
        ),
        title: Text('Phòng ${booking.roomNumber} - ${booking.roomType}'),
        subtitle: Text(
          'Giá: ${booking.price.toStringAsFixed(0)} VNĐ/đêm\nNgày đặt: $dateStr\nThanh toán: ${booking.payment}',
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
