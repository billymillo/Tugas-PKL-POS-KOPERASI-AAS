import 'dart:convert';

import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var isLoading = false.obs;
  var allTransaksiOut = <Map<String, dynamic>>[].obs;
  var transaksiOut = <Map<String, dynamic>>[].obs;
  var transaksiOutDet = <Map<String, dynamic>>[].obs;
  var transaksiInDet = <Map<String, dynamic>>[].obs;
  var transaksi = <Map<String, dynamic>>[].obs;
  var produk = <Map<String, dynamic>>[].obs;

  var totalItem = 0.obs;
  var totalProduk = 0.obs;
  final totalQRIS = 0.obs;
  final totalCash = 0.obs;
  final member = 0.obs;
  final nonMember = 0.obs;
  var totalHarga = 0.obs;
  var totalTransaksiIn = 0.obs;
  var totalKasbon = 0.obs;

  var selectedYear = 2025.obs;
  var selectedMonth = 'Maret'.obs;

  final RxList<FlSpot> _produkChartSpots = <FlSpot>[].obs;
  List<FlSpot> get produkChartSpots => _produkChartSpots;

  final RxList<String> _produkLabels = <String>[].obs;
  List<String> get produkChartLabels => _produkLabels;

  final RxList<String> _pendapatanLabels = <String>[].obs;
  List<String> get pendapatanChartLabels => _pendapatanLabels;

  final RxList<String> _transaksiLabels = <String>[].obs;
  List<String> get transaksiChartLabels => _transaksiLabels;

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    initializeDateFormatting('id_ID', null);
    super.onInit();
    fetchTransaksiOut();
    fetchTransaksiOutDet();
    fetchProduk();
    fetchTransaksiInDet();
    fetchTransaksiIn();
    updateChartData();
  }

  void selectYear(int year) {
    selectedYear.value = year;
    updateChartData();
  }

  void selectMonth(String month) {
    selectedMonth.value = month;
    updateChartData();
  }

  String ProdukName(String idProduk) {
    var selected = produk.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'nama_barang': 'Produk Tidak Ditemukan'},
    );
    return selected['nama_barang'] ?? "Produk Tidak Ditemukan";
  }

  String GambarBarang(String idProduk) {
    var selected = produk.firstWhere(
      (m) => m['id'].toString() == idProduk,
      orElse: () => {'gambar_barang': 'Produk Tidak Ditemukan'},
    );
    return selected['gambar_barang'] ?? "Produk Tidak Ditemukan";
  }

  String NoTransaksi(String idTransaksi) {
    var selected = transaksiOut.firstWhere(
      (m) => m['id'].toString() == idTransaksi,
      orElse: () => {'no_transaksi_out': ''},
    );
    return selected['no_transaksi_out'] ?? "";
  }

  void updateChartData() {
    final Map<String, int> grouped = {};
    final int year = selectedYear.value;
    final int month =
        DateFormat('MMM', 'id_ID').parse(selectedMonth.value).month;

    for (var item in transaksiOut) {
      final date = DateTime.tryParse(item['input_date'] ?? '');
      if (date != null && date.year == year && date.month == month) {
        final key = DateFormat('dd').format(date);
        final jumlah = int.tryParse(item['jumlah_produk'].toString()) ?? 0;
        grouped.update(key, (val) => val + jumlah, ifAbsent: () => jumlah);
      }
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
    _produkLabels.value = sortedKeys;

    _produkChartSpots.value = List.generate(sortedKeys.length, (index) {
      final jumlah = grouped[sortedKeys[index]]!;
      return FlSpot(index.toDouble(), jumlah.toDouble());
    });
  }

  Future<void> fetchTransaksiOut() async {
    var url = ApiService.baseUrl + '/transaksi_out';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          List<Map<String, dynamic>> data =
              List<Map<String, dynamic>>.from(jsonData['data']);
          transaksiOut.value = data;
          totalItem.value = data.length;

          int jumlah = 0;
          int qrisTotal = 0;
          int cashTotal = 0;
          int pemMember = 0;
          int pemNonMember = 0;

          for (var item in data) {
            jumlah += int.tryParse(item['jumlah_produk'].toString()) ?? 0;
            int metodePem =
                int.tryParse(item['id_metode_pembayaran'].toString()) ?? 0;
            int member = int.tryParse(item['id_member'].toString()) ?? 0;
            if (metodePem == 1) {
              cashTotal += 1;
            } else if (metodePem == 2) {
              qrisTotal += 1;
            }
            if (member == 0) {
              pemNonMember += 1;
            } else {
              pemMember += 1;
            }
          }

          totalProduk.value = jumlah;
          totalQRIS.value = qrisTotal;
          totalCash.value = cashTotal;
          member.value = pemMember;
          nonMember.value = pemNonMember;
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

  Future<void> fetchTransaksiOutDet() async {
    var url = ApiService.baseUrl + '/transaksi_out/detail';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          transaksiOutDet.value =
              List<Map<String, dynamic>>.from(jsonData['data']);
          int total = 0;
          for (var item in transaksiOutDet) {
            total += int.tryParse(item['total_harga'].toString()) ?? 0;
          }
          totalHarga.value = total;
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

  Future<void> fetchTransaksiInDet() async {
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
          transaksiInDet.value = transaksiList;
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
          int total = 0;
          for (var item in transaksi) {
            total += int.tryParse(item['total_transaksi'].toString()) ?? 0;
          }
          totalTransaksiIn.value = total;
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

  Future<void> fetchKasbon() async {
    var url = ApiService.baseUrl + '/kasbon';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          transaksi.value = List<Map<String, dynamic>>.from(jsonData['data']);
          int total = 0;
          for (var item in transaksi) {
            total += int.tryParse(item['total_kasbon'].toString()) ?? 0;
          }
          totalKasbon.value = total;
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

  Future<void> fetchProduk() async {
    var url = ApiService.baseUrl + '/product';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          produk.value = List<Map<String, dynamic>>.from(jsonData['data']);
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
}
