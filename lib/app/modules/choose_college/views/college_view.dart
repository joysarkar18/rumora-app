import 'package:campus_crush_app/app/common/widgets/common_button.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:campus_crush_app/constants/assets.dart';
import '../controllers/college_controller.dart';

class CollegeView extends GetView<CollegeController> {
  CollegeView({super.key});

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _stateDropdownKey = GlobalKey();
  final GlobalKey _collegeDropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading colleges...',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          if (controller.errorMessage.value != null) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    SizedBox(height: 2.h),
                    Text(
                      'Oops! Something went wrong',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      controller.errorMessage.value!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 3.h),
                    ElevatedButton.icon(
                      onPressed: controller.loadCollegesFromCSV,
                      icon: Icon(Icons.refresh),
                      label: Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.h),
                        Center(
                          child: SvgPicture.asset(
                            Assets.iconsCollegeArt,
                            width: 40.w,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Let's find your college",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "Select your state and college to continue",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        _buildStepIndicator(1, "State"),
                        SizedBox(height: 1.5.h),
                        _buildStateDropdown(),
                        SizedBox(height: 3.h),
                        _buildStepIndicator(2, "College"),
                        SizedBox(height: 1.5.h),
                        _buildCollegeDropdown(),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomSection(),
            ],
          );
        }),
      ),
    );
  }

  void _scrollToWidget(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = Get.height;

        // Calculate target scroll position
        // Position the dropdown so it's visible with some padding from top
        final targetScroll =
            _scrollController.offset + position.dy - (screenHeight * 0.15);

        _scrollController.animateTo(
          targetScroll.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget _buildStepIndicator(int step, String label) {
    return Obx(() {
      bool isComplete = false;
      if (step == 1) {
        isComplete = controller.selectedState.value != null;
      } else if (step == 2) {
        isComplete = controller.selectedCollege.value != null;
      }

      return Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isComplete ? AppColors.primary : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isComplete
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : Text(
                      '$step',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isComplete ? AppColors.primary : Colors.grey[700],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStateDropdown() {
    return Obx(() {
      final filteredStates = controller.getFilteredStates();
      final isOpen = controller.stateDropdownOpen.value;
      final hasSelection = controller.selectedState.value != null;

      // Scroll to dropdown when it opens
      if (isOpen) {
        _scrollToWidget(_stateDropdownKey);
      }

      return Container(
        key: _stateDropdownKey,
        decoration: BoxDecoration(
          color: hasSelection
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isOpen
                ? AppColors.primary
                : (hasSelection ? AppColors.primary : Colors.grey[300]!),
            width: isOpen || hasSelection ? 2 : 1.5,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: controller.toggleStateDropdown,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedState.value ?? 'Select your state',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: hasSelection
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: hasSelection
                              ? AppColors.primary
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isOpen)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: TextField(
                        onChanged: controller.updateStateSearch,
                        decoration: InputDecoration(
                          hintText: 'Search state...',
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 30.h),
                      child: filteredStates.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'No states found',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredStates.length,
                              itemBuilder: (context, index) {
                                final state = filteredStates[index];
                                final isSelected =
                                    controller.selectedState.value == state;
                                return InkWell(
                                  onTap: () => controller.selectState(state),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : null,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildCollegeDropdown() {
    return Obx(() {
      final filteredColleges = controller.getFilteredColleges();
      final isOpen = controller.collegeDropdownOpen.value;
      final hasSelection = controller.selectedCollege.value != null;
      final stateSelected = controller.selectedState.value != null;
      final isDisabled = !stateSelected;

      // Scroll to dropdown when it opens
      if (isOpen && stateSelected) {
        _scrollToWidget(_collegeDropdownKey);
      }

      return Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          key: _collegeDropdownKey,
          decoration: BoxDecoration(
            color: hasSelection
                ? AppColors.primary.withOpacity(0.05)
                : Colors.white,
            border: Border.all(
              color: isDisabled
                  ? Colors.grey[300]!
                  : (isOpen
                        ? AppColors.primary
                        : (hasSelection
                              ? AppColors.primary
                              : Colors.grey[300]!)),
              width: isOpen || hasSelection ? 2 : 1.5,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: isDisabled ? null : controller.toggleCollegeDropdown,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          controller.selectedCollege.value?.name ??
                              (isDisabled
                                  ? 'Please select a state first'
                                  : 'Select your college'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: hasSelection
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isDisabled
                                ? Colors.grey[400]
                                : (hasSelection
                                      ? AppColors.primary
                                      : Colors.grey[600]),
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: isDisabled
                              ? Colors.grey[400]
                              : AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isOpen && stateSelected)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: TextField(
                          onChanged: controller.updateCollegeSearch,
                          decoration: InputDecoration(
                            hintText: 'Search college...',
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxHeight: 35.h),
                        child: filteredColleges.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.school_outlined,
                                        size: 40,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        'No colleges found',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filteredColleges.length,
                                itemBuilder: (context, index) {
                                  final college = filteredColleges[index];
                                  final isSelected =
                                      controller.selectedCollege.value ==
                                      college;
                                  return InkWell(
                                    onTap: () =>
                                        controller.selectCollege(college),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primary.withOpacity(0.1)
                                            : null,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey[200]!,
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  college.name,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    color: isSelected
                                                        ? AppColors.primary
                                                        : Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 0.3.h),
                                                Text(
                                                  college.district,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isSelected)
                                            Icon(
                                              Icons.check_circle,
                                              color: AppColors.primary,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(() {
        final isEnabled = controller.isAllDataSelected();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: CommonButton(
                isLoading: controller.isSbmitting.value,
                loadingWidget: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
                onPressed: isEnabled ? _handleContinue : null,
                text: "Continue",
              ),
            ),
          ],
        );
      }),
    );
  }

  void _handleContinue() async {
    final collegeData = controller.getSelectedCollegeData();
    LoggerService.logInfo("College Data : $collegeData");
    await controller.submitCollegeData(collegeData);
  }
}
