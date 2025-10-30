import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createBooking(Booking booking) async {
    await remoteDataSource.createBooking(booking as BookingModel);
  }

  Stream<List<Booking>> getBookingsByUserStream(String userId) {
    return remoteDataSource.getBookingsByUserStream(userId);
  }

}
