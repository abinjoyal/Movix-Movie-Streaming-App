import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';

class MovieDetailsTabsDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  const MovieDetailsTabsDelegate({required this.tabController});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.lightSurface;
    final inactiveColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: tabController,
        labelColor: AppColors.primaryRed,
        unselectedLabelColor: inactiveColor,
        indicatorColor: AppColors.primaryRed,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: dividerColor,
        labelStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Trailers'),
          Tab(text: 'More Like This'),
          Tab(text: 'Comments'),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant MovieDetailsTabsDelegate oldDelegate) {
    return oldDelegate.tabController != tabController;
  }
}

