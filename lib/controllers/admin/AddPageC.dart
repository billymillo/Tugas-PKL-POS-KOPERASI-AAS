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

class AddPageController extends GetxController {
  final ApiService apiService = ApiService();
  var url = ApiService.baseUrl + '/product';
  var urlRaw = ApiService.baseUrl;
  TextEditingController searchController = TextEditingController();

  var selectedTipe = Rxn<String>();
  var selectedKategori = Rxn<String>();
  var selectedMitra = Rxn<String>();
  var selectedBank = Rxn<String>();

  var selectedAddOn = <Map<String, dynamic>>[].obs;
  var imagePath = Rxn<File>();
  var imagePathK = Rxn<File>();
  var isPickingImage = false.obs;
  var isPickingImageK = false.obs;

  RxBool showMitra = true.obs;
  RxBool jumlahPcsPack = true.obs;
  RxBool hargaPack = true.obs;
  RxBool harga = true.obs;
  RxString hargaDasar = ''.obs;
  RxString totalLaba = ''.obs;

  var isLoading = false.obs;
  var produk = <Map<String, dynamic>>[].obs;
  var tipe = <Map<String, dynamic>>[].obs;
  var kategori = <Map<String, dynamic>>[].obs;
  var mitra = <Map<String, dynamic>>[].obs;
  var banks = <Map<String, dynamic>>[].obs;
  var addOn = <Map<String, dynamic>>[].obs;

  var filteredBank = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;

  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);
  Future<void> ProductP() async {
    Get.toNamed(Routes.ADDPRODUCTP);
  }

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
    fetchAddOn();
    fetchMitra();
    fetchTipe();
    fetchKategori();
    fetchBank();
  }

  String get KodeBank {
    var selected = banks.firstWhere(
      (m) => m['name'] == selectedBank.value,
      orElse: () => {'kode': '??'},
    );
    return selected['kode'] ?? 0;
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

  void hitungLaba(String hargaDasarText, String hargaJualText) {
    final hargaDasar = int.tryParse(hargaDasarText) ?? 0;
    final hargaJual = int.tryParse(hargaJualText.replaceAll('.', '')) ?? 1;

    if (hargaJual > 0) {
      totalLaba.value = (hargaJual - hargaDasar).toString();
    } else {
      totalLaba.value = '0';
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

  Future<void> fetchMitra() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/mitra"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == true) {
          mitra.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> fetchBank() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(urlRaw + "/bank"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          var bankData = List<Map<String, dynamic>>.from(jsonData['data']);
          banks.value = bankData;
        } else {
          banks.value = [];
        }
      } else {
        banks.value = [];
      }
    } catch (e) {
      print('Error fetching bank: $e');
      banks.value = [];
    } finally {
      isLoading(false);
    }
  }

  void searchBank(String query, List<Map<String, dynamic>> bankList) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredBank.assignAll(bankList);
    } else {
      filteredBank.assignAll(bankList.where((banks) {
        final nama = banks['nama'].toString().toLowerCase();
        final kode = banks['kode'].toString().toLowerCase();

        return nama.contains(query.toLowerCase()) ||
            kode.contains(query.toLowerCase());
      }).toList());
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredBank.assignAll([]);
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

  void selectAddOn(Map<String, dynamic> item) {
    final selectedItem = {
      'id': item['id'],
      'add_on': item['add_on'],
    };

    final exists = selectedAddOn.any((e) => e['id'] == item['id']);

    if (exists) {
      selectedAddOn.removeWhere((e) => e['id'] == item['id']);
      print('Hapus: $selectedAddOn');
    } else {
      selectedAddOn.add(selectedItem);
      print('Tambah: $selectedAddOn');
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

  Future<void> addProduct(
    String nama_barang,
    String barcode,
    File gambar_barang,
    String id_kategori_barang,
    String id_tipe_barang,
    String id_mitra_barang,
    String harga_pack,
    String jml_pcs_pack,
    String harga_satuan,
    String harga_jual,
    String stok,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    try {
      final response = await apiService.addProduk(
        nama_barang,
        barcode,
        gambar_barang,
        id_kategori_barang,
        id_tipe_barang,
        id_mitra_barang,
        harga_pack,
        jml_pcs_pack,
        harga_satuan,
        harga_jual,
        stok,
        userInput,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        Get.toNamed(Routes.PRODUCTP);
      } else if (response['status'] == false) {
        // String errorMessage = _parseErrorMessages(response['message']);
        Get.snackbar(
          'Error',
          'Lengkapi data produk',
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
    } else {
      Get.snackbar(
        'Error',
        'Harap pilih gambar terlebih dahulu!',
        backgroundColor: Colors.red.withOpacity(0.5),
        icon: Icon(Icons.crisis_alert, color: Colors.white),
      );
    }
  }

  Future<void> addNewTipe(String tipe) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response = await apiService.tipe(tipe, userInput);
      if (response['status'] == 'true') {
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

  Future<void> pickImageKategori() async {
    if (isPickingImageK.value) {
      return;
    }
    try {
      isPickingImageK.value = true;
      final pickerK = ImagePicker();
      final pickedFileK = await pickerK.pickImage(source: ImageSource.gallery);

      if (pickedFileK != null) {
        imagePathK.value = File(pickedFileK.path);
      } else {
        Get.snackbar(
          'Error',
          'Harap pilih gambar terlebih dahulu!',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.white),
        );
      }
    } finally {
      isPickingImageK.value = false; // Reset flag setelah proses selesai
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
        String errorMessage = _parseErrorMessages(response['message']);
        Get.snackbar(
          'Error',
          errorMessage,
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

  Future<void> addProdukAddOn(String idAddon) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response =
          await apiService.addProdukAddOnNewest(idAddon, userInput);
      if (response['status'] == true) {
        print('Success' + ' $response');
      } else if (response['status'] == false) {
        String errorMessage = _parseErrorMessages(response['message']);
        print('Error' + ' $errorMessage');
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

  Future<void> addNewAddOn(String addOn, String harga,
      {bool fromButton = false}) async {
    if (!fromButton) {
      return;
    }
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
      } else if (response['status'] == false) {
        String errorMessage = _parseErrorMessages(response['message']);
        Get.snackbar(
          'Error',
          errorMessage,
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

  String _parseErrorMessages(dynamic message) {
    if (message is Map) {
      return message.values.join("\n");
    }
    return message.toString();
  }

  Future<void> refresh() async {
    await fetchTipe();
    await fetchKategori();
    await fetchMitra();
    await fetchAddOn();
  }
}
