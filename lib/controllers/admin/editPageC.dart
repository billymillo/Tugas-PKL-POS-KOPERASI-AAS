import 'dart:convert';
import 'dart:io';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:image_picker/image_picker.dart';

class EditPageController extends GetxController {
  final ApiService apiService = ApiService();
  var url = ApiService.baseUrl + '/product';

  var selectedTipe = Rxn<String>();
  var selectedKategori = Rxn<String>();
  var selectedMitra = Rxn<String>();

  var imagePath = Rxn<File>();
  var imagePathK = Rxn<File>();
  var isPickingImage = false.obs;
  var hasNewImage = false.obs;
  var imageUrl = Rxn<String>();

  var showMitra = true.obs;
  var isLoading = false.obs;
  var produk = <Map<String, dynamic>>[].obs;
  var tipe = <Map<String, dynamic>>[].obs;
  var kategori = <Map<String, dynamic>>[].obs;
  var mitra = <Map<String, dynamic>>[].obs;

  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);
  Future<void> ProductP() async {
    Get.toNamed(Routes.ADDPRODUCTP);
  }

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
  }

  void goToEditProductPage(Map<String, dynamic> item) {
    Get.toNamed(
      Routes.EDITPRODUCTP,
      arguments: item, // Kirim data produk ke halaman edit
    );
  }

  Future<void> fetchMitra() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/mitra"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          var mitraData = List<Map<String, dynamic>>.from(jsonData['data']);
          mitra.value = mitraData;
        } else {
          mitra.value = [];
        }
      } else {
        mitra.value = [];
      }
    } catch (e) {
      print('Error fetching mitra: $e');
      mitra.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTipe() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/tipe"));
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

  Future<void> fetchKategori() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/kategori"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          kategori.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> editProduct(
      String id,
      String nama_barang,
      dynamic gambar_barang,
      String id_kategori_barang,
      String id_tipe_barang,
      String id_mitra_barang,
      String harga_pack,
      String jml_pcs_pack,
      String harga_satuan,
      String harga_jual,
      String stok,
      {bool fromButton = false}) async {
    if (!fromButton) return;

    isLoading.value = true;

    Get.dialog(
      Center(
          child: CircularProgressIndicator(
        color: PrimaryColor().blue,
      )),
      barrierDismissible: false,
    );

    try {
      final response = await apiService.editProduk(
        id,
        nama_barang,
        hasNewImage.value ? imagePath.value : null,
        id_kategori_barang,
        id_tipe_barang,
        id_mitra_barang,
        harga_pack,
        jml_pcs_pack,
        harga_satuan,
        harga_jual,
        stok,
      );

      if (response['status'] == true) {
        Get.back(); // Tutup loading dialog
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );

        Future.delayed(Duration(milliseconds: 300), () {
          Get.offNamed(Routes.PRODUCTP);
        });
      } else {
        Get.back(); // Tutup loading dialog jika gagal
        Get.snackbar(
          'Error',
          'Gagal mengedit produk: ${response['message']}',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      Get.back(); // Pastikan loading tertutup saat error terjadi
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat mengedit produk.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    if (isPickingImage.value) {
      return;
    }

    try {
      isPickingImage.value = true;
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imagePath.value = File(pickedFile.path);
        hasNewImage.value = true;
        update();
      } else {
        Get.snackbar(
          'Error',
          'Harap pilih gambar terlebih dahulu!',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.white),
        );
      }
    } finally {
      isPickingImage.value = false; // Reset flag setelah proses selesai
    }
  }

  Future<void> pickImageCam() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imagePath.value = File(pickedFile.path);
      hasNewImage.value = true;
      update();
    } else {
      Get.snackbar(
        'Error',
        'Harap pilih gambar terlebih dahulu!',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.crisis_alert, color: Colors.white),
      );
    }
  }

  Future<void> refresh() async {
    await fetchMitra();
  }
}
