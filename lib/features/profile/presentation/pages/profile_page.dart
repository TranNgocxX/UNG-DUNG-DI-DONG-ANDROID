import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoctran/core/routing/app_routes.dart';
import 'package:ngoctran/core/presentation/widget/app_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
      ),
      drawer: AppDrawer(user: user),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // 
          ListTile(
            leading: const CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white, size: 28),
            ),
            title: Text(user?.email ?? 'Khách vãng lai'),
            subtitle: const Text('Nhấn vào các lựa chọn bên dưới'),
          ),

          const Divider(),

          // 
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Tài khoản của tôi'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.push(AppRoutes.accountDetail);
            },
          ),

          // 
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Lịch sử đặt phòng'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.go(AppRoutes.myBookings);
            },
          ),

          const Divider(),

          // 
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }
}
