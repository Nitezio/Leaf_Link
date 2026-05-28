import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_body.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSignup = false;
  bool _showPassword = false;
  bool _isLoading = false;
  String? _errorText;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  final _nameCtrl = TextEditingController();

  static const _testEmail = 'test@gmail.com';
  static const _testPassword = '123test';

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: _testEmail);
    _passwordCtrl = TextEditingController(text: _testPassword);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    final state = context.read<AppState>();
    final error = await state.authenticateLocal(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
      isSignup: _isSignup,
      name: _nameCtrl.text,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _errorText = error;
    });
    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isSignup ? 'Account created locally' : 'Signed in locally'),
          backgroundColor: AppColors.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _blob(250, AppColors.secondary.withValues(alpha: 0.2)),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _blob(300, AppColors.primary.withValues(alpha: 0.1)),
          ),
          SafeArea(
            child: ResponsiveBody(
              maxWidth: 520,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + app name
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(Icons.eco_rounded,
                              size: 32, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PlantCare Pro',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              'Grow with us',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 36),

                    Text(
                      _isSignup ? 'Create Account' : 'Welcome Back',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _isSignup
                          ? 'Start your green journey today'
                          : 'Sign in to continue growing',
                      style: TextStyle(
                          color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)), fontSize: 15),
                    ),
                    SizedBox(height: 32),

                    // Name field (signup only)
                    if (_isSignup) ...[
                      _inputField(
                        controller: _nameCtrl,
                        hint: 'Full Name',
                        icon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 16),
                    ],

                    // Email
                    _inputField(
                      controller: _emailCtrl,
                      hint: 'Email address',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),

                    // Password
                    _inputField(
                      controller: _passwordCtrl,
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscure: !_showPassword,
                      suffix: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),

                    if (!_isSignup) ...[
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 28),

                    // Sign In / Create Account button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: StadiumBorder(),
                          elevation: 4,
                          shadowColor: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isSignup ? 'Create Account' : 'Sign In',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    if (_errorText != null) ...[
                      SizedBox(height: 12),
                      Text(
                        _errorText!,
                        style: TextStyle(
                          color: AppColors.destructive,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    SizedBox(height: 28),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                            child:
                                Divider(color: Theme.of(context).colorScheme.outline, thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                            child:
                                Divider(color: Theme.of(context).colorScheme.outline, thickness: 1)),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Social buttons
                    Row(
                      children: [
                        Expanded(
                            child: _socialBtn(
                                'Google', _googleIcon(), () async {
                          setState(() {
                            _isLoading = true;
                            _errorText = null;
                          });
                          final state = context.read<AppState>();
                          final err = await state.signInWithGoogle();
                          if (!mounted) return;
                          setState(() {
                            _isLoading = false;
                            _errorText = err;
                          });
                          if (err == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Signed in with Google'),
                                backgroundColor: AppColors.secondary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        })),
                        SizedBox(width: 12),
                        Expanded(
                              child: _socialBtn(
                                'GitHub', _githubIcon(), _submit)),
                      ],
                    ),
                    SizedBox(height: 28),

                    // Toggle signup/login
                    Center(
                      child: GestureDetector(
                        onTap: () => setState(() => _isSignup = !_isSignup),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)), fontSize: 14),
                            children: [
                              TextSpan(
                                text: _isSignup
                                    ? "Already have an account? "
                                    : "Don't have an account? ",
                              ),
                              TextSpan(
                                text: _isSignup ? 'Sign In' : 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
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
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          SizedBox(width: 16),
          Icon(icon, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 15),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  Widget _socialBtn(String label, Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20, height: 20, child: icon),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color));

  Widget _googleIcon() {
    return CustomPaint(painter: _GooglePainter());
  }

  Widget _githubIcon() {
    return Icon(Icons.code_rounded,
        size: 18, color: Theme.of(context).colorScheme.onSurface);
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // Simplified coloured G
    paint.color = Color(0xFF4285F4);
    canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        -0.3,
        2.7,
        false,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.15);
    paint
      ..style = PaintingStyle.fill
      ..color = Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.5, size.height * 0.35, size.width * 0.5,
          size.height * 0.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

