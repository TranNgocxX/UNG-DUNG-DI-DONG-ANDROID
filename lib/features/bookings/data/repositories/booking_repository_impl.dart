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

  // ⚠️ Chuyển từ Future sang Stream cho đồng nhất với datasource
  Stream<List<Booking>> getBookingsByUserStream(String userId) {
    return remoteDataSource.getBookingsByUserStream(userId);
  }

  // Nếu interface BookingRepository chỉ định dùng Future<List<Booking>>,
  // bạn có thể để trống hoặc comment dòng này:
  // @override
  // Future<List<Booking>> getBookingsByUser(String userId) async => [];
}
