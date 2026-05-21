import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignup = false;
  bool showPassword = false;

  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.card,
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.secondary.withValues(alpha: 0.3), AppColors.primary.withValues(alpha: 0.1)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [AppColors.secondary, AppColors.primary],
                          ),
                        ),
                        child: const Icon(LucideIcons.leaf, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PlantCare Pro', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text('Grow with us', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedForeground)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Text(
                    isSignup ? 'Create Account' : 'Welcome Back',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSignup ? 'Start your green journey today' : 'Sign in to continue growing',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.mutedForeground),
                  ),
                  const SizedBox(height: 40),
                  if (isSignup) ...[
                    TextField(
                      decoration: const InputDecoration(hintText: 'Full Name', prefixIcon: Icon(LucideIcons.user)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextField(
                    decoration: const InputDecoration(hintText: 'Email address', prefixIcon: Icon(LucideIcons.mail)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(LucideIcons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? LucideIcons.eyeOff : LucideIcons.eye),
                        onPressed: () => setState(() => showPassword = !showPassword),
                      ),
                    ),
                  ),
                  if (!isSignup) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _handleLogin,
                    child: Text(isSignup ? 'Create Account' : 'Sign In', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Or continue with', style: TextStyle(color: AppColors.mutedForeground)),
                      ),
                      Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleLogin,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          icon: const Icon(Icons.g_mobiledata, size: 24), // Flutter standard
                          label: const Text('Google', style: TextStyle(color: AppColors.foreground)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _handleLogin,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          icon: const Icon(LucideIcons.github, size: 20, color: AppColors.foreground),
                          label: const Text('GitHub', style: TextStyle(color: AppColors.foreground)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () => setState(() => isSignup = !isSignup),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: AppColors.mutedForeground),
                          children: [
                            TextSpan(text: isSignup ? 'Already have an account? ' : "Don't have an account? "),
                            TextSpan(
                              text: isSignup ? 'Sign In' : 'Sign Up',
                              style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
