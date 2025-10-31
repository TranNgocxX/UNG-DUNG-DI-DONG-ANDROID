import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;
  CreateBooking(this.repository);

  Future<void> call(Booking booking) async {
    return await repository.createBooking(booking);
  }
}
