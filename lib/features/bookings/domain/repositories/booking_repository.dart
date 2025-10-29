import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> createBooking(Booking booking);
  Stream<List<Booking>> getBookingsByUserStream(String userId);
}
