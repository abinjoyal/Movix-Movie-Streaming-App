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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (success && mounted) {
      context.go(RoutePaths.home);
    } else if (mounted) {
      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        context.showSnackBar(error, isError: true);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
    if (mounted) {
      context.go(RoutePaths.home);
    }
  }

  Future<void> _handleAppleSignIn() async {
    await ref.read(authProvider.notifier).signInWithApple();
    if (mounted) {
      context.go(RoutePaths.home);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    await ref.read(authProvider.notifier).signInWithFacebook();
    if (mounted) {
      context.go(RoutePaths.home);
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.onboarding);
            }
          },
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
                // 1. Centered M Logo & Heading
                const AuthHeader(
                  title: 'Login to Your Account',
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
                        () => _isPasswordVisible = !_isPasswordVisible);
                  },
                  validator: Validators.password,
                ),
                const SizedBox(height: 18),

                // 4. Centered Remember Me Checkbox
                Center(
                  child: RememberMeCheckbox(
                    value: authState.rememberMe,
                    isRoundedSquare: true,
                    onChanged: (val) {
                      ref.read(authProvider.notifier).toggleRememberMe(val);
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 5. Sign In Button
                PrimaryAuthButton(
                  text: 'Sign in',
                  isLoading: authState.isLoading,
                  onPressed: _handleSignIn,
                ),
                const SizedBox(height: 16),

                // 6. Centered "Forgot the password?"
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(RoutePaths.forgotPassword),
                    child: const Text(
                      'Forgot the password?',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 7. "or continue with" + Social Logins (Dummy Login on Tap)
                SocialLoginButtons(
                  onGooglePressed: _handleGoogleSignIn,
                  onApplePressed: _handleAppleSignIn,
                  onFacebookPressed: _handleFacebookSignIn,
                ),
                const SizedBox(height: 28),

                // 8. Centered "Don't have an account? Sign up"
                Center(
                  child: GestureDetector(
                    onTap: () => context.push(RoutePaths.register),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : const Color(0xFF9E9E9E),
                          fontSize: 14,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Sign up',
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
