import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  String? error;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _remember = false;

  Future<void> _register() async {
    if (passCtrl.text != confirmCtrl.text) {
      setState(() => error = "Mật khẩu xác nhận không khớp");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );
      setState(() => error = null);
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                height: size.height * 0.35,
                color: Colors.white,
                child: Image.asset(
                  "assets/images/img2.png",
                  fit: BoxFit.fill, 
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Đăng Ký",
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
                    if (error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),

                    TextField(
                      controller: emailCtrl,
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

                    TextField(
                      controller: passCtrl,
                      obscureText: _obscurePass,
                      decoration: InputDecoration(
                        labelText: "Mật khẩu",
                        filled: true,
                        fillColor: const Color(0xFFF8F6FF),
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFF8C5CF4)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    TextField(
                      controller: confirmCtrl,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: "Xác nhận mật khẩu",
                        filled: true,
                        fillColor: const Color(0xFFF8F6FF),
                        prefixIcon: const Icon(Icons.lock_reset_outlined,
                            color: Color(0xFF8C5CF4)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
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
                          value: _remember,
                          activeColor: const Color(0xFF7B2FF7),
                          onChanged: (val) =>
                              setState(() => _remember = val ?? false),
                        ),
                        const Text("Nhớ tài khoản"),
                      ],
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C5CF4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          shadowColor: const Color(0xFF8C5CF4).withOpacity(0.5),
                          elevation: 6,
                        ),
                        onPressed: _register,
                        child: const Text(
                          "Đăng ký",
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

                    const Text(
                      "Khi đăng ký, bạn đồng ý với Điều khoản và Chính sách bảo mật của DREAMIE",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
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
