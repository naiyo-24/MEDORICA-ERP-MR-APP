import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../provider/auth_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isPhoneFocused = false;
  bool _isPasswordFocused = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authNotifierProvider.notifier)
          .login(_phoneController.text, _passwordController.text);

      final authState = ref.read(authNotifierProvider);

      if (authState.isAuthenticated && mounted) {
        // Navigate to home screen
        context.go(AppRouter.home);
      } else if (authState.error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.lgRadius,
            ),
          ),
        );
        ref.read(authNotifierProvider.notifier).clearError();
      }
    }
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cannot open dialer'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.lgRadius,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final size = MediaQuery.of(context).size;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPaddingHorizontal,
                vertical: AppSpacing.screenPaddingVertical,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top spacing
                  SizedBox(height: keyboardVisible ? AppSpacing.xl : AppSpacing.mega),

                  // Logo
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: AppBorderRadius.xxlRadius,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: AppBorderRadius.xxlRadius,
                        child: Image.asset(
                          'assets/logo/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Marketing Header
                  Text(
                    'Welcome Back MR!',
                    style: AppTypography.h1.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Tagline
                  Text(
                    'Sign in to continue your journey',
                    style: AppTypography.description.copyWith(
                      color: AppColors.quaternary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.huge),

                  // Login Form
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Phone Number Field
                        Text(
                          'Phone Number',
                          style: AppTypography.label.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Focus(
                          onFocusChange: (hasFocus) {
                            setState(() => _isPhoneFocused = hasFocus);
                          },
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.primary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your phone number',
                              hintStyle: AppTypography.body.copyWith(
                                color: AppColors.quaternary,
                              ),
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: _isPhoneFocused
                                    ? AppColors.primary
                                    : AppColors.quaternary,
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              border: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              if (value.length < 10) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Password Field
                        Text(
                          'Password',
                          style: AppTypography.label.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Focus(
                          onFocusChange: (hasFocus) {
                            setState(() => _isPasswordFocused = hasFocus);
                          },
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.primary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: AppTypography.body.copyWith(
                                color: AppColors.quaternary,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: _isPasswordFocused
                                    ? AppColors.primary
                                    : AppColors.quaternary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.quaternary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: AppColors.white,
                              border: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.divider,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: AppBorderRadius.mdRadius,
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        // Sign In Button
                        SizedBox(
                          height: 56.0,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              disabledBackgroundColor: AppColors.disabledColor,
                              elevation: AppElevation.sm,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.lgRadius,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Sign In',
                                    style: AppTypography.buttonLarge.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Having Trouble Signing In
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: AppTypography.body.copyWith(
                                color: AppColors.quaternary,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Having trouble signing in?',
                                ),
                               
                                TextSpan(
                                  text: ' Call Support',
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _launchDialer('+916289398298'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom spacing for better layout
                  const SizedBox(height: AppSpacing.xl),
                  Divider(color: AppColors.divider, thickness: 2.0),
                  const SizedBox(height: AppSpacing.xl),
                  // Footer Info
                  Center(
                    child: Text(
                      'By signing in, you agree to our Terms & Conditions',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.quaternary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
