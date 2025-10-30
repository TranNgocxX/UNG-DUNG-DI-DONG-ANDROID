import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> createBooking(Booking booking);
  //Future<List<Booking>> getBookingsByUser(String userId);
  Stream<List<Booking>> getBookingsByUserStream(String userId);
}
