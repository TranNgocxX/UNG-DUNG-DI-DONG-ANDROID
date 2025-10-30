// import '../entities/booking_entity.dart';
// import '../repositories/booking_repository.dart';

// class CreateBookingUseCase {
//   final BookingRepository repository;

//   CreateBookingUseCase(this.repository);

//   Future<void> call(BookingEntity booking) => repository.createBooking(booking);
// }

import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;
  CreateBooking(this.repository);

  Future<void> call(Booking booking) async {
    return await repository.createBooking(booking);
  }
}
