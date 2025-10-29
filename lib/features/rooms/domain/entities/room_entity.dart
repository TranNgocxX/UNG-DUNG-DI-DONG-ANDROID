import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final String id;
  final String name;
  final String type; // Standard, Deluxe, VIP
  final double price;
  final bool available;
  final String imageUrl;
  final String description;

  const RoomEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.available,
    required this.imageUrl,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, type, price, available, imageUrl];
}
