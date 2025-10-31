import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ngoctran/core/presentation/widget/app_drawer.dart';
import 'package:ngoctran/features/bookings/domain/usecases/get_bookings_by_user_stream.dart';
import 'package:ngoctran/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:ngoctran/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:ngoctran/features/bookings/domain/entities/booking_entity.dart';
import '../widgets/booking_card.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  late final GetBookingsByUserStream _getBookingsByUserStream;

  @override
  void initState() {
    super.initState();
    final repository = BookingRepositoryImpl(BookingRemoteDataSource());
    _getBookingsByUserStream = GetBookingsByUserStream(repository);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Vui lòng đăng nhập để xem đặt phòng')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phòng đã đặt'),
        backgroundColor: const Color(0xFFBDCFFF),
        centerTitle: true,
      ),
      drawer: AppDrawer(user: user),
      body: StreamBuilder<List<Booking>>(
        stream: _getBookingsByUserStream.call(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data ?? [];
          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                '📭 Bạn chưa đặt phòng nào!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder( // Hiển thị danh sách đặt phòng
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return BookingCard(booking: booking);
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../data/models/booking_model.dart';
// import '../widgets/booking_card.dart';
// import 'package:ngoctran/core/presentation/widget/app_drawer.dart';

// class MyBookingsPage extends StatelessWidget {
//   const MyBookingsPage({super.key});

//   Stream<List<BookingModel>> _bookingsStream() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return const Stream.empty();

//     return FirebaseFirestore.instance
//         .collection('bookings')
//         .where('userId', isEqualTo: user.uid)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
//               .toList(),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Phòng đã đặt'),
//         //backgroundColor: const Color.fromARGB(255, 173, 107, 184),
//         backgroundColor: const Color(0xFFBDCFFF),
//         centerTitle: true,
//       ),
//       drawer: AppDrawer(user: user),
//       body: StreamBuilder<List<BookingModel>>(
//         stream: _bookingsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final bookings = snapshot.data ?? [];
//           if (bookings.isEmpty) {
//             return const Center(
//               child: Text(
//                 '📭 Bạn chưa đặt phòng nào!',
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               return BookingCard(booking: bookings[index]);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
