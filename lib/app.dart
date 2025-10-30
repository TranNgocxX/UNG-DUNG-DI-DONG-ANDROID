import 'package:flutter/material.dart';
import 'package:ngoctran/core/presentation/theme/app_theme.dart';
import 'package:ngoctran/core/routing/app_go_router.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KHACH SAN DREAMIE',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      routerConfig: AppGoRouter.router,
    );
  }
}
