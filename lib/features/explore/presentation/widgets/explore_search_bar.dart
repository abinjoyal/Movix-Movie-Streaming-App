import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Top search bar with red filter button matching Figma Explore header.
class ExploreSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;

  const ExploreSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    required this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isFocused = focusNode.hasFocus;
    final searchBg = isDark ? const Color(0xFF1F222A) : const Color(0xFFF5F5F8);
    final borderColor = isFocused
        ? AppColors.primaryRed
        : (isDark ? const Color(0xFF2B2E38) : const Color(0xFFEEEEEE));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // 1. Search text input
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                  width: isFocused ? 1.5 : 1.0,
                ),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF1F1F1F),
                ),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextMuted : const Color(0xFF9E9E9E),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isFocused
                        ? AppColors.primaryRed
                        : (isDark ? AppColors.darkTextMuted : const Color(0xFF9E9E9E)),
                    size: 22,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel_rounded, size: 20),
                          color: isDark ? Colors.white70 : const Color(0xFF757575),
                          onPressed: () {
                            controller.clear();
                            onClear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // 2. Red Filter Button on Right
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasActiveFilters
                    ? AppColors.primaryRed
                    : (isDark
                        ? AppColors.primaryRed.withValues(alpha: 0.18)
                        : const Color(0xFFFFEBEE)),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.tune_rounded,
                size: 22,
                color: hasActiveFilters ? Colors.white : AppColors.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

