import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_paths.dart';
import '../providers/auth_provider.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/primary_auth_button.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? email;

  const OtpVerificationScreen({super.key, this.email});

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  String _enteredOtp = '';
  int _secondsRemaining = 55;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = 55);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_enteredOtp.length < 6) {
      context.showSnackBar('Please enter the full 6-digit code', isError: true);
      return;
    }

    final targetEmail = widget.email ?? '';
    final success = await ref.read(authProvider.notifier).verifyOtp(
          email: targetEmail,
          token: _enteredOtp,
        );

    if (success && mounted) {
      context.push(RoutePaths.resetPassword);
    } else if (mounted) {
      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        context.showSnackBar(error, isError: true);
      }
    }
  }

  Future<void> _handleResend() async {
    if (_secondsRemaining > 0) return;
    final targetEmail = widget.email ?? '';
    final success = await ref
        .read(authProvider.notifier)
        .sendPasswordResetEmail(targetEmail);
    if (success && mounted) {
      context.showSnackBar('Verification code resent!');
      _startCountdown();
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
          'OTP Code Verification',
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
                      const SizedBox(height: 36),
                      // Instruction
                      Text(
                        'Code has been sent to ${widget.email ?? "your email"}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: isDark ? AppColors.darkTextSecondary : const Color(0xFF616161),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // 6-digit OTP Box input
                      OtpInputField(
                        length: 6,
                        onChanged: (val) => _enteredOtp = val,
                        onCompleted: (val) {
                          _enteredOtp = val;
                          _handleVerify();
                        },
                      ),
                      const SizedBox(height: 48),

                      // Countdown & Resend
                      if (_secondsRemaining > 0)
                        Text(
                          'Resend code in $_secondsRemaining s',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.darkTextMuted : const Color(0xFF757575),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: _handleResend,
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Verify button
              PrimaryAuthButton(
                text: 'Verify',
                isLoading: authState.isLoading,
                onPressed: _handleVerify,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

