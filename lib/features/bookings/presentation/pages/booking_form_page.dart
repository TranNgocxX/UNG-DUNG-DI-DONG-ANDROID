import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/booking_entity.dart';
import '../providers/bookings_provider.dart';

class BookingFormPage extends ConsumerStatefulWidget {
  final String roomId;
  final String roomName;
  final double price;

  const BookingFormPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.price,
  });

  @override
  ConsumerState<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends ConsumerState<BookingFormPage> {
  DateTime? checkIn;
  DateTime? checkOut;
  final noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt phòng')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Ngày nhận phòng'),
              subtitle: Text(checkIn?.toString() ?? 'Chưa chọn'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  initialDate: DateTime.now(),
                );
                if (picked != null) setState(() => checkIn = picked);
              },
            ),
            ListTile(
              title: const Text('Ngày trả phòng'),
              subtitle: Text(checkOut?.toString() ?? 'Chưa chọn'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                  initialDate: DateTime.now(),
                );
                if (picked != null) setState(() => checkOut = picked);
              },
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Ghi chú'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null || checkIn == null || checkOut == null) return;

                final booking = BookingEntity(
                  id: '',
                  roomId: widget.roomId,
                  userId: user.uid,
                  checkInDate: checkIn!,
                  checkOutDate: checkOut!,
                  note: noteController.text,
                  roomName: widget.roomName,
                  price: widget.price,
                );

                await ref.read(bookingsProvider.notifier).addBooking(booking);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đặt phòng thành công!')),
                  );
                }
              },
              child: const Text('Xác nhận đặt phòng'),
            ),
          ],
        ),
      ),
    );
  }
}
