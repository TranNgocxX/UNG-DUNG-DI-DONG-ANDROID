// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import '../../domain/entities/booking_entity.dart';
// import '../../domain/usecases/create_booking_usecase.dart';
// import '../../domain/usecases/get_my_bookings_usecase.dart';
// import '../../domain/usecases/cancel_booking_usecase.dart';
// import '../../../bookings/data/repositories/booking_repository_impl.dart';
// import '../../data/datasources/booking_remote_datasource.dart';

// /// Repository Provider
// final bookingRepositoryProvider = Provider(
//   (ref) => BookingRepositoryImpl(BookingFirebaseDataSource(FirebaseFirestore.instance)),
// );

// /// UseCases Providers
// final createBookingProvider = Provider(
//   (ref) => CreateBookingUseCase(ref.read(bookingRepositoryProvider)),
// );

// final getMyBookingsProvider = Provider(
//   (ref) => GetMyBookingsUseCase(ref.read(bookingRepositoryProvider)),
// );

// final cancelBookingProvider = Provider(
//   (ref) => CancelBookingUseCase(ref.read(bookingRepositoryProvider)),
// );

// /// StateNotifier
// class BookingsNotifier extends StateNotifier<AsyncValue<List<BookingEntity>>> {
//   final GetMyBookingsUseCase getMyBookings;
//   final CreateBookingUseCase createBooking;
//   final CancelBookingUseCase cancelBooking;

//   BookingsNotifier(this.getMyBookings, this.createBooking, this.cancelBooking)
//       : super(const AsyncValue.loading());

//   Future<void> loadMyBookings(String userId) async {
//     try {
//       final bookings = await getMyBookings(userId);
//       state = AsyncValue.data(bookings);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   Future<void> addBooking(BookingEntity booking) async {
//     await createBooking(booking);
//     await loadMyBookings(booking.userId);
//   }

//   Future<void> removeBooking(String id, String userId) async {
//     await cancelBooking(id);
//     await loadMyBookings(userId);
//   }
// }

// final bookingsProvider =
//     StateNotifierProvider<BookingsNotifier, AsyncValue<List<BookingEntity>>>(
//   (ref) {
//     final getMyBookings = ref.read(getMyBookingsProvider);
//     final createBooking = ref.read(createBookingProvider);
//     final cancelBooking = ref.read(cancelBookingProvider);
//     return BookingsNotifier(getMyBookings, createBooking, cancelBooking);
//   },
// );
