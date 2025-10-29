import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/bookings_provider.dart';

class MyBookingsPage extends ConsumerWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Vui lòng đăng nhập')));
    }

    final bookingsState = ref.watch(bookingsProvider);

    ref.read(bookingsProvider.notifier).loadMyBookings(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Phòng đã đặt')),
      body: bookingsState.when(
        data: (bookings) => ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final b = bookings[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(b.roomName),
                subtitle: Text(
                    'Nhận: ${b.checkInDate.toString().split(" ")[0]}  -  Trả: ${b.checkOutDate.toString().split(" ")[0]}'),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () async {
                    await ref
                        .read(bookingsProvider.notifier)
                        .removeBooking(b.id, user.uid);
                  },
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Lỗi: $e')),
      ),
    );
  }
}
