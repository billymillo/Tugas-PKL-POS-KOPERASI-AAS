import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidationC extends GetxController {
  var isLogin = false.obs; // Status login
  var role = "".obs;

  @override
  void onInit() {
    super.onInit();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Future.delayed(2.seconds, () => checkLoginStatus());
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getInt('is_login') == 1;
    role.value = prefs.getString('role') ?? '';
    if (isLogin.value) {
      if (role.value == 'admin') {
        Get.offNamed(Routes.DASHBOARDADMINP);
      } else {
        Get.offNamed(Routes.LOCKDEVICEP);
        // Get.offNamed(Routes.KASIRP);
      }
    } else {
      Get.offNamed(Routes.LOGINP);
    }
  }

  Future<void> setLoginStatus(bool status, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('is_login', status ? 1 : 0);
    await prefs.setString('role', role);
  }
}
