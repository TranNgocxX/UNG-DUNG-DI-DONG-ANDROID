import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ngoctran/core/presentation/widget/customer_bottom_nav.dart';
import 'package:ngoctran/core/routing/app_routes.dart';
import 'package:ngoctran/features/auth/presentation/pages/login_page.dart';
import 'package:ngoctran/features/auth/presentation/pages/signup_page.dart';
import 'package:ngoctran/features/home/presentation/pages/home_page.dart';
import 'package:ngoctran/features/bookings/presentation/pages/my_bookings_page.dart';
import 'package:ngoctran/features/profile/presentation/pages/profile_page.dart';
import 'go_router_refresh_change.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,

    routes: [
      // Đăng nhập
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      // Đăng ký
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),

      // Khu vực chính có Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          final int currentIndex = _getIndexForLocation(state.matchedLocation);
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomerBottomNav(initialIndex: currentIndex),
          );
        },
        routes: [
          // 🏠 Trang chủ
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),

          // 🛏️ Danh sách đặt phòng
          GoRoute(
            path: AppRoutes.myBookings,
            builder: (context, state) => const MyBookingsPage(),
          ),

          // 👤 Hồ sơ cá nhân
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),

          // 🧾 Trang chi tiết tài khoản
          GoRoute(
            path: AppRoutes.accountDetail,
            builder: (context, state) => Scaffold(
              appBar: AppBar(title: const Text('Thông tin tài khoản')),
              body: const Center(
                child: Text('Trang chi tiết tài khoản của bạn.'),
              ),
            ),
          ),
        ],
      ),
    ],

    // 🔐 Điều hướng khi đăng nhập / đăng xuất
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggedIn = user != null;
      final loggingIn = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      if (!loggedIn && !loggingIn) return AppRoutes.login;
      if (loggedIn && loggingIn) return AppRoutes.home;
      return null;
    },

    refreshListenable:
        GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  );

  // 🔹 Xác định index hiện tại cho thanh điều hướng
  static int _getIndexForLocation(String path) {
    if (path.startsWith(AppRoutes.home)) return 0;
    if (path.startsWith(AppRoutes.myBookings)) return 1;
    if (path.startsWith(AppRoutes.profile)) return 2;
    return 0;
  }
}
