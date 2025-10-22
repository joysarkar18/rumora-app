import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  final selectedTab = 0.obs;
  final selectedFilter = ''.obs;

  final List<String> filterOptions = [
    'Most Liked',
    'Most Commented',
    'Most Viewed',
  ];

  @override
  void onInit() {
    super.onInit();
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
