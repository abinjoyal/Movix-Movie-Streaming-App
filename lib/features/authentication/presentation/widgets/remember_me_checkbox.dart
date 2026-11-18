import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Styled "Remember Me" checkbox with rounded square border matching Figma.
class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final bool isRoundedSquare;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Remember me',
    this.isRoundedSquare = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: isRoundedSquare ? BorderRadius.circular(6) : null,
                shape: isRoundedSquare ? BoxShape.rectangle : BoxShape.circle,
                color: value ? AppColors.primaryRed : Colors.transparent,
                border: Border.all(
                  color: AppColors.primaryRed,
                  width: 2.0,
                ),
              ),
              child: value
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : const Color(0xFF212121),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
