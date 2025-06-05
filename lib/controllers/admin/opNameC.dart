import 'dart:convert';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpNameController extends GetxController {
  final ApiService apiService = ApiService();
  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var url = ApiService.baseUrl;
  var isLoading = false.obs;
  var opname = <Map<String, dynamic>>[].obs;
  var opnameDet = <Map<String, dynamic>>[].obs;
  var status = <Map<String, dynamic>>[].obs;

  var selectedJenis = 0.obs;

  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);

  @override
  void onInit() {
    super.onInit();
    fetchOpName();
    fetchStatus();
    fetchDetOpName();
    WidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('id_ID', null);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  String statusName(String idStatus) {
    var selected = status.firstWhere(
      (m) => m['id'].toString() == idStatus,
      orElse: () => {'status': ' '},
    );
    return selected['status'] ?? " ";
  }

  Future<void> fetchOpName() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/opname"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          List<Map<String, dynamic>> sortedData =
              List<Map<String, dynamic>>.from(jsonData['data'])
                ..sort((a, b) => int.parse(b['id'].toString())
                    .compareTo(int.parse(a['id'].toString())));
          opname.value = sortedData;
        } else {
          throw Exception('Failed to load opname');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDetOpName() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/opname/detail"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          opnameDet.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load opname');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchStatus() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/status"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          status.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load status');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addOpname(
    String status,
    String tipeOpname,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiService.addOpname(
      status,
      tipeOpname,
      userInput,
    );
    try {
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (response['status'] == false) {
        Get.snackbar(
          'Error',
          'Error Saat Menambahkan Opname',
          backgroundColor: DarkColor().red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editOpname(
    String Id,
    String status,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    final response = await ApiService.editOpname(
      Id,
      status,
      userUpdate,
    );
    try {
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (response['status'] == false) {
        Get.snackbar(
          'Selesai',
          'Opname Sudah Pernah Disimpan',
          backgroundColor: Colors.blue.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
        print('error message: $response');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
