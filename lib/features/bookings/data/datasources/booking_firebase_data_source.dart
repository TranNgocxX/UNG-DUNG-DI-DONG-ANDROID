import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingFirebaseDataSource {
  final FirebaseFirestore firestore;

  BookingFirebaseDataSource(this.firestore);

  Future<void> createBooking(BookingModel booking) async {
    await firestore.collection('bookings').add(booking.toMap());
  }

  Future<void> cancelBooking(String bookingId) async {
    await firestore.collection('bookings').doc(bookingId).delete();
  }

  Future<List<BookingModel>> getMyBookings(String userId) async {
    final snapshot = await firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) =>
            BookingModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
