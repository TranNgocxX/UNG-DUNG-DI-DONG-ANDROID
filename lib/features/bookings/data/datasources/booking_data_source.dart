import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createBooking(BookingModel booking) async {
    await _firestore.collection('bookings').add(booking.toMap());
  }

  Stream<List<BookingModel>> getBookingsByUserStream(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BookingModel.fromMap(doc.data(), doc.id)).toList());
  }
}
