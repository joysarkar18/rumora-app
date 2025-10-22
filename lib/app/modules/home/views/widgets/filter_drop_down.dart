import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/app/utils/text_styles.dart';
import 'package:campus_crush_app/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Filter dropdown widget
class FilterDropdown extends StatefulWidget {
  final String selectedFilter;
  final List<String> filterOptions;
  final Function(String) onFilterChanged;

  const FilterDropdown({
    required this.selectedFilter,
    required this.filterOptions,
    required this.onFilterChanged,
    super.key,
  });

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                Assets.iconsFilter,
                height: 16,
                width: 16,
                colorFilter: ColorFilter.mode(
                  widget.selectedFilter.isEmpty
                      ? AppColors.grayBlue.withValues(alpha: 0.5)
                      : AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 6),
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 250),
                style: AppTextStyles.style14w600(
                  color: widget.selectedFilter.isEmpty
                      ? AppColors.grayBlue.withValues(alpha: 0.5)
                      : AppColors.primary,
                ),
                child: Text(
                  widget.selectedFilter.isEmpty
                      ? 'Filter'
                      : widget.selectedFilter,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: 3,
            width: widget.selectedFilter.isEmpty ? 0 : 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _overlayEntry.remove();
      setState(() => _isOpen = false);
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      setState(() => _isOpen = true);
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        right: MediaQuery.of(context).size.width - offset.dx - size.width,
        top: offset.dy + 50,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...widget.filterOptions.map((filter) {
                  final isSelected = widget.selectedFilter == filter;
                  return GestureDetector(
                    onTap: () {
                      widget.onFilterChanged(filter);
                      _toggleDropdown();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: Duration(milliseconds: 200),
                        style: AppTextStyles.style14w500(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grayBlue.withValues(alpha: 0.6),
                        ),
                        child: Text(filter),
                      ),
                    ),
                  );
                }).toList(),
                if (widget.selectedFilter.isNotEmpty) ...[
                  Divider(
                    height: 1,
                    color: AppColors.grayBlue.withValues(alpha: 0.1),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onFilterChanged('');
                      _toggleDropdown();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        'Clear Filter',
                        style: AppTextStyles.style14w500(
                          color: AppColors.grayBlue.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_isOpen) {
      _overlayEntry.remove();
    }
    super.dispose();
  }
}
