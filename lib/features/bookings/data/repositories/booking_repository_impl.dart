import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createBooking(Booking booking) async {
    final bookingModel = BookingModel(
      id: booking.id,
      userId: booking.userId,
      roomId: booking.roomId,
      roomType: booking.roomType,
      roomNumber: booking.roomNumber,
      price: booking.price,
      name: booking.name,
      phone: booking.phone,
      payment: booking.payment,
      createdAt: booking.createdAt,
    );

    await remoteDataSource.createBooking(bookingModel);
  }

  @override
  Stream<List<Booking>> getBookingsByUserStream(String userId) {
    return remoteDataSource.getBookingsByUserStream(userId);
  }
}
