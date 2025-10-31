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
import 'package:ngoctran/features/profile/presentation/pages/account_detail_page.dart';
import 'package:ngoctran/features/rooms/presentation/pages/room_management_page.dart';
import 'package:ngoctran/features/rooms/presentation/pages/room_detail_page.dart';
import 'package:ngoctran/features/rooms/data/models/room_model.dart';
import 'package:ngoctran/features/bookings/presentation/pages/booking_page.dart';

import 'go_router_refresh_change.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),

      GoRoute(
        path: AppRoutes.booking,
        builder: (context, state) {
          final room = state.extra as RoomModel?;
          if (room == null) {
            return const Scaffold(
              body: Center(
                child: Text('Không tìm thấy thông tin phòng.'),
              ),
            );
          }
          return BookingPage(room: room);
        },
      ),

      // 🔹 Phần chính có Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          final int currentIndex = _getIndexForLocation(state.matchedLocation);
          return Scaffold(
            body: child,
            bottomNavigationBar: CustomerBottomNav(initialIndex: currentIndex),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.myBookings,
            builder: (context, state) => const MyBookingsPage(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: AppRoutes.accountDetail,
            builder: (context, state) => const AccountDetailPage(),
          ),

          GoRoute(
            path: AppRoutes.roomManagement,
            builder: (context, state) => const RoomManagementPage(),
          ),
          GoRoute(
            path: '${AppRoutes.roomDetail}/:id',
            builder: (context, state) {
              final room = state.extra as RoomModel?;
              if (room == null) {
                return const Scaffold(
                  body: Center(child: Text('Không tìm thấy thông tin phòng.')),
                );
              }
              return RoomDetailPage(room: room);
            },
          ),
        ],
      ),
    ],

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

  static int _getIndexForLocation(String path) {
    if (path.startsWith(AppRoutes.home)) return 0;
    if (path.startsWith(AppRoutes.myBookings)) return 1;
    if (path.startsWith(AppRoutes.profile)) return 2;
    return 0;
  }
}
