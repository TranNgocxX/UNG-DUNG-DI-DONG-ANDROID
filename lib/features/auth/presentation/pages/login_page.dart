import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';
import '/core/routing/app_routes.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberAccount = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
              child: Container(
                width: double.infinity,
                height: size.height * 0.4,
                color: Colors.white, 
                child: FittedBox(
                  fit: BoxFit.fill, 
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/img2.png",
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Đăng Nhập",
              style: TextStyle(
                fontSize: 26,
                color: Color(0xFF7B2FF7),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    if (authState.hasError)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          authState.error.toString(),
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),

                    // Email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        filled: true,
                        fillColor: const Color(0xFFF8F6FF),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Color(0xFF8C5CF4)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        filled: true,
                        fillColor: const Color(0xFFF8F6FF),
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF8C5CF4)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberAccount,
                          activeColor: const Color(0xFF7B2FF7),
                          onChanged: (val) =>
                              setState(() => _rememberAccount = val ?? false),
                        ),
                        const Text("Nhớ tài khoản"),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Quên mật khẩu?",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Button đăng nhập
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C5CF4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          shadowColor:
                              const Color(0xFF8C5CF4).withOpacity(0.5),
                          elevation: 6,
                        ),
                        onPressed: authState.isLoading
                            ? null
                            : () {
                                ref
                                    .read(authControllerProvider.notifier)
                                    .signIn(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              },
                        child: authState.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Expanded(child: Divider(thickness: 0.5)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("hoặc"),
                        ),
                        Expanded(child: Divider(thickness: 0.5)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon("apple", Colors.black),
                        const SizedBox(width: 20),
                        _socialIcon("facebook", Color(0xFF1877F2)),
                        const SizedBox(width: 20),
                        _socialIcon("google", Color(0xFFEA4335)),
                      ],
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản? "),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.signup),
                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(
                              color: Color(0xFF7B2FF7),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(String type, Color color) {
    IconData icon;
    switch (type) {
      case "apple":
        icon = Icons.apple;
        break;
      case "facebook":
        icon = Icons.facebook;
        break;
      default:
        icon = Icons.g_mobiledata;
    }
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }
}
