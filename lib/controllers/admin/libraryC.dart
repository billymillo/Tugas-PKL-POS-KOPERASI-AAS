import 'dart:convert';
import 'dart:io';
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
import 'package:shared_preferences/shared_preferences.dart';

class LibraryController extends GetxController {
  final ApiService apiService = ApiService();
  var url = ApiService.baseUrl + '/product';

  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var urlTr = ApiServiceTr.baseUrlTr;

  var isLoading = false.obs;
  var tipe = <Map<String, dynamic>>[].obs;
  var kategori = <Map<String, dynamic>>[].obs;
  var mitra = <Map<String, dynamic>>[].obs;
  var addOn = <Map<String, dynamic>>[].obs;

  Rx<File?> imagePathK = Rx<File?>(null);
  var hasNewImage = false.obs;
  var imageUrl = Rxn<String>();
  var isPickingImageK = false.obs;

  var imagePathNewK = Rxn<File>();
  var isPickingImageNewK = false.obs;

  var member = <Map<String, dynamic>>[].obs;
  var metode = <Map<String, dynamic>>[].obs;
  static var poinToRupiah = 100.obs;
  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);
  Future<void> ProductP() async {
    Get.toNamed(Routes.ADDPRODUCTP);
  }

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
    fetchMitra();
    fetchKategori();
    fetchTipe();
    fetchMember();
    fetchMetode();
    fetchAddOn();
    konfersiPoin();
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

  Future<void> addNewMitra(String nama, String no_tlp, String email,
      String bank, String noRek, String namaRek,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response = await apiService.mitra(
          nama, no_tlp, email, bank, noRek, namaRek, userInput);
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
          'Tolong lengkapi data mitra',
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

  Future<void> deleteMitra(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final response = await apiService.deleteMitra(
        id,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editMitra(String id, String nama, String no_tlp, String email, String bank, String noRek, String namaRek,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiService.editMitra(
        id,
        nama,
        no_tlp,
        email,
        bank,
        noRek,
        namaRek,
        userUpdate,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
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

  Future<void> deleteTipe(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final response = await apiService.deleteTipe(
        id,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTipe(String tipe) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response = await apiService.tipe(tipe, userInput);
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
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

  Future<void> editTipe(String id, String tipe,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiService.editTipe(
        id,
        tipe,
        userUpdate,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
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

  Future<void> pickImageKategori() async {
    if (isPickingImageK.value) return;

    try {
      isPickingImageK.value = true;
      final pickerK = ImagePicker();
      final pickedFileK = await pickerK.pickImage(source: ImageSource.gallery);

      if (pickedFileK != null) {
        imagePathK.value = File(pickedFileK.path);
        hasNewImage.value = true; // Tandai bahwa ada gambar baru
      } else {
        Get.snackbar(
          'Error',
          'Harap pilih gambar terlebih dahulu!',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.white),
        );
      }
    } finally {
      isPickingImageK.value = false;
    }
  }

  Future<void> editKategori(String id, String kategori, dynamic gambar_kategori,
      {bool fromButton = false}) async {
    if (!fromButton) return;

    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiService.editKategori(
        id,
        kategori,
        hasNewImage.value ? imagePathK.value : null,
        userUpdate,
      );

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        hasNewImage.value = false;
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
        'Terjadi kesalahan saat mengedit Kategori.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteKategori(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final response = await apiService.deleteKategori(
        id,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Kategori.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImageKategoriNew() async {
    if (isPickingImageNewK.value) {
      return;
    }
    try {
      isPickingImageNewK.value = true;
      final pickerNewK = ImagePicker();
      final pickedFileNewK =
          await pickerNewK.pickImage(source: ImageSource.gallery);

      if (pickedFileNewK != null) {
        imagePathNewK.value = File(pickedFileNewK.path);
      } else {
        Get.snackbar(
          'Error',
          'Harap pilih gambar terlebih dahulu!',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.white),
        );
      }
    } finally {
      isPickingImageNewK.value = false; // Reset flag setelah proses selesai
    }
  }

  Future<void> addNewKategori(String kategori, File gambar_kategori) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response =
          await apiService.kategori(kategori, gambar_kategori, userInput);
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
          'Tolong lengkapi data kategori',
          backgroundColor: DarkColor().red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMember() async {
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse(urlTr + "/member"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          member.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addNewMember(
      String nama, String idPeg, String no_tlp, String saldo, String poin,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response = await apiServiceTr.member(
          nama, idPeg, no_tlp, saldo, poin, userInput);
      print("Response API: $response");
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (response['status'] == false) {
        print(response['message']);
        Get.snackbar(
          'Error',
          'Tolong lengkapi data Member',
          backgroundColor: DarkColor().red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
      }
    } catch (e) {
      print("Error saat request API: $e");
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

  Future<void> deleteMember(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final response = await apiServiceTr.deleteMember(
        id,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Member.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editMember(
      String id, String nama, String no_tlp, String saldo, String poin,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiServiceTr.editMember(
        id,
        nama,
        no_tlp,
        saldo,
        poin,
        userUpdate,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Member.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMetode() async {
    try {
      isLoading(true);
      var response =
          await http.get(Uri.parse(urlTr + "/transaksi_in/pembayaran"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          metode.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> deleteMetode(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final response = await apiServiceTr.deleteMetode(
        id,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMetode(String metode) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response = await apiServiceTr.metode(metode, userInput);
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
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

  Future<void> editMetode(String id, String metode,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiServiceTr.editMetode(id, metode, userUpdate);
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Metode Pembayaran.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> konfersiPoin() async {
    final prefs = await SharedPreferences.getInstance();
    poinToRupiah.value = prefs.getInt('poinConversion') ?? 100;
  }

  Future<void> simpanPoin(int newValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('poinConversion', newValue);
    poinToRupiah.value = newValue;

    Get.snackbar(
      'Berhasil',
      "Konversi poin diperbarui menjadi 1 Poin = Rp $newValue",
      backgroundColor: Colors.green.withOpacity(0.5),
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  Future<void> fetchAddOn() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(urlTr + "/addon"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          addOn.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> deleteAddOn(String id, {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    try {
      final response = await apiService.deleteAddOn(
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
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addAddOn(String addOn, String harga) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response = await apiService.addAddOn(addOn, harga, userInput);
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
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

  Future<void> editAddOn(String id, String addOn, String harga,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiService.editAddOn(
        id,
        addOn,
        harga,
        userUpdate,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
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
        'Terjadi kesalahan saat Menghapus Mitra.',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await fetchTipe();
    await fetchKategori();
    await fetchMitra();
    await fetchMetode();
    await fetchMember();
    await fetchAddOn();
  }
}
