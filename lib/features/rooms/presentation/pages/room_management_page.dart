import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ngoctran/features/rooms/data/datasources/room_remote_datasource.dart';
import '../../data/models/room_model.dart';
import '../widgets/room_form.dart';
import 'package:ngoctran/core/presentation/widget/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomManagementPage extends StatefulWidget {
  const RoomManagementPage({super.key});

  @override
  State<RoomManagementPage> createState() => _RoomManagementPageState();
}

class _RoomManagementPageState extends State<RoomManagementPage> {
  late final RoomRemoteDataSource roomDataSource;
  final TextEditingController searchController = TextEditingController();
  String selectedLoaiPhong = 'Tất cả';
  String selectedTinhTrang = 'Tất cả';

  @override
  void initState() {
    super.initState();
    roomDataSource = RoomRemoteDataSource(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Quản lý phòng'),
        backgroundColor: const Color.fromARGB(255, 247, 184, 243),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // --- Thanh tìm kiếm ---
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Tìm theo số phòng...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                // --- Bộ lọc ---
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedLoaiPhong,
                        decoration: InputDecoration(
                          labelText: 'Loại phòng',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                        items:
                            [
                                  'Tất cả',
                                  'Standard',
                                  'Deluxe',
                                  'Suite',
                                  'Presidential',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) =>
                            setState(() => selectedLoaiPhong = val!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedTinhTrang,
                        decoration: InputDecoration(
                          labelText: 'Tình trạng',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                        ),
                        items: ['Tất cả', 'Trống', 'Đã đặt']
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => selectedTinhTrang = val!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: AppDrawer(user: user),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => RoomForm(
            onSubmit: (room) async {
              await roomDataSource.addRoom(
                RoomModel(
                  id: '',
                  soPhong: room.soPhong,
                  tang: room.tang,
                  loaiPhong: room.loaiPhong,
                  giaDem: room.giaDem,
                  tinhTrang: room.tinhTrang,
                  anhPhong: room.anhPhong,
                  moTa: room.moTa,
                ),
              );
            },
          ),
        ),
        label: const Text('Thêm phòng mới'),
        icon: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<RoomModel>>(
          stream: roomDataSource.getRoomsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Chưa có phòng nào.'));
            }

            final rooms = snapshot.data!;
            final total = rooms.length;
            final emptyRooms = rooms
                .where((r) => r.tinhTrang == 'Trống')
                .length;
            final bookedRooms = rooms
                .where((r) => r.tinhTrang == 'Đã đặt')
                .length;

            final searchText = searchController.text.trim();
            final filteredRooms = rooms.where((r) {
              final matchSearch = r.soPhong.contains(searchText);
              final matchLoai =
                  selectedLoaiPhong == 'Tất cả' ||
                  r.loaiPhong == selectedLoaiPhong;
              final matchTinhTrang =
                  selectedTinhTrang == 'Tất cả' ||
                  r.tinhTrang == selectedTinhTrang;
              return matchSearch && matchLoai && matchTinhTrang;
            }).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Thống kê ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Tổng số phòng',
                      '$total',
                      Icons.hotel,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      'Phòng trống',
                      '$emptyRooms',
                      Icons.meeting_room,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'Đã đặt',
                      '$bookedRooms',
                      Icons.event_busy,
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- Danh sách phòng ---
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRooms.length,
                    itemBuilder: (_, i) {
                      final r = filteredRooms[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  r.anhPhong,
                                  width: 130,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Phòng ${r.soPhong} - ${r.loaiPhong}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Giá: ${r.giaDem} VNĐ/đêm',
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text('Tầng: ${r.tang}'),
                                    Text('Trạng thái: ${r.tinhTrang}'),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => RoomForm(
                                        room: r,
                                        onSubmit: (updatedRoom) async {
                                          await roomDataSource.updateRoom(
                                            RoomModel(
                                              id: r.id,
                                              soPhong: updatedRoom.soPhong,
                                              tang: updatedRoom.tang,
                                              loaiPhong: updatedRoom.loaiPhong,
                                              giaDem: updatedRoom.giaDem,
                                              tinhTrang: updatedRoom.tinhTrang,
                                              anhPhong: updatedRoom.anhPhong,
                                              moTa: updatedRoom.moTa,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await roomDataSource.deleteRoom(r.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
