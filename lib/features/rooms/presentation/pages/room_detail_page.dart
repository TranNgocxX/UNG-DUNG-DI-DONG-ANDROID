import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ngoctran/core/presentation/widget/app_drawer.dart';
import 'package:ngoctran/core/routing/app_routes.dart';
import 'package:ngoctran/features/rooms/domain/entities/room_entity.dart';
import 'package:ngoctran/features/rooms/domain/usecases/get_rooms_stream.dart';
import 'package:ngoctran/features/rooms/data/datasources/room_remote_datasource.dart';
import 'package:ngoctran/features/rooms/data/repositories/room_repository_impl.dart';

class RoomDetailPage extends StatelessWidget {
  final Room room;
  final user = FirebaseAuth.instance.currentUser;
  final GetRoomsStream _getRoomsStream = GetRoomsStream(
    RoomRepositoryImpl(RoomRemoteDataSource(FirebaseFirestore.instance)),
  );

  RoomDetailPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    const accentColor = Colors.purpleAccent;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text('Phòng ${room.soPhong}', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      drawer: AppDrawer(user: user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(room.anhPhong, width: double.infinity, height: 280, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${room.loaiPhong} - Phòng ${room.soPhong}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('Tầng ${room.tang}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text('${room.giaDem.toStringAsFixed(0)} VNĐ / đêm',
                      style: const TextStyle(fontSize: 20, color: accentColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Text(room.moTa, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => context.push(AppRoutes.booking, extra: room),
                    style: ElevatedButton.styleFrom(backgroundColor: accentColor, minimumSize: const Size(double.infinity, 45)),
                    child: const Text('ĐẶT NGAY', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  const SizedBox(height: 40),
                  const Text('Có thể bạn sẽ thích ✨',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 210,
                    child: StreamBuilder<List<Room>>(
                      stream: _getRoomsStream(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final relatedRooms = snapshot.data!
                            .where((r) => r.id != room.id && r.loaiPhong == room.loaiPhong)
                            .take(5)
                            .toList();

                        if (relatedRooms.isEmpty) {
                          return const Center(child: Text('Không có phòng tương tự.'));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: relatedRooms.length,
                          itemBuilder: (context, index) {
                            final other = relatedRooms[index];
                            return GestureDetector(
                              onTap: () => context.push('${AppRoutes.roomDetail}/${other.id}', extra: other),
                              child: Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 18),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                        child: Image.network(other.anhPhong, height: 100, width: double.infinity, fit: BoxFit.cover),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Phòng ${other.soPhong}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Text('${other.giaDem.toStringAsFixed(0)} VNĐ/đêm',
                                                style: const TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
