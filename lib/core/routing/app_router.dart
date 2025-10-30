import 'package:flutter/material.dart';
import 'package:ngoctran/features/rooms/presentation/pages/room_management_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/room_management':
        //return MaterialPageRoute(builder: (_) => const HomePage());
        return MaterialPageRoute(builder: (_) => const RoomManagementPage());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
