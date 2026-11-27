import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../domain/entities/movie_details.dart';

/// Presents the "Give Rating" bottom sheet matching Figma Screen 36.
Future<void> showGiveRatingSheet(
  BuildContext context, {
  required MovieDetails movie,
  int? initialRating,
  required ValueChanged<int> onSubmitRating,
  VoidCallback? onViewReviews,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _GiveRatingSheetBody(
        movie: movie,
        initialRating: initialRating,
        onSubmitRating: onSubmitRating,
        onViewReviews: onViewReviews,
      );
    },
  );
}

class _GiveRatingSheetBody extends StatefulWidget {
  final MovieDetails movie;
  final int? initialRating;
  final ValueChanged<int> onSubmitRating;
  final VoidCallback? onViewReviews;

  const _GiveRatingSheetBody({
    required this.movie,
    this.initialRating,
    required this.onSubmitRating,
    this.onViewReviews,
  });

  @override
  State<_GiveRatingSheetBody> createState() => _GiveRatingSheetBodyState();
}

class _GiveRatingSheetBodyState extends State<_GiveRatingSheetBody> {
  late int _selectedStars;

  @override
  void initState() {
    super.initState();
    _selectedStars =
        widget.initialRating ?? (widget.movie.voteAverage / 2).round().clamp(1, 5);
  }

  List<double> _distributionFor(double voteAverage) {
    final normalized = (voteAverage / 10).clamp(0.4, 1.0);
    return [
      (normalized * 0.92).clamp(0.15, 0.95),
      (normalized * 0.68).clamp(0.12, 0.78),
      (1.0 - normalized * 0.72).clamp(0.08, 0.45),
      (1.0 - normalized * 0.85).clamp(0.05, 0.30),
      (1.0 - normalized * 0.92).clamp(0.03, 0.20),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;
    final barTrackColor =
        isDark ? AppColors.darkSurfaceElevated : const Color(0xFFE5E7EB);

    final bars = _distributionFor(widget.movie.voteAverage);
    final starScore = (widget.movie.voteAverage / 2).clamp(0.0, 5.0);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Give Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 18),

              // Rating Summary + 5..1 Breakdown Bars
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              widget.movie.formattedRating,
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              '/10',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final filled = starScore >= index + 0.75;
                            final half = !filled && starScore >= index + 0.25;
                            return Icon(
                              filled
                                  ? Icons.star_rounded
                                  : half
                                      ? Icons.star_half_rounded
                                      : Icons.star_border_rounded,
                              color: AppColors.primaryRed,
                              size: 16,
                            );
                          }),
                        ),
                        if (widget.onViewReviews != null) ...[
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.onViewReviews?.call();
                            },
                            child: Text(
                              'View reviews',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 92,
                    color: dividerColor,
                    margin: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: List.generate(5, (index) {
                        final label = 5 - index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 12,
                                child: Text(
                                  '$label',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: bars[index],
                                    minHeight: 5,
                                    backgroundColor: barTrackColor,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryRed,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 18),

              // Interactive 5-Star Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final star = index + 1;
                  final active = star <= _selectedStars;
                  return IconButton(
                    onPressed: () => setState(() => _selectedStars = star),
                    icon: Icon(
                      active ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 36,
                      color: AppColors.primaryRed,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),

              // Cancel + Submit Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primaryRed.withValues(alpha: 0.12),
                          foregroundColor: AppColors.primaryRed,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onSubmitRating(_selectedStars);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

