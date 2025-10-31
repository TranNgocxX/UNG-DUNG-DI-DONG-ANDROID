import 'package:flutter/material.dart';
import 'dart:math';
import '../../domain/entities/room_entity.dart';

class RoomForm extends StatefulWidget {
  final Room? room;
  final Function(Room) onSubmit;

  const RoomForm({super.key, this.room, required this.onSubmit});

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController soPhongCtrl;
  late TextEditingController tangCtrl;
  late TextEditingController giaCtrl;
  late TextEditingController anhCtrl;
  late TextEditingController moTaCtrl;
  String loaiPhong = 'Standard';
  String tinhTrang = 'Trống';

  @override
  void initState() {
    super.initState();
    soPhongCtrl = TextEditingController(text: widget.room?.soPhong ?? '');
    tangCtrl = TextEditingController(text: widget.room?.tang ?? '');
    giaCtrl =
        TextEditingController(text: widget.room?.giaDem.toString() ?? '');
    anhCtrl = TextEditingController(text: widget.room?.anhPhong ?? '');
    moTaCtrl = TextEditingController(text: widget.room?.moTa ?? '');
    loaiPhong = widget.room?.loaiPhong ?? 'Standard';
    tinhTrang = widget.room?.tinhTrang ?? 'Trống';
  }

  String _generateId() {
    final random = Random();
    return List.generate(8, (_) => random.nextInt(9)).join();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(30),
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.room == null ? 'Thêm phòng mới' : 'Cập nhật phòng',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Số phòng', soPhongCtrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField('Tầng', tangCtrl)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                       initialValue: loaiPhong,
                        decoration: const InputDecoration(
                            labelText: 'Loại phòng',
                            border: OutlineInputBorder()),
                        items: ['Standard', 'Deluxe', 'Suite', 'Presidential']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => loaiPhong = val!),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildTextField('Giá/đêm (VNĐ)', giaCtrl,
                            isNumber: true)),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: tinhTrang,
                  decoration: const InputDecoration(
                      labelText: 'Tình trạng', border: OutlineInputBorder()),
                  items: ['Trống', 'Đã đặt']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => tinhTrang = val!),
                ),
                const SizedBox(height: 16),
                _buildTextField('Ảnh phòng (URL)', anhCtrl),
                const SizedBox(height: 10),
                if (anhCtrl.text.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        anhCtrl.text,
                        width: 500,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                _buildTextField('Mô tả', moTaCtrl, maxLines: 3),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy')),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSubmit(Room(
                            id: widget.room?.id ?? _generateId(),
                            soPhong: soPhongCtrl.text,
                            tang: tangCtrl.text,
                            loaiPhong: loaiPhong,
                            giaDem: double.parse(giaCtrl.text),
                            tinhTrang: tinhTrang,
                            anhPhong: anhCtrl.text,
                            moTa: moTaCtrl.text,
                          ));
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Lưu'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty
          ? 'Không được bỏ trống'
          : null,
      onChanged: (_) => setState(() {}),
    );
  }
}
