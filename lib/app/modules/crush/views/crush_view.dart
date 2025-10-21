import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/crush_controller.dart';

class CrushView extends GetView<CrushController> {
  const CrushView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('CrushView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
