// controllers/college_controller.dart
import 'package:campus_crush_app/app/routes/app_pages.dart';
import 'package:campus_crush_app/app/services/logger_service.dart';
import 'package:campus_crush_app/app/services/login_manager.dart';
import 'package:campus_crush_app/app/utils/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class CollegeController extends GetxController {
  final selectedState = Rxn<String>();
  final selectedCollege = Rxn<CollegeData>();
  final stateSearchQuery = ''.obs;
  final collegeSearchQuery = ''.obs;
  final isLoading = true.obs;
  final errorMessage = Rxn<String>();
  final stateDropdownOpen = false.obs;
  final collegeDropdownOpen = false.obs;
  final isSbmitting = false.obs;

  late List<CollegeData> allColleges = [];
  late List<String> allStates = [];

  @override
  void onInit() {
    super.onInit();
    loadCollegesFromCSV();
  }

  Future<void> loadCollegesFromCSV() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final csvData = await rootBundle.loadString('assets/csv/colleges.csv');
      List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);

      allColleges = rows
          .skip(1)
          .map((row) => CollegeData.fromList(row))
          .toList();
      allStates = allColleges.map((college) => college.state).toSet().toList()
        ..sort();

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error loading colleges: $e';
      isLoading.value = false;
    }
  }

  List<String> getFilteredStates() {
    if (stateSearchQuery.isEmpty) {
      return allStates;
    }
    return allStates
        .where(
          (state) => state.toLowerCase().contains(
            stateSearchQuery.value.toLowerCase(),
          ),
        )
        .toList();
  }

  List<CollegeData> getCollegesForState(String state) {
    return allColleges.where((college) => college.state == state).toList();
  }

  /// Calculates similarity score between query and text (0.0 to 1.0)
  double _calculateSimilarity(String query, String text) {
    final queryLower = query.toLowerCase();
    final textLower = text.toLowerCase();

    // Exact match gets highest score
    if (textLower == queryLower) return 1.0;

    // Starts with match gets high score
    if (textLower.startsWith(queryLower)) return 0.95;

    // Contains match gets good score
    if (textLower.contains(queryLower)) return 0.8;

    // Acronym matching - e.g., "iitp" matches "Indian Institute of Technology Patna"
    final acronym = _getAcronym(textLower);
    if (acronym == queryLower) return 0.9;
    if (acronym.contains(queryLower)) return 0.75;

    // Fuzzy matching - calculates how well characters match in order
    return _fuzzyMatch(queryLower, textLower);
  }

  /// Extracts acronym from text (first letter of each word)
  /// Example: "Indian Institute of Technology Patna" -> "iitp"
  String _getAcronym(String text) {
    return text
        .split(RegExp(r'[\s\-_]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word[0])
        .join()
        .toLowerCase();
  }

  /// Fuzzy matching algorithm - checks how many characters match in sequence
  /// Returns score between 0 and 1
  double _fuzzyMatch(String query, String text) {
    int queryIdx = 0;
    int textIdx = 0;
    int matches = 0;

    while (queryIdx < query.length && textIdx < text.length) {
      if (query[queryIdx] == text[textIdx]) {
        matches++;
        queryIdx++;
      }
      textIdx++;
    }

    // All characters of query must be found to be a valid match
    if (queryIdx == query.length) {
      return (matches / query.length) * 0.7;
    }
    return 0.0;
  }

  List<CollegeData> getFilteredColleges() {
    final collegesInState = getCollegesForState(selectedState.value ?? '');

    if (collegeSearchQuery.isEmpty) {
      return collegesInState;
    }

    final query = collegeSearchQuery.value;

    // Create list of colleges with their similarity scores
    final scoredColleges = collegesInState.map((college) {
      final nameScore = _calculateSimilarity(query, college.name);
      final idScore = _calculateSimilarity(query, college.id);
      final maxScore = nameScore > idScore ? nameScore : idScore;

      return MapEntry(college, maxScore);
    }).toList();

    // Filter colleges with score > 0, sort by score descending, then extract colleges
    scoredColleges.sort((a, b) => b.value.compareTo(a.value));

    return scoredColleges
        .where((entry) => entry.value > 0.0)
        .map((entry) => entry.key)
        .toList();
  }

  void selectState(String state) {
    selectedState.value = state;
    selectedCollege.value = null;
    collegeSearchQuery.value = '';
    stateSearchQuery.value = '';
    stateDropdownOpen.value = false;
  }

  Future<void> submitCollegeData(Map<String, dynamic> data) async {
    try {
      final userId = LoginManager.instance.currentUserId;

      LoggerService.logInfo("Updating data of $userId");

      // Check if data is null or empty
      if (data == null || data.isEmpty) {
        LoggerService.logError("College data is null or empty");
        Get.snackbar(
          'Error',
          'Please fill in all required fields!',
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Log the data being sent
      LoggerService.logInfo("Data to update: $data");

      isSbmitting.value = true;

      await FirebaseFirestore.instance.collection("user").doc(userId).update({
        "college": data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      isSbmitting.value = false;
      Get.toNamed(Routes.CHOOSE_GENDER);
    } catch (e) {
      isSbmitting.value = false;
      LoggerService.logError("Error updating college data: $e");
      Get.snackbar(
        'Error',
        'Failed to update data!',
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectCollege(CollegeData college) {
    selectedCollege.value = college;
    collegeSearchQuery.value = '';
    collegeDropdownOpen.value = false;
  }

  void updateStateSearch(String query) {
    stateSearchQuery.value = query;
  }

  void updateCollegeSearch(String query) {
    collegeSearchQuery.value = query;
  }

  void toggleStateDropdown() {
    stateDropdownOpen.toggle();
    collegeDropdownOpen.value = false;
  }

  void toggleCollegeDropdown() {
    if (selectedState.value != null) {
      collegeDropdownOpen.toggle();
      stateDropdownOpen.value = false;
    }
  }

  bool isAllDataSelected() {
    return selectedState.value != null && selectedCollege.value != null;
  }

  Map<String, dynamic> getSelectedCollegeData() {
    return selectedCollege.value?.toJson() ?? {};
  }
}

class CollegeData {
  final String id;
  final String name;
  final String state;
  final String district;
  final String website;

  CollegeData({
    required this.id,
    required this.name,
    required this.state,
    required this.district,
    required this.website,
  });

  factory CollegeData.fromList(List<dynamic> list) {
    return CollegeData(
      id: list[0].toString().trim(),
      name: list[1].toString().trim(),
      state: list[2].toString().trim(),
      district: list[3].toString().trim(),
      website: list[4].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'district': district,
      'website': website,
    };
  }
}
