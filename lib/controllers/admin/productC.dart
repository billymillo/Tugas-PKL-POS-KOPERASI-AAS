import 'dart:convert';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  var tipe = <Map<String, dynamic>>[].obs;
  var kategori = <Map<String, dynamic>>[].obs;
  var mitra = <Map<String, dynamic>>[].obs;

  var selectedTipe = Rxn<String>();
  var selectedKategori = Rxn<String>();
  var selectedMitra = Rxn<String>();

  final ApiService apiService = ApiService();
  var url = ApiService.baseUrl + '/product';
  ScrollController scrollController = ScrollController();

  var isLoading = false.obs;
  var produk = <Map<String, dynamic>>[].obs;

  var isLastPage = false.obs;
  var page = 1.obs;
  final int limit = 10;

  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);

  @override
  void onInit() {
    super.onInit();
    fetchProduk();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadMoreProducts();
      }
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void goToEditProductPage(Map<String, dynamic> item) {
    Get.toNamed(
      Routes.EDITPRODUCTP,
      arguments: item, // Kirim data produk ke halaman edit
    );
  }

  Future<void> fetchProduk() async {
    try {
      isLoading(true);
      var response =
          await http.get(Uri.parse('$url/produk?page=$page&limit=$limit'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          var newProduk = List<Map<String, dynamic>>.from(jsonData['data']);

          if (newProduk.length < limit) {
            isLastPage(true);
          }
          if (page.value == 1) {
            produk.value = newProduk;
          } else {
            produk.addAll(newProduk);
          }
        } else {
          throw Exception('Gagal mengambil data produk');
        }
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoading.value || isLastPage.value) return;
    page.value++;
    await fetchProduk();
  }

  Future<void> refresh() async {
    page.value = 1;
    isLastPage(false);
    isLoading(true);

    var response =
        await http.get(Uri.parse('$url/produk?page=$page&limit=$limit'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == true) {
        var newProduk = List<Map<String, dynamic>>.from(jsonData['data']);
        if (newProduk.length < limit) {
          isLastPage(true);
        }
        produk.value = newProduk;
      } else {
        throw Exception('Gagal mengambil data produk');
      }
    } else {
      throw Exception('Gagal load data');
    }
    isLoading(false);
  }
  

  Future<void> delete(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final response = await apiService.deleteProduk(
        id,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        Get.toNamed(Routes.PRODUCTP);
      } else {
        Get.snackbar(
          'Error',
          '${response['message']}',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat Menghapus produk.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      fetchProduk();
    }
    produk.value = produk
        .where((product) =>
            product['nama_barang']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            product['kategori_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            product['tipe_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            product['mitra_name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }
}
