import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoctran/core/routing/app_routes.dart';

class AppDrawer extends StatelessWidget {
  final User? user;

  const AppDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Người dùng'),
            accountEmail: Text(user?.email ?? 'Chưa đăng nhập'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Color(0xffB753A5)),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.meeting_room, color: Color(0xffB664AA)),
            title: const Text('Trang chủ'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.home);
            },
          ),

          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.blueAccent),
            title: const Text('Đặt phòng của tôi'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.myBookings);
            },
          ),

          ListTile(
            leading: const Icon(Icons.manage_accounts, color: Color.fromARGB(255, 219, 88, 223)),
            title: const Text('Quản lý phòng'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.roomManagement);
            },
          ),

          ListTile(
            leading: const Icon(Icons.person, color: Color(0xff994D91)),
            title: const Text('Hồ sơ cá nhân'),
            onTap: () {
              Navigator.pop(context);
              context.go(AppRoutes.profile);
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Đăng xuất'),
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
