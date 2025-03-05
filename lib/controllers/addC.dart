import 'dart:convert';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddProductController extends GetxController {
  var tipe = <Map<String, dynamic>>[].obs; // Store dropdown items
  var selectedTipe = Rxn<String>(); // Store selected value
  var isLoading = false.obs;
  final ApiService apiService = ApiService();

  get productNameController => null;

  get productPriceController => null;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch dropdown data when controller initializes
  }

  /// Fetch data from API
  Future<void> fetchData() async {
    final url = ApiService.baseUrl;
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/product/tipe"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          tipe.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load products');
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

  /// Send selected value to API
  Future<void> addTipe() async {
    isLoading.value = true;
    try {
      final response = await apiService.tipe(selectedTipe.value!);
      if (selectedTipe.value == null) {
        Get.snackbar(
          'Error',
          response['message'],
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.error, color: Colors.white),
        );
      return;
      }
      print("Response from API: $response");
      if (response['status'] != true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar(
        'Error',
        'Tipe Tidak Boleh Kosong',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> addTipeText(String tipe) async {
    isLoading.value = true;
    try {
      final response = await apiService.tipe(tipe);
      print("Response dari API: $response");
      if (response['status'] == 'true') {
          Get.snackbar(
            'Success',
            'Tipe berhasil ditambahkan ke database!',
            backgroundColor: Colors.green.withOpacity(0.5),
            icon: Icon(Icons.check_circle, color: Colors.white),
          );
      } else {
        Get.snackbar(
          'Error',
          response['message'],
          backgroundColor: DarkColor().red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
      }
    } catch (e) {
      print("Error: $e");
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

}
