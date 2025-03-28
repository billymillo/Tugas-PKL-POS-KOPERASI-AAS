import 'dart:convert';

import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransaksiInMitraController extends GetxController {
  TextEditingController satuanMController = TextEditingController();
  TextEditingController searchMController = TextEditingController();
  TextEditingController jualMController = TextEditingController();

  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var isLoadingM = false.obs;
  var userData = {}.obs;
  var checkboxM = false.obs;
  var transaksiDetM = <Map<String, dynamic>>[].obs;
  var transaksiM = <Map<String, dynamic>>[].obs;
  var mitra = <Map<String, dynamic>>[].obs;
  var produkM = <Map<String, dynamic>>[].obs;
  RxString searchQueryM = ''.obs;
  var filteredProductM = <Map<String, dynamic>>[].obs;
  var selectedProductM = Rxn<String>();

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
    fetchProduk();
    fetchTransaksiDetMitra();
    fetchTransaksiInMitra();
    fetchMitra();
    ever(selectedProductM, (_) {
      satuanMController.text = ProdukSatuan;
      jualMController.text = ProdukJual;
    });
  }

  String ProdukNameM(String idProduk) {
    var selected = produkM.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'nama_barang': 'Pilih Produk'},
    );
    return selected['nama_barang'] ?? "Pilih Produk";
  }

  String ProdukStokM(String idProduk) {
    var selected = produkM.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'stok': 'Pilih Produk'},
    );
    return selected['stok'] ?? "Pilih Produk";
  }

  String ProdukNameMitra(String idProduk) {
    var selected = produkM.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'mitra_name': 'Pilih Produk'},
    );
    return selected['mitra_name'] ?? "Pilih Produk";
  }

  String get ProdukMitra {
    var selected = produkM.firstWhere(
      (m) => m['id'] == selectedProductM.value,
      orElse: () => {'id_mitra_barang': '  '},
    );
    return selected['id_mitra_barang'] ?? 0;
  }

  String NamaMitra(String idProduk) {
    var selected = produkM.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'mitra_name': 'Pilih Produk'},
    );
    return selected['mitra_name'] ?? "Pilih Produk";
  }

  String get ProdukSatuan {
    var selected = produkM.firstWhere(
      (m) => m['id'] == selectedProductM.value,
      orElse: () => {'harga_satuan': '  '},
    );
    return selected['harga_satuan'] ?? 0;
  }

  String get ProdukJual {
    var selected = produkM.firstWhere(
      (m) => m['id'] == selectedProductM.value,
      orElse: () => {'harga_jual': '  '},
    );
    return selected['harga_jual'] ?? 0;
  }

  String NoTransaksiM(String idProduk) {
    var selected = transaksiM.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'no_transaksi_in': ''},
    );
    return selected['no_transaksi_in'] ?? "";
  }

  void toggleCheckbox(bool? value) {
    checkboxM.value = value ?? false;
  }

  Future<void> fetchProduk() async {
    var url = ApiService.baseUrl + '/product';
    try {
      isLoadingM(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == true) {
          var allProducts = List<Map<String, dynamic>>.from(jsonData['data']);

          var filteredProductMs = allProducts
              .where((product) => product['id_tipe_barang'].toString() == '2')
              .toList();

          produkM.value = filteredProductMs;
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoadingM(false);
    }
  }

  Future<void> fetchTransaksiDetMitra() async {
    var url = ApiService.baseUrl + '/transaksi_mitra/detail';
    try {
      isLoadingM(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          var transaksiList = List<Map<String, dynamic>>.from(jsonData['data']);
          transaksiList.sort((a, b) {
            DateTime dateA = DateTime.parse(a['input_date']);
            DateTime dateB = DateTime.parse(b['input_date']);
            return dateB.compareTo(dateA); // Sort DESC
          });
          transaksiList
              .sort((a, b) => b['input_date'].compareTo(a['input_date']));

          transaksiDetM.value = transaksiList;
        } else {
          throw Exception('Failed to load transactions');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoadingM(false);
    }
  }

  Future<void> fetchTransaksiInMitra() async {
    var url = ApiService.baseUrl + '/transaksi_mitra';
    try {
      isLoadingM(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          transaksiM.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoadingM(false);
    }
  }

  Future<void> fetchMitra() async {
    var url = ApiService.baseUrl + '/product/mitra';
    try {
      isLoadingM(true);
      var response = await http.get(Uri.parse(url));
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
      isLoadingM(false);
    }
  }

  Future<void> addTransaksiInMitra(
    String mitra,
    String jumlah,
    String total,
    String status,
  ) async {
    isLoadingM.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiServiceTr.addTransaksiInMitra(
      mitra,
      jumlah,
      total,
      status,
      userInput,
    );
    try {
      if (response['status'] == 'true') {
        print('success: $response');
      } else if (response['status'] == 'false') {
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
      isLoadingM.value = false;
    }
  }

  Future<void> addDetTransaksiMitra(
    String idProduk,
    String jumlah,
    String hargaSatuan,
    String hargaJual,
  ) async {
    isLoadingM.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiServiceTr.addDetTransaksiMitra(
      idProduk,
      jumlah,
      hargaSatuan,
      hargaJual,
      userInput,
    );
    try {
      if (response['status'] == 'true') {
        Get.snackbar(
          'Berhasil',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (response['status'] == 'false') {
        Get.snackbar(
          'Gagal',
          response['message'],
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoadingM.value = false;
    }
  }

  Future<void> editProduk(
    String id,
    String stok,
    String hargaSatuan,
    String hargaJual,
  ) async {
    isLoadingM.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    try {
      final response = await apiServiceTr.editProduk(
          id, stok, hargaSatuan, hargaJual, userUpdate);
      if (response['status'] == true) {
        print("Edit Berhasil" + response['message']);
      } else {
        print("Edit Gagal" + response['message']);
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoadingM.value = false;
    }
  }

  void searchProduct(String query, List<Map<String, dynamic>> produkMList) {
    searchQueryM.value = query;
    if (query.isEmpty) {
      filteredProductM.assignAll(produkMList);
    } else {
      filteredProductM.assignAll(produkMList.where((produkM) {
        final nama = produkM['nama_barang'].toString().toLowerCase();
        final mitra = produkM['mitra_name'].toString().toLowerCase();
        return nama.contains(query.toLowerCase()) ||
            mitra.contains(query.toLowerCase());
      }).toList());
    }
  }

  void clearSearch() {
    searchMController.clear();
    searchQueryM.value = '';
    filteredProductM.assignAll([]);
  }
}
