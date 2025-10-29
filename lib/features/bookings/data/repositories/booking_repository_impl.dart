import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_firebase_data_source.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl extends BookingRepository {
  final BookingFirebaseDataSource dataSource;

  BookingRepositoryImpl(this.dataSource);

  @override
  Future<void> createBooking(BookingEntity booking) {
    final model = BookingModel(
      id: booking.id,
      roomId: booking.roomId,
      userId: booking.userId,
      checkInDate: booking.checkInDate,
      checkOutDate: booking.checkOutDate,
      note: booking.note,
      roomName: booking.roomName,
      price: booking.price,
    );
    return dataSource.createBooking(model);
  }

  @override
  Future<void> cancelBooking(String bookingId) =>
      dataSource.cancelBooking(bookingId);

  @override
  Future<List<BookingEntity>> getMyBookings(String userId) =>
      dataSource.getMyBookings(userId);
}
