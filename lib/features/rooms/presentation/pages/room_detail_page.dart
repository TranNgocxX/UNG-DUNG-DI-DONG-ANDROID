import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoctran/core/routing/app_routes.dart';
import 'package:ngoctran/features/rooms/data/models/room_model.dart';
import 'package:ngoctran/features/rooms/data/datasources/room_remote_datasource.dart';

class RoomDetailPage extends StatelessWidget {
  final RoomModel room;
  final RoomRemoteDataSource roomDataSource =
      RoomRemoteDataSource(FirebaseFirestore.instance);

  RoomDetailPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFBDCFFF);
    const Color accentColor = Colors.purpleAccent;
    const Color backgroundColor = Colors.white;

    const double maxContentWidth = 1200;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isLargeScreen = constraints.maxWidth > maxContentWidth + 100;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Phòng ${room.soPhong}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã thêm vào danh sách yêu thích!'),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          body: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh phòng
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isLargeScreen ? 20 : 0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: isLargeScreen
                                    ? const Radius.circular(15)
                                    : const Radius.circular(30),
                                bottomRight: isLargeScreen
                                    ? const Radius.circular(15)
                                    : const Radius.circular(30),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x10000000),
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: isLargeScreen
                                    ? const Radius.circular(15)
                                    : const Radius.circular(30),
                                bottomRight: isLargeScreen
                                    ? const Radius.circular(15)
                                    : const Radius.circular(30),
                              ),
                              child: Image.network(
                                room.anhPhong,
                                width: double.infinity,
                                height: isLargeScreen ? 350 : 280,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Nội dung chi tiết
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${room.loaiPhong} - Phòng ${room.soPhong}',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.meeting_room_outlined,
                                  color: Colors.blueGrey, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Tầng ${room.tang}',
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            '${room.giaDem.toStringAsFixed(0)} VNĐ / đêm',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                          const SizedBox(height: 25),

                          const Text(
                            'Mô tả chi tiết',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            room.moTa.isNotEmpty
                                ? room.moTa
                                : 'Phòng ${room.loaiPhong} được trang bị đầy đủ tiện nghi, hiện đại và thoải mái cho kỳ nghỉ của bạn.',
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // ✅ Nút ĐẶT PHÒNG — ĐÃ SỬA
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // 👉 Điều hướng đến form đặt phòng
                                context.push(AppRoutes.booking, extra: room);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 6,
                                shadowColor: accentColor.withOpacity(0.4),
                              ),
                              child: const Text(
                                'ĐẶT NGAY',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    // Gợi ý phòng khác
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: const Text(
                        'Có thể bạn sẽ thích ✨',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 210,
                      child: StreamBuilder<List<RoomModel>>(
                        stream: roomDataSource.getRoomsStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('Không có gợi ý nào.'));
                          }

                          final relatedRooms = snapshot.data!
                              .where((r) =>
                                  r.id != room.id &&
                                  r.loaiPhong == room.loaiPhong)
                              .take(5)
                              .toList();

                          if (relatedRooms.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Không có phòng tương tự.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.only(left: 24, right: 10),
                            itemCount: relatedRooms.length,
                            itemBuilder: (context, index) {
                              final other = relatedRooms[index];
                              return Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 18),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(16)),
                                        child: Image.network(
                                          other.anhPhong,
                                          width: double.infinity,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Phòng ${other.soPhong}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${other.giaDem.toStringAsFixed(0)} VNĐ/đêm',
                                              style: const TextStyle(
                                                color: accentColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
