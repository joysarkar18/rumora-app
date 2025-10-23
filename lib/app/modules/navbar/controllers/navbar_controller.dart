import 'package:campus_crush_app/app/modules/chats/views/chats_view.dart';
import 'package:campus_crush_app/app/modules/crush/views/crush_view.dart';
import 'package:campus_crush_app/app/modules/explore/views/explore_view.dart';
import 'package:campus_crush_app/app/modules/home/views/home_view.dart';
import 'package:campus_crush_app/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  final selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

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
}
