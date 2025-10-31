import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoctran/core/routing/app_routes.dart';

// Domain & Data Layers
import 'package:ngoctran/features/bookings/domain/entities/booking_entity.dart';
import 'package:ngoctran/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:ngoctran/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:ngoctran/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:ngoctran/features/bookings/data/models/booking_model.dart';

// Room model
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

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_router/go_router.dart';
// import 'package:ngoctran/core/routing/app_routes.dart';
// import 'package:ngoctran/features/rooms/data/models/room_model.dart';

// class BookingPage extends StatefulWidget {
//   final RoomModel room;
//   const BookingPage({super.key, required this.room});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController(); 
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _noteController = TextEditingController();
//   final TextEditingController _peopleController = TextEditingController();

//   String _payment = 'Tiền mặt';
//   DateTime? _checkInDate;
//   DateTime? _checkOutDate;
//   bool _loading = false;

//   Future<void> _pickCheckInDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _checkInDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) {
//       setState(() {
//         _checkInDate = picked;
//         if (_checkOutDate != null && _checkOutDate!.isBefore(picked)) {
//           _checkOutDate = null;
//         }
//       });
//     }
//   }

//   Future<void> _pickCheckOutDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _checkOutDate ?? (_checkInDate ?? DateTime.now()),
//       firstDate: _checkInDate ?? DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (picked != null) setState(() => _checkOutDate = picked);
//   }

//   double _calculateTotal() {
//     if (_checkInDate == null || _checkOutDate == null) return 0;
//     final days = _checkOutDate!.difference(_checkInDate!).inDays;
//     final totalDays = days > 0 ? days : 1;
//     return totalDays * widget.room.giaDem;
//   }

//   Future<void> _bookRoom() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (_checkInDate == null || _checkOutDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Vui lòng chọn ngày check-in và check-out'),
//         ),
//       );
//       return;
//     }

//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng đăng nhập để đặt phòng')),
//       );
//       return;
//     }

//     final total = _calculateTotal();

//     setState(() => _loading = true);

//     try {
//       final bookingRef = FirebaseFirestore.instance.collection('bookings');

//       // 1️⃣ Tạo mới booking
//       await bookingRef.add({
//         'userId': user.uid,
//         'roomId': widget.room.id,
//         'roomType': widget.room.loaiPhong,
//         'roomNumber': widget.room.soPhong,
//         'price': widget.room.giaDem,
//         'total': total,
//         'name': _nameController.text,
//         'phone': _phoneController.text,
//         'email': _emailController.text,
//         'address': _addressController.text,
//         'note': _noteController.text,
//         'people': int.tryParse(_peopleController.text) ?? 1,
//         'payment': _payment,
//         'checkInDate': Timestamp.fromDate(_checkInDate!),
//         'checkOutDate': Timestamp.fromDate(_checkOutDate!),
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       // 2️⃣ Cập nhật tình trạng phòng → "Đã đặt"
//       await FirebaseFirestore.instance
//           .collection('rooms')
//           .doc(widget.room.id)
//           .update({'tinhTrang': 'Đã đặt'});

//       // 3️⃣ Thông báo thành công
//       if (!mounted) return;
//       setState(() => _loading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Đặt phòng thành công!'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           duration: Duration(seconds: 2),
//         ),
//       );
//       // 4️⃣ Chờ 1s rồi chuyển về trang chủ
//       await Future.delayed(const Duration(seconds: 1));
//       if (mounted) {
//         context.go(AppRoutes.home);
//       }
//     } catch (e) {
//       setState(() => _loading = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Lỗi khi đặt phòng: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.room.id.isEmpty) {
//       return const Scaffold(
//         body: Center(child: Text('Không tìm thấy thông tin phòng')),
//       );
//     }

