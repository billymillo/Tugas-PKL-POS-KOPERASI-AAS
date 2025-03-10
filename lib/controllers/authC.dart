import 'package:bluetooth_thermal_printer_example/controllers/validationC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final ApiService apiService = ApiService();
  final ValidationC validationC = ValidationC();

  var isLoading = false.obs;
  var userData = {}.obs;

  // Fungsi login
  Future<void> login(String name, String password) async {
    isLoading.value = true;
    try {
      final response = await apiService.login(name, password);
      if (response['status'] == true) {
        validationC.setLoginStatus(true, response['role'], response['name']);
        if (response['role'] == 'admin') {
          Get.offNamed(Routes.DASHBOARDADMINP);
        } else {
          Get.offNamed(Routes.LOCKDEVICEP);
          // Get.offNamed(Routes.KASIRP);
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'],
          backgroundColor: DarkColor().red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: DarkColor().red.withOpacity(0.5),
        icon: Icon(Icons.crisis_alert, color: Colors.black),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_login');
    await prefs.remove('user_name');

    Get.offAllNamed(Routes.LOGINP);
  }
}
