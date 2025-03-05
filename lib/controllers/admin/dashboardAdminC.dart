import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DashbaordAdminC extends GetxController {
  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
  }
}
