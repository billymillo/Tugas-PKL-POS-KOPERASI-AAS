import 'dart:convert';

import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransaksiC extends GetxController {
  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var urlTr = ApiServiceTr.baseUrlTr;
  var isLoading = true.obs;
  var checkboxList = <bool>[].obs;

  var detailTransaksi = RxList<Map<String, dynamic>>([]);
  var detailTr = <Map<String, dynamic>>[].obs;
  var transaksiLunas = <Map<String, dynamic>>[].obs;
  var allTransaksiLunas = <Map<String, dynamic>>[].obs;
  var member = <Map<String, dynamic>>[].obs;
  var memberTransaksi = <String>[].obs;
  RxList<Map<String, dynamic>> allKasbon = <Map<String, dynamic>>[].obs;
  var kasbon = <Map<String, dynamic>>[].obs;
  var kasbonDet = <Map<String, dynamic>>[].obs;
  var produkDetail = <Map<String, dynamic>>[].obs;
  var metodePem = <Map<String, dynamic>>[].obs;

  var isLoadingLunas = false.obs;
  var isLastPageLunas = false.obs;
  var pageLunas = 1.obs;
  var limitLunas = 10;

  RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;

  String MemberName(String idMember) {
    var selected = member.firstWhere(
      (m) => m['id'].toString() == idMember,
      orElse: () => {'nama': 'Non Member'},
    );
    return selected['nama'] ?? "Non Member";
  }

  String ProdukName(String idProduk) {
    var selected = produkDetail.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'nama_barang': 'Tidak Ada'},
    );
    return selected['nama_barang'] ?? "Tidak Ada";
  }

  String MetodeName(String idMetode) {
    var selected = metodePem.firstWhere(
      (m) => m['id'].toString() == idMetode,
      orElse: () => {'metode': 'Tidak Ada'},
    );
    return selected['metode'] ?? "Tidak Ada";
  }

  String totalKasbon(String idTransaksi) {
    var selected = kasbonDet.firstWhere(
      (m) => m['id_transaksi_out'].toString() == idTransaksi,
      orElse: () => {'total_kasbon': '0'},
    );
    return selected['total_kasbon'] ?? "0";
  }

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    fetchTransaksiLunas();
    fetchMember();
    fetchTransaksiDetail();
    loadMoreTransaksiLunas();
    fetchKasbon();
    fetchKasbonDetail();
    fetchMetode();
    initializeCheckboxList();

    super.onInit();
  }

  void initializeCheckboxList() {
    if (kasbon.isNotEmpty) {
      checkboxList.assignAll(List.generate(kasbon.length, (index) => false));
    }
  }

  void toggleCheckbox(int index, bool? value) {
    if (value != null && index < checkboxList.length) {
      checkboxList[index] = value;
    }
  }

  Future<void> fetchTransaksiLunas({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isLoadingLunas(true);
      } else {
        isLoading(true);
      }

      var response = await http.get(
        Uri.parse(
            '$urlTr/transaksi_out?page=${pageLunas.value}&limit=$limitLunas'),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == true) {
          var transaksiList = (jsonData['data'] as List)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();

          var detailList = transaksiList
              .expand((item) => item['detail_transaksi'] as List)
              .cast<Map<String, dynamic>>()
              .toList();

          for (var item in transaksiList) {
            item.remove('detail_transaksi');
          }

          var memberList = transaksiList
              .map((item) => item['id_member'].toString())
              .where((id) => id.isNotEmpty)
              .toSet()
              .toList();

          if (isLoadMore) {
            transaksiLunas.addAll(transaksiList);
            allTransaksiLunas.addAll(transaksiList);
            detailTr.addAll(detailList);
            memberTransaksi.addAll(memberList);
            memberTransaksi.value = memberTransaksi.toSet().toList();
          } else {
            transaksiLunas.value = transaksiList;
            allTransaksiLunas.value = transaksiList;
            detailTr.value = detailList;
            memberTransaksi.value = memberList;
          }

          if (transaksiList.isEmpty) {
            isLastPageLunas(true);
          }
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
      isLoadingLunas(false);
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

  Future<void> fetchTransaksiDetail() async {
    try {
      isLoading.value = true;
      var response =
          await http.get(Uri.parse(urlTr + "/transaksi_out/detail?produk=1"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          produkDetail.value =
              List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> fetchKasbon() async {
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse(urlTr + "/kasbon"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          var kasbonList = List<Map<String, dynamic>>.from(jsonData['data']);
          kasbon.value = kasbonList;
          allKasbon.value = kasbonList;

          // Initialize checkboxList here after kasbon is updated
          initializeCheckboxList();
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

  Future<void> fetchKasbonDetail() async {
    try {
      isLoading.value = true;
      var response =
          await http.get(Uri.parse(urlTr + "/kasbon/detail?kasbon=1"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          kasbonDet.value = List<Map<String, dynamic>>.from(jsonData['data']);
          detailTransaksi.clear();
          for (var kasbon in kasbonDet) {
            var transaksiDetail = kasbon['detail_transaksi'];
            if (transaksiDetail.isNotEmpty) {
              detailTransaksi
                  .addAll(List<Map<String, dynamic>>.from(transaksiDetail));
            }
          }
        } else {
          kasbonDet.clear();
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

  Future<void> pembayaranKasbon(
    String idKasbon,
    String totalBayar,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    try {
      final response = await ApiServiceTr.pemKasbon(
        idKasbon,
        totalBayar,
        userUpdate,
      );
      if (response['status'] == 'true') {
        Get.snackbar(
          'Berhasil',
          'Kasbon Anda telah dilunasi, pembayaran berhasil diselesaikan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        print('Gagal' + response['message']);
      } else if (response['status'] == 'false') {
        Get.snackbar(
          'Gagal',
          response['message'],
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
        print('Gagal' + response['message']);
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

  Future<void> lunasKasbon(
    String id,
    String totalKasbon,
    String statusTr,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    try {
      final response = await apiServiceTr.lunasKasbon(
        id,
        totalKasbon,
        statusTr,
        userUpdate,
      );
      if (response['status'] == true) {
        print('Response True' + response['message']);
      } else {
        print('Response False' + response['message']);
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

  Future<void> deleteKasbon(String id) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    try {
      final response = await apiServiceTr.deleteKasbon(id, userUpdate);
      if (response['status'] == true) {
        print('Response True Kasbon Delete' + '$response');
      } else {
        print('Response False Kasbon Delete' + '$response');
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

  Future<void> pembayaranMultipleKasbon(
      List<Map<String, dynamic>> selectedKasbons) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';

    try {
      // Track successful and failed payments
      List<String> successfulPayments = [];
      List<String> failedPayments = [];

      // Process each selected kasbon
      for (var kasbon in selectedKasbons) {
        try {
          final response = await ApiServiceTr.pemKasbon(
            kasbon['id'].toString(),
            kasbon['total_kasbon'].toString(),
            userUpdate,
          );

          if (response['status'] == 'true') {
            // Successfully paid kasbon
            successfulPayments.add(kasbon['id'].toString());

            // Lunas Kasbon
            await lunasKasbon(
              kasbon['id'].toString(),
              kasbon['total_kasbon'].toString(),
              '1',
            );

            // Delete Kasbon
            await deleteKasbon(kasbon['id'].toString());
          } else {
            // Failed to pay kasbon
            failedPayments.add(kasbon['id'].toString());
          }
        } catch (e) {
          failedPayments.add(kasbon['id'].toString());
          print('Error processing kasbon ${kasbon['id']}: $e');
        }
      }

      // Refresh data
      await fetchKasbon();
      await fetchKasbonDetail();
      await fetchTransaksiLunas();
      await fetchTransaksiDetail();

      // Show summary snackbar
      if (successfulPayments.isNotEmpty) {
        Get.snackbar(
          'Berhasil',
          'Kasbon berhasil dilunasi untuk ${successfulPayments.length} pembayaran',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      }

      if (failedPayments.isNotEmpty) {
        Get.snackbar(
          'Gagal',
          'Pembayaran gagal untuk ${failedPayments.length} kasbon',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
      }

      // Reset checkboxes
      checkboxList.value = List.generate(kasbon.length, (index) => false);
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan saat memproses pembayaran',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

// Add a method to get selected kasbons
  List<Map<String, dynamic>> getSelectedKasbons() {
    List<Map<String, dynamic>> selectedKasbons = [];
    for (int i = 0; i < kasbon.length; i++) {
      if (checkboxList[i]) {
        selectedKasbons.add(kasbon[i]);
      }
    }
    return selectedKasbons;
  }

  Future<void> fetchMetode() async {
    try {
      isLoading.value = true;
      var response =
          await http.get(Uri.parse(urlTr + "/transaksi_in/pembayaran"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          metodePem.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          metodePem.clear();
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

  void searchTransaksi(String query) {
    if (query.isEmpty) {
      transaksiLunas.value = allTransaksiLunas;
    } else {
      limitLunas = 500;
      transaksiLunas.value = allTransaksiLunas
          .where((item) =>
              item['no_transaksi_out']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              MemberName(item['id_member'].toString())
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              MetodeName(item['id_metode_pembayaran'].toString())
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
  }

  void searchKasbon(String query) {
    if (query.isEmpty) {
      kasbon.value = allKasbon;
    } else {
      kasbon.value = allKasbon
          .where((item) => MemberName(item['id_member'].toString())
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> loadMoreTransaksiLunas() async {
    if (isLoadingLunas.value || isLastPageLunas.value) return;
    pageLunas.value++;
    await fetchTransaksiLunas(isLoadMore: true);
  }

  void resetPageLunas() {
    pageLunas.value = 1;
    isLastPageLunas.value = false;
    fetchTransaksiLunas();
  }

  Future<void> refresh() async {
    pageLunas.value = 1;
    isLastPageLunas(false);
    isLoading(true);
    await fetchKasbonDetail();
    await fetchKasbon();
    await fetchTransaksiLunas();
    await fetchTransaksiDetail();
  }
}
