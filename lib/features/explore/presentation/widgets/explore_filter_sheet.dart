import 'package:flutter/material.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/explore_provider.dart';

/// Modal bottom sheet matching Figma "Sort & Filter" Screen 29 design.
class ExploreFilterSheet extends StatefulWidget {
  final ExploreFilterState initialFilters;
  final ValueChanged<ExploreFilterState> onApply;
  final VoidCallback onReset;

  const ExploreFilterSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
    required this.onReset,
  });

  static Future<void> show(
    BuildContext context, {
    required ExploreFilterState initialFilters,
    required ValueChanged<ExploreFilterState> onApply,
    required VoidCallback onReset,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExploreFilterSheet(
        initialFilters: initialFilters,
        onApply: onApply,
        onReset: onReset,
      ),
    );
  }

  @override
  State<ExploreFilterSheet> createState() => _ExploreFilterSheetState();
}

class _ExploreFilterSheetState extends State<ExploreFilterSheet> {
  late String? _category;
  late List<String> _regions;
  late List<String> _genres;
  late String? _period;
  late String _sortBy;

  static const _categories = ['Movie', 'TV Shows', 'K-Drama', 'Anime'];
  static const _allRegions = [
    'All Regions',
    'English',
    'South Korean',
    'Chinese',
    'Japanese',
    'Indian'
  ];
  static const _allGenres = [
    'Action',
    'Comedy',
    'Romance',
    'Thriller',
    'Drama',
    'Horror',
    'Animation'
  ];
  static const _allPeriods = ['All Periods', '2025', '2024', '2023', '2022'];
  static const _sortOptions = ['Popularity', 'Latest Release', 'Top Rated'];

  @override
  void initState() {
    super.initState();
    _category = widget.initialFilters.category;
    _regions = List.from(widget.initialFilters.regions);
    _genres = List.from(widget.initialFilters.genres);
    _period = widget.initialFilters.period ?? 'All Periods';
    _sortBy = widget.initialFilters.sortBy ?? 'Popularity';
  }

  void _handleReset() {
    setState(() {
      _category = null;
      _regions = [];
      _genres = [];
      _period = 'All Periods';
      _sortBy = 'Popularity';
    });
    widget.onReset();
    Navigator.of(context).pop();
  }

  void _handleApply() {
    widget.onApply(
      ExploreFilterState(
        category: _category,
        regions: _regions,
        genres: _genres,
        period: _period == 'All Periods' ? null : _period,
        sortBy: _sortBy,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final sheetBg = isDark ? const Color(0xFF181A20) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F1F1F);
    final dividerColor = isDark ? const Color(0xFF262A34) : const Color(0xFFEEEEEE);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF383B46) : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Title
          Text(
            'Sort & Filter',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 14),
          Divider(height: 1, thickness: 1, color: dividerColor),

          // 3. Scrollable Filter Sections
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories
                  _buildSectionTitle('Categories', textColor),
                  _buildChips(
                    items: _categories,
                    isSelected: (item) => _category == item,
                    onTap: (item) {
                      setState(() {
                        _category = _category == item ? null : item;
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // Regions
                  _buildSectionTitle('Regions', textColor),
                  _buildChips(
                    items: _allRegions,
                    isSelected: (item) =>
                        _regions.contains(item) ||
                        (item == 'All Regions' && _regions.isEmpty),
                    onTap: (item) {
                      setState(() {
                        if (item == 'All Regions') {
                          _regions.clear();
                        } else {
                          if (_regions.contains(item)) {
                            _regions.remove(item);
                          } else {
                            _regions.add(item);
                          }
                        }
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // Genre
                  _buildSectionTitle('Genre', textColor),
                  _buildChips(
                    items: _allGenres,
                    isSelected: (item) => _genres.contains(item),
                    onTap: (item) {
                      setState(() {
                        if (_genres.contains(item)) {
                          _genres.remove(item);
                        } else {
                          _genres.add(item);
                        }
                      });
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // Time Periods
                  _buildSectionTitle('Time Periods', textColor),
                  _buildChips(
                    items: _allPeriods,
                    isSelected: (item) => _period == item,
                    onTap: (item) {
                      setState(() => _period = item);
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 20),

                  // Sort
                  _buildSectionTitle('Sort', textColor),
                  _buildChips(
                    items: _sortOptions,
                    isSelected: (item) => _sortBy == item,
                    onTap: (item) {
                      setState(() => _sortBy = item);
                    },
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 4. Action Buttons (Reset & Apply)
          Divider(height: 1, thickness: 1, color: dividerColor),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              16,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Row(
              children: [
                // Reset Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.primaryRed.withValues(alpha: 0.2)
                            : const Color(0xFFFFEBEE),
                        foregroundColor: AppColors.primaryRed,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: _handleReset,
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Apply Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        shadowColor: AppColors.primaryRed.withValues(alpha: 0.4),
                      ),
                      onPressed: _handleApply,
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildChips({
    required List<String> items,
    required bool Function(String) isSelected,
    required ValueChanged<String> onTap,
    required bool isDark,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: items.map((item) {
        final selected = isSelected(item);
        return InkWell(
          onTap: () => onTap(item),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.primaryRed
                  : (isDark ? const Color(0xFF1F222A) : Colors.white),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? AppColors.primaryRed
                    : (isDark ? const Color(0xFF2E323E) : const Color(0xFFE50914).withValues(alpha: 0.5)),
                width: 1.2,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.primaryRed),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

