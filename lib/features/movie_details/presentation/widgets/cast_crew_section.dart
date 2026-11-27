import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/widgets/app_cached_image.dart';
import '../../domain/entities/movie_details.dart';

class CastCrewSection extends StatelessWidget {
  final List<CastMember> cast;
  final ValueChanged<CastMember>? onMemberTap;

  const CastCrewSection({
    super.key,
    required this.cast,
    this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final avatarFallbackBg =
        isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;

    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final member = cast[index];
          return InkWell(
            onTap: onMemberTap == null ? null : () => onMemberTap!(member),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: AppCachedImage(
                      imageUrl: member.fullProfileUrl,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                      customErrorWidget: Container(
                        width: 46,
                        height: 46,
                        color: avatarFallbackBg,
                        child: Icon(
                          Icons.person_rounded,
                          size: 24,
                          color: textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 115),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