//     final total = _calculateTotal();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F4FF),
//       appBar: AppBar(
//         title: const Text('Xác nhận đặt phòng'),
//         backgroundColor: Colors.purpleAccent,
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: _loading
//             ? const Center(child: CircularProgressIndicator())
//             : Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.network(
//                               widget.room.anhPhong,
//                               width: 120,
//                               height: 120,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Container(
//                                 width: 120,
//                                 height: 120,
//                                 color: Colors.grey[300],
//                                 child: const Icon(Icons.image_not_supported),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Phòng ${widget.room.soPhong}',
//                                   style: const TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   widget.room.loaiPhong,
//                                   style: const TextStyle(
//                                     color: Colors.purple,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   '${widget.room.giaDem.toStringAsFixed(0)} VNĐ/đêm',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.black87,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     const Text(
//                       'Thông tin đặt phòng',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: InkWell(
//                             onTap: _pickCheckInDate,
//                             child: InputDecorator(
//                               decoration: _inputDecoration(
//                                 'Check-in',
//                                 Icons.calendar_today,
//                               ),
//                               child: Text(
//                                 _checkInDate == null
//                                     ? 'Chưa chọn'
//                                     : '${_checkInDate!.day}/${_checkInDate!.month}/${_checkInDate!.year}',
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: InkWell(
//                             onTap: _pickCheckOutDate,
//                             child: InputDecorator(
//                               decoration: _inputDecoration(
//                                 'Check-out',
//                                 Icons.calendar_today,
//                               ),
//                               child: Text(
//                                 _checkOutDate == null
//                                     ? 'Chưa chọn'
//                                     : '${_checkOutDate!.day}/${_checkOutDate!.month}/${_checkOutDate!.year}',
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     if (total > 0)
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12.withOpacity(0.05),
//                               blurRadius: 10,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Tổng tiền cần thanh toán:',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             Text(
//                               '${total.toStringAsFixed(0)} VNĐ',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.purple,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _peopleController,
//                       decoration: _inputDecoration(
//                         'Số lượng người',
//                         Icons.people_outline,
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (v) => v == null || v.isEmpty
//                           ? 'Vui lòng nhập số lượng người'
//                           : null,
//                     ),
//                     const SizedBox(height: 24),

//                     const Text(
//                       'Thông tin khách hàng',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _nameController,
//                       decoration: _inputDecoration(
//                         'Họ và tên',
//                         Icons.person_outline,
//                       ),
//                       validator: (v) => v == null || v.isEmpty
//                           ? 'Vui lòng nhập họ tên'
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _phoneController,
//                       decoration: _inputDecoration(
//                         'Số điện thoại',
//                         Icons.phone_android,
//                       ),
//                       keyboardType: TextInputType.phone,
//                       validator: (v) => v == null || v.isEmpty
//                           ? 'Vui lòng nhập số điện thoại'
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _emailController,
//                       decoration: _inputDecoration(
//                         'Email',
//                         Icons.email_outlined,
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                       validator: (v) =>
//                           v == null || v.isEmpty ? 'Vui lòng nhập email' : null,
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _addressController,
//                       decoration: _inputDecoration(
//                         'Địa chỉ',
//                         Icons.home_outlined,
//                       ),
//                       validator: (v) => v == null || v.isEmpty
//                           ? 'Vui lòng nhập địa chỉ'
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     TextFormField(
//                       controller: _noteController,
//                       decoration: _inputDecoration(
//                         'Ghi chú (tuỳ chọn)',
//                         Icons.note_alt_outlined,
//                       ),
//                       maxLines: 3,
//                     ),
//                     const SizedBox(height: 16),

//                     DropdownButtonFormField<String>(
//                       initialValue: _payment,
//                       decoration: _inputDecoration(
//                         'Phương thức thanh toán',
//                         Icons.payment,
//                       ),
//                       items: ['Tiền mặt', 'Chuyển khoản', 'Thẻ tín dụng']
//                           .map(
//                             (e) => DropdownMenuItem(value: e, child: Text(e)),
//                           )
//                           .toList(),
//                       onChanged: (v) => setState(() => _payment = v!),
//                     ),
//                     const SizedBox(height: 30),

//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton(
//                             onPressed: () => Navigator.pop(context),
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               side: const BorderSide(
//                                 color: Colors.purpleAccent,
//                               ),
//                             ),
//                             child: const Text(
//                               'HUỶ',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.purpleAccent,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: _bookRoom,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.purpleAccent,
//                               padding: const EdgeInsets.symmetric(vertical: 16),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               elevation: 4,
//                             ),
//                             child: const Text(
//                               'XÁC NHẬN',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String label, IconData icon) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon, color: Colors.purple),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }
// }
