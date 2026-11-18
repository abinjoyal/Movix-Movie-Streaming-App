import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';
import '../widgets/remember_me_checkbox.dart';
import '../widgets/social_login_buttons.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      context.showSnackBar(
        ref.read(authProvider).successMessage ??
            'Account created successfully! Check your email to verify.',
      );
      context.go(RoutePaths.login);
    } else if (mounted) {
      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        context.showSnackBar(error, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = context.isDarkMode;
    final bgColor = isDark ? AppColors.darkBackground : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 24,
            color: isDark ? Colors.white : const Color(0xFF1F1F1F),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),

                // 1. Centered Movix "M" Logo & Heading
                const AuthHeader(
                  title: 'Create Your Account',
                  showCard: false,
                ),
                const SizedBox(height: 24),

                // 2. Email field
                AuthTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  prefixIcon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),

                // 3. Password field
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  isPasswordVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    );
                  },
                  validator: Validators.password,
                ),
                const SizedBox(height: 18),

                // 4. Centered Remember Me
                Center(
                  child: RememberMeCheckbox(
                    value: authState.rememberMe,
                    isRoundedSquare: true,
                    onChanged: (val) {
                      ref
                          .read(authProvider.notifier)
                          .toggleRememberMe(val);
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 5. Sign Up Button
                PrimaryAuthButton(
                  text: 'Sign up',
                  isLoading: authState.isLoading,
                  onPressed: _handleSignUp,
                ),
                const SizedBox(height: 24),

                // 6. "or continue with" + Social Logins
                SocialLoginButtons(
                  onGooglePressed: () => ref
                      .read(authProvider.notifier)
                      .signInWithGoogle(),
                  onApplePressed: () =>
                      ref.read(authProvider.notifier).signInWithApple(),
                  onFacebookPressed: () => ref
                      .read(authProvider.notifier)
                      .signInWithFacebook(),
                ),
                const SizedBox(height: 28),

                // 7. Bottom Link to Sign In
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(RoutePaths.login),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : const Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
