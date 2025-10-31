import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoctran/core/routing/app_routes.dart';
import 'package:ngoctran/features/bookings/domain/entities/booking_entity.dart';
import 'package:ngoctran/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:ngoctran/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:ngoctran/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:ngoctran/features/bookings/data/models/booking_model.dart';
import 'package:ngoctran/features/rooms/data/models/room_model.dart';

class BookingPage extends StatefulWidget {
  final RoomModel room;
  const BookingPage({super.key, required this.room});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  final _peopleController = TextEditingController();

  String _payment = 'Tiền mặt';
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  bool _loading = false;

  late final CreateBooking _createBookingUseCase;

  @override
  void initState() {
    super.initState();
    final repository = BookingRepositoryImpl(BookingRemoteDataSource());
    _createBookingUseCase = CreateBooking(repository);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  Future<void> _pickCheckInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
          _checkOutDate = null;
        }
      });
    }
  }

  Future<void> _pickCheckOutDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? (_checkInDate ?? DateTime.now()),
      firstDate: _checkInDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _checkOutDate = picked);
  }

  double _calculateTotal() {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final days = _checkOutDate!.difference(_checkInDate!).inDays;
    final totalDays = days > 0 ? days : 1;
    return totalDays * widget.room.giaDem;
  }

  Future<void> _bookRoom() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập để đặt phòng')));
      return;
    }

    if (_checkInDate == null || _checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày check-in và check-out')),
      );
      return;
    }

    final booking = BookingModel(
      id: '',
      userId: user.uid,
      roomId: widget.room.id,
      roomType: widget.room.loaiPhong,
      roomNumber: widget.room.soPhong,
      price: widget.room.giaDem,
      name: _nameController.text,
      phone: _phoneController.text,
      payment: _payment,
      createdAt: DateTime.now(),
    );

    setState(() => _loading = true);
    try {
      await _createBookingUseCase.call(booking);

      if (!mounted) return;
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đặt phòng thành công!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi khi đặt phòng: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FF),
      appBar: AppBar(
        title: const Text('Xác nhận đặt phòng'),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Thông tin phòng
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.room.anhPhong,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Phòng ${widget.room.soPhong}',
                                    style: const TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(widget.room.loaiPhong,
                                    style: const TextStyle(
                                        color: Colors.purple, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Text(
                                  '${widget.room.giaDem.toStringAsFixed(0)} VNĐ/đêm',
                                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Ngày checkin - checkout
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _pickCheckInDate,
                            child: InputDecorator(
                              decoration: _inputDecoration('Check-in', Icons.calendar_today),
                              child: Text(_checkInDate == null
                                  ? 'Chưa chọn'
                                  : '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _pickCheckOutDate,
                            child: InputDecorator(
                              decoration: _inputDecoration('Check-out', Icons.calendar_today),
                              child: Text(_checkOutDate == null
                                  ? 'Chưa chọn'
                                  : '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}'),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    if (total > 0)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Tổng tiền:',
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Text('${total.toStringAsFixed(0)} VNĐ',
                                style: const TextStyle(
                                    color: Colors.purple, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Họ và tên', Icons.person_outline),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Vui lòng nhập họ tên' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      decoration: _inputDecoration('Số điện thoại', Icons.phone),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Vui lòng nhập số điện thoại' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _payment,
                      decoration: _inputDecoration('Phương thức thanh toán', Icons.payment),
                      items: ['Tiền mặt', 'Chuyển khoản', 'Thẻ tín dụng']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _payment = v!),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _bookRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('XÁC NHẬN',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.purple),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
