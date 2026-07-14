import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/features/admin/presentation/views/role_router_wrapper.dart';
import '../providers/auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
        ),
      );
      return;
    }

    await ref.read(authProvider.notifier).login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
            ),
          );
        }

        if (next.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful'),
            ),
          );

          // Navegar al RoleRouterWrapper que valida el rol
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const RoleRouterWrapper(),
            ),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Imagen superior
              Container(
                height: 280,
                width: double.infinity,
                color: const Color(0xFFDDE3EC),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Forgot password?',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed:
                            authState.isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Not a member? ',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Register now',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: const [
                        Expanded(
                          child: Divider(),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: Icons.g_mobiledata,
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.apple,
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.facebook,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: CircleAvatar(
        radius: 24,
        child: Icon(icon),
      ),
    );
  }
}