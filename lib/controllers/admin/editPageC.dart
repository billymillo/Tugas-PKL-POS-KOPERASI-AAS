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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPageController extends GetxController {
  final ApiService apiService = ApiService();
  var url = ApiService.baseUrl + '/product';
  var urlRaw = ApiService.baseUrl;

  var selectedTipe = Rxn<String>();
  var selectedKategori = Rxn<String>();
  var selectedMitra = Rxn<String>();
  var selectedAddOn = <Map<String, dynamic>>[].obs;

  var imagePath = Rxn<File>();
  var imagePathK = Rxn<File>();
  var isPickingImage = false.obs;
  var hasNewImage = false.obs;
  var imageUrl = Rxn<String>();

  var showMitra = true.obs;
  RxBool jumlahPcsPack = true.obs;
  RxBool hargaPack = true.obs;
  RxBool harga = true.obs;
  RxString hargaDasar = ''.obs;

  var isLoading = false.obs;
  var produk = <Map<String, dynamic>>[].obs;
  var tipe = <Map<String, dynamic>>[].obs;
  var kategori = <Map<String, dynamic>>[].obs;
  var mitra = <Map<String, dynamic>>[].obs;
  var addOn = <Map<String, dynamic>>[].obs;
  var addOnPr = <Map<String, dynamic>>[].obs;

  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);
  Future<void> ProductP() async {
    Get.toNamed(Routes.ADDPRODUCTP);
  }

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
    fetchAddonPr();
    fetchMitra();
    fetchTipe();
    fetchKategori();
  }

  void goToEditProductPage(Map<String, dynamic> item) {
    Get.toNamed(
      Routes.EDITPRODUCTP,
      arguments: item, // Kirim data produk ke halaman edit
    );
  }

  String AddonName(String idProduk) {
    var selected = addOn.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'add_on': '1'},
    );
    return selected['add_on'] ?? "1";
  }

  void selectAddOn(Map<String, dynamic> item) {
    final index = selectedAddOn.indexWhere((e) => e['id'] == item['id']);
    if (index >= 0) {
      selectedAddOn.removeAt(index);
    } else {
      selectedAddOn.add(item);
    }
  }

  String formatRupiah(String value) {
    final number = int.tryParse(value) ?? 0;
    return NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number);
  }

  void hitungHargaDasar(String hargaPackText, String jumlahIsiText) {
    final hargaPack = int.tryParse(hargaPackText.replaceAll('.', '')) ?? 0;
    final jumlahIsi = int.tryParse(jumlahIsiText.replaceAll('.', '')) ?? 1;

    if (jumlahIsi > 0) {
      hargaDasar.value = (hargaPack ~/ jumlahIsi).toString();
    } else {
      hargaDasar.value = '0';
    }
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

  Future<void> fetchAddOn() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(urlRaw + "/addon"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          addOn.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load add-on');
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

  Future<void> fetchAddonPr() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(urlRaw + "/addon/produk"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          addOnPr.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> addProdukAddOn(String idAddon, String idProduk) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInputQ = prefs.getString('name') ?? 'system';
      final response =
          await apiService.addProdukAddOnOld(idAddon, idProduk, userInputQ);
      if (response['status'] == true) {
        print('Success' + ' $response');
      } else if (response['status'] == false) {
        print('Error' + ' $response');
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

  Future<void> deleteProdukAddOn(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    try {
      final response = await apiService.deleteProdukAddOn(
        id,
        userUpdate,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        print('error ${response['message']}');
      } else {
        Get.snackbar(
          'Error',
          '${response['message']}',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.error, color: Colors.white),
        );
        print('error ${response['message']}');
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> filteredAddOnByProduk(String idProduk) {
    return addOn.where((item) {
      final id = item['id'];
      final exists = addOnPr
          .any((pr) => pr['id_add_on'] == id && pr['id_produk'] == idProduk);
      return !exists;
    }).toList();
  }

  Future<void> editProduct(
      String id,
      String nama_barang,
      dynamic gambar_barang,
      String id_kategori_barang,
      String id_tipe_barang,
      String id_mitra_barang,
      String id_add_on,
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
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiService.editProduk(
          id,
          nama_barang,
          hasNewImage.value ? imagePath.value : null,
          id_kategori_barang,
          id_tipe_barang,
          id_mitra_barang,
          id_add_on,
          harga_pack,
          jml_pcs_pack,
          harga_satuan,
          harga_jual,
          stok,
          userUpdate);

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
    await fetchAddOn();
    await fetchAddonPr();
  }
}
