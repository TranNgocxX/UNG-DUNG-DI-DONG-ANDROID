import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> createBooking(BookingEntity booking);
  Future<void> cancelBooking(String bookingId);
  Future<List<BookingEntity>> getMyBookings(String userId);
}
