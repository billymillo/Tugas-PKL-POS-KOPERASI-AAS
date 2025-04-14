import 'dart:convert';

import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransaksiInController extends GetxController {
  TextEditingController satuanController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController jualController = TextEditingController();

  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var isLoading = false.obs;
  var userData = {}.obs;
  var checkbox = false.obs;
  var transaksiDet = <Map<String, dynamic>>[].obs;
  var transaksi = <Map<String, dynamic>>[].obs;
  var produk = <Map<String, dynamic>>[].obs;
  RxString searchQuery = ''.obs;
  var filteredProduct = <Map<String, dynamic>>[].obs;
  var selectedProduct = Rxn<String>();

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
    fetchProduk();
    fetchTransaksiDet();
    fetchTransaksiIn();
    ever(selectedProduct, (_) {
      satuanController.text = ProdukSatuan;
      jualController.text = ProdukJual;
    });
  }

  String ProdukName(String idProduk) {
    var selected = produk.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'nama_barang': 'Pilih Produk'},
    );
    return selected['nama_barang'] ?? "Pilih Produk";
  }

  String ProdukStok(String idProduk) {
    var selected = produk.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'stok': 'Pilih Produk'},
    );
    return selected['stok'] ?? "Pilih Produk";
  }

  String NoTransaksi(String idProduk) {
    var selected = transaksi.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'no_transaksi_in': ''},
    );
    return selected['no_transaksi_in'] ?? "";
  }

  String get ProdukSatuan {
    var selected = produk.firstWhere(
      (m) => m['id'] == selectedProduct.value,
      orElse: () => {'harga_satuan': '  '},
    );
    return selected['harga_satuan'] ?? 0;
  }

  String get ProdukJual {
    var selected = produk.firstWhere(
      (m) => m['id'] == selectedProduct.value,
      orElse: () => {'harga_jual': '  '},
    );
    return selected['harga_jual'] ?? 0;
  }

  void toggleCheckbox(bool? value) {
    checkbox.value = value ?? false;
  }

  Future<void> fetchProduk() async {
    var url = ApiService.baseUrl + '/product';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == true) {
          var allProducts = List<Map<String, dynamic>>.from(jsonData['data']);

          var filteredProducts = allProducts
              .where((product) => product['id_tipe_barang'].toString() == '1')
              .toList();

          produk.value = filteredProducts;
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

  Future<void> fetchTransaksiDet() async {
    var url = ApiService.baseUrl + '/transaksi_in/detail';
    try {
      isLoading(true);
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

          transaksiDet.value = transaksiList;
        } else {
          throw Exception('Failed to load transactions');
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


  Future<void> fetchTransaksiIn() async {
    var url = ApiService.baseUrl + '/transaksi_in';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          transaksi.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> addTransaksiIn(
    String jumlah,
    String total,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiServiceTr.addTransaksiIn(
      jumlah,
      total,
      userInput,
    );
    try {
      if (response['status'] == 'true') {
        print('success: $response');
      } else if (response['status'] == 'false') {
        print('error message: $response');
      }
    } catch (e) {
      print('error $e');
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

  Future<void> addDetTransaksiIn(
    String idProduk,
    String jumlah,
    String hargaSatuan,
    String hargaJual,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiServiceTr.addDetTransaksiIn(
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
      isLoading.value = false;
    }
  }

  Future<void> tambahStok(
    String id,
    String stok,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    try {
      final response = await apiServiceTr.tambahStok(id, stok, userUpdate);
      if (response['status'] == true) {
        print("TambahStok Berhasil" + response['message']);
      } else {
        print("TambahStok Gagal" + response['message']);
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
      isLoading.value = false;
    }
  }

  Future<void> duplikatProduk(
    String id,
    String stok,
    String hargaSatuan,
    String hargaJual,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';

    try {
      final response = await apiServiceTr.duplikatProduk(
          id, stok, hargaSatuan, hargaJual, userInput);
      if (response['status'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
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
      isLoading.value = false;
    }
  }

  void searchProduct(String query, List<Map<String, dynamic>> produkList) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProduct.assignAll(produkList);
    } else {
      filteredProduct.assignAll(produkList.where((produk) {
        final nama = produk['nama_barang'].toString().toLowerCase();
        return nama.contains(query.toLowerCase());
      }).toList());
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredProduct.assignAll([]);
  }
}
