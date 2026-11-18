import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_auth_button.dart';
import '../widgets/remember_me_checkbox.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      context.showSnackBar('Passwords do not match', isError: true);
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .updatePassword(_newPasswordController.text);

    if (success && mounted) {
      context.go(RoutePaths.resetSuccess);
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
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : const Color(0xFF1F1F1F),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Create New Password',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1F1F1F),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        // Illustration
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryRedContainer.withValues(alpha: 0.15),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            size: 72,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Subtitle
                        Text(
                          'Create Your New Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // New password
                        AuthTextField(
                          controller: _newPasswordController,
                          hintText: 'New Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          isPasswordVisible: _isNewPasswordVisible,
                          onToggleVisibility: () {
                            setState(() =>
                                _isNewPasswordVisible = !_isNewPasswordVisible);
                          },
                          validator: Validators.password,
                        ),
                        const SizedBox(height: 16),

                        // Confirm password
                        AuthTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          isPasswordVisible: _isConfirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() => _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible);
                          },
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (val != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Remember me checkbox
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RememberMeCheckbox(
                            value: authState.rememberMe,
                            onChanged: (val) {
                              ref
                                  .read(authProvider.notifier)
                                  .toggleRememberMe(val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Continue button
                PrimaryAuthButton(
                  text: 'Continue',
                  isLoading: authState.isLoading,
                  onPressed: _handleResetPassword,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

