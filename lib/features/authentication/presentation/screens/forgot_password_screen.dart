import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../providers/auth_provider.dart';
import '../widgets/primary_auth_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController(text: 'your_email@domain.com');
  int _selectedOption = 0; // 0 for email, 1 for sms

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      context.showSnackBar('Please enter your email address', isError: true);
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .sendPasswordResetEmail(email);

    if (success && mounted) {
      // Navigate to OTP verification passing the email as extra parameter
      context.push(RoutePaths.otpVerification, extra: email);
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
          'Forgot Password',
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Decorative lock & key illustration badge
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryRedContainer.withValues(alpha: 0.15),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          size: 72,
                          color: AppColors.primaryRed,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Instructions
                      Text(
                        'Select which contact details should we use to reset your password:',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF616161),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Option 1: via Email
                      _RecoveryOptionCard(
                        icon: Icons.mark_email_read_outlined,
                        title: 'via Email:',
                        subtitle: 'Send reset code to your email',
                        isSelected: _selectedOption == 0,
                        onTap: () => setState(() => _selectedOption = 0),
                      ),
                      const SizedBox(height: 16),

                      // Option 2: via SMS
                      _RecoveryOptionCard(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'via SMS:',
                        subtitle: '+1 111 ******99',
                        isSelected: _selectedOption == 1,
                        onTap: () => setState(() => _selectedOption = 1),
                      ),
                      const SizedBox(height: 20),

                      // Optional editable email field if email selected
                      if (_selectedOption == 0)
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Email',
                            prefixIcon: const Icon(Icons.email_outlined, size: 20),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                onPressed: _handleContinue,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecoveryOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RecoveryOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isSelected
        ? AppColors.primaryRed
        : (isDark ? AppColors.darkBorder : const Color(0xFFE0E0E0));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryRed.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: AppColors.primaryRed, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextMuted : const Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

