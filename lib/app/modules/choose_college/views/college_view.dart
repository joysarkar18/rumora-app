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
  const CollegeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.errorMessage.value != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 60, color: Colors.red),
                  SizedBox(height: 2.h),
                  Text(controller.errorMessage.value!),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: controller.loadCollegesFromCSV,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Center(
                          child: SvgPicture.asset(
                            Assets.iconsCollegeArt,
                            width: 45.w,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Where is your college?",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        _buildStateDropdown(),
                        SizedBox(height: 3.h),
                        Text(
                          "Choose your college",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 1.5.h),
                        _buildCollegeDropdown(),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: CommonButton(
                      isLoading: controller.isSbmitting.value,
                      loadingWidget: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                      onPressed: controller.isAllDataSelected()
                          ? _handleContinue
                          : null,
                      text: "Continue",
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStateDropdown() {
    return Obx(() {
      final filteredStates = controller.getFilteredStates();
      final isOpen = controller.stateDropdownOpen.value;

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: controller.toggleStateDropdown,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedState.value ?? 'Select State',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: controller.selectedState.value != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    Icon(
                      isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            if (isOpen)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: TextField(
                        onChanged: controller.updateStateSearch,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search state...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 25.h),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredStates.length,
                        itemBuilder: (context, index) {
                          final state = filteredStates[index];
                          return ListTile(
                            title: Text(state),
                            onTap: () => controller.selectState(state),
                            dense: true,
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

      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: controller.toggleCollegeDropdown,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedCollege.value?.name ??
                            'Select College',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: controller.selectedCollege.value != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    Icon(
                      isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
            if (isOpen && controller.selectedState.value != null)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: TextField(
                        onChanged: controller.updateCollegeSearch,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search college...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxHeight: 30.h),
                      child: filteredColleges.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No colleges found'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredColleges.length,
                              itemBuilder: (context, index) {
                                final college = filteredColleges[index];
                                return ListTile(
                                  title: Text(college.name),
                                  subtitle: Text(college.district),
                                  onTap: () =>
                                      controller.selectCollege(college),
                                  dense: true,
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

  void _handleContinue() async {
    final collegeData = controller.getSelectedCollegeData();

    LoggerService.logInfo("College Data : $collegeData");
    await controller.submitCollegeData(collegeData);
  }
}
