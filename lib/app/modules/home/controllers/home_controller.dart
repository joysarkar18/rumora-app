import 'package:campus_crush_app/app/data/models/post_model.dart';
import 'package:campus_crush_app/app/modules/navbar/controllers/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final selectedTab = 0.obs;
  final selectedFilter = ''.obs;

  final UserController _userController = Get.put(UserController());

  final List<String> filterOptions = [
    'Most Liked',
    'Most Commented',
    'Most Viewed',
  ];

  RxList<PostModel> posts = <PostModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getInitData();
    super.onInit();
  }

  Future<void> getInitData() async {
    try {
      isLoading.value = true;
      await _userController.fetchUser();
      final data = await FirebaseFirestore.instance
          .collection("posts")
          .where(
            "college.id",
            isEqualTo: _userController.user.value?.college.id,
          )
          .get();
      if (data.docs.isNotEmpty) {
        List<PostModel> allPosts = data.docs
            .map((e) => PostModel.fromFirestoreSnapshot(e))
            .toList();

        posts.value = allPosts;
      }

      isLoading.value = false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error while getting posts!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  void selectTab(int index) {
    selectedTab.value = index;
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }
}
