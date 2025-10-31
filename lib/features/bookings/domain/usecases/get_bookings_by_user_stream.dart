import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingsByUserStream {
  final BookingRepository repository;

  GetBookingsByUserStream(this.repository);

  Stream<List<Booking>> call(String userId) {
    return repository.getBookingsByUserStream(userId);
  }
}
