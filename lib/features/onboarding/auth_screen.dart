import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/scaffold_patterns.dart';
import 'onboarding_providers.dart';

/// AuthScreen — Handles both Sign Up and Sign In logic.
class AuthScreen extends ConsumerStatefulWidget {
  final bool isInitialSignUp;

  const AuthScreen({
    super.key,
    required this.isInitialSignUp,
  });

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isSignUp;
  bool _obscurePassword = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isInitialSignUp;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);
    
    try {
      if (_isSignUp) {
        await authNotifier.register(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );
      } else {
        await authNotifier.loginWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }
      // Redirection is handled by the router automatically when auth state changes.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('AppwriteException: ', '')),
          backgroundColor: AppColorsDark.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString().replaceAll('AppwriteException: ', '')),
            backgroundColor: AppColorsDark.error,
          ),
        );
      }
    });

    final isLoading = ref.watch(authProvider).isLoading;

    return AppScaffold.patternA(
      showFab: false,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              _isSignUp ? 'Create Account' : 'Welcome Back',
              style: AppTypography.displayLg(),
            ),
            const SizedBox(height: 8),
            Text(
              _isSignUp 
                ? 'Join FitKarma to start your wellness journey.'
                : 'Sign in to continue your progress.',
              style: AppTypography.bodyLg(color: AppColorsDark.textSecondary),
            ),
            const SizedBox(height: 40),

            if (_isSignUp) ...[
              _buildField(
                label: 'NAME',
                controller: _nameController,
                hint: 'Arjun Sharma',
                validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 24),
            ],

            _buildField(
              label: 'EMAIL',
              controller: _emailController,
              hint: 'arjun@fitkarma.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your email';
                if (!v.contains('@')) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 24),

            _buildField(
              label: 'PASSWORD',
              controller: _passwordController,
              hint: '••••••••',
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColorsDark.textMuted,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your password';
                if (v.length < 8) return 'Password must be at least 8 characters';
                return null;
              },
            ),

            const SizedBox(height: 48),

            _PrimaryButton(
              text: isLoading 
                ? 'Processing...' 
                : (_isSignUp ? 'Create Account' : 'Sign In'),
              isLoading: isLoading,
              onPressed: _submit,
            ),

            const SizedBox(height: 24),

            Center(
              child: TextButton(
                onPressed: () => setState(() => _isSignUp = !_isSignUp),
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMd(color: AppColorsDark.textSecondary),
                    children: [
                      TextSpan(
                        text: _isSignUp 
                          ? 'Already have an account? ' 
                          : "Don't have an account? ",
                      ),
                      TextSpan(
                        text: _isSignUp ? 'Log In' : 'Sign Up',
                        style: TextStyle(
                          color: AppColorsDark.primary,
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSm(color: AppColorsDark.textSecondary).copyWith(
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.bodyMd(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd(color: AppColorsDark.textMuted),
            filled: true,
            fillColor: AppColorsDark.surface0,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            suffixIcon: suffixIcon,
            errorStyle: const TextStyle(color: AppColorsDark.error),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const _PrimaryButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColorsDark.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsDark.primary,
          disabledBackgroundColor: AppColorsDark.primary.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: AppTypography.h3(color: Colors.white).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
    );
  }
}
