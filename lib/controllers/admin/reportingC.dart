import 'dart:convert';
import 'dart:io';

import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:intl/intl.dart';

class ReportingController extends GetxController {
  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var isLoading = false.obs;
  var allTransaksiOut = <Map<String, dynamic>>[].obs;
  var allTransaksiOutDet = <Map<String, dynamic>>[].obs;
  var allTransaksiInDet = <Map<String, dynamic>>[].obs;
  var transaksiOut = <Map<String, dynamic>>[].obs;
  var transaksiOutDet = <Map<String, dynamic>>[].obs;
  var transaksiInDet = <Map<String, dynamic>>[].obs;
  var transaksi = <Map<String, dynamic>>[].obs;
  var produk = <Map<String, dynamic>>[].obs;

  var totalTransaksi = 0.obs;
  var totalProduk = 0.obs;
  var pendapatan = 0.obs;
  var pengeluaran = 0.obs;

  var selectedIndexes = <bool>[false, false, false, false].obs;
  var selectedValue = ''.obs;
  var dateLabel = 'Pilih tanggal'.obs;
  var selectedStartDate = DateTime.now().obs;
  var selectedEndDate = DateTime.now().obs;
  RxBool isFiltered = false.obs;

  final RxList<String> _produkLabels = <String>[].obs;
  List<String> get produkChartLabels => _produkLabels;

  final RxList<String> _pendapatanLabels = <String>[].obs;
  List<String> get pendapatanChartLabels => _pendapatanLabels;

  final RxList<String> _transaksiLabels = <String>[].obs;
  List<String> get transaksiChartLabels => _transaksiLabels;

  final RxList<String> _pengeluaranLabels = <String>[].obs;
  List<String> get pengeluaranChartLabels => _pengeluaranLabels;

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
  }

  void toggleCard(int index) {
    if (index >= 0 && index < selectedIndexes.length) {
      selectedIndexes[index] = !selectedIndexes[index];
    }
  }

  void filterData() {
    final start = selectedStartDate.value;
    final end = selectedEndDate.value;

    final filtered = allTransaksiOut.where((item) {
      final inputDate = DateTime.tryParse(item['input_date']);
      if (inputDate == null) return false;
      return inputDate.isAfter(start.subtract(Duration(days: 1))) &&
          inputDate.isBefore(end.add(Duration(days: 1)));
    }).toList();

    transaksiOut.value = filtered;
    totalTransaksi.value = filtered.length;
    int jumlah = 0;
    int totalPendapatan = 0;

    for (var item in filtered) {
      jumlah += int.tryParse(item['jumlah_produk'].toString()) ?? 0;
      totalPendapatan += int.tryParse(item['total_transaksi'].toString()) ?? 0;
    }
    totalProduk.value = jumlah;
    pendapatan.value = totalPendapatan;
  }

  void filterTransaksiOutDet() {
    final start = selectedStartDate.value;
    final end = selectedEndDate.value;

    final filtered = allTransaksiOutDet.where((item) {
      final inputDate = DateTime.tryParse(item['input_date']);
      if (inputDate == null) return false;
      return inputDate.isAfter(start.subtract(Duration(days: 1))) &&
          inputDate.isBefore(end.add(Duration(days: 1)));
    }).toList();

    transaksiOutDet.value = filtered;
  }

  void filterTransaksiInDet() {
    final start = selectedStartDate.value;
    final end = selectedEndDate.value;

    final filtered = allTransaksiInDet.where((item) {
      final inputDate = DateTime.tryParse(item['input_date']);
      if (inputDate == null) return false;
      return inputDate.isAfter(start.subtract(Duration(days: 1))) &&
          inputDate.isBefore(end.add(Duration(days: 1)));
    }).toList();

    transaksiInDet.value = filtered;

    // Hitung total pengeluaran
    int totalPengeluaran = 0;
    for (var item in filtered) {
      totalPengeluaran += int.tryParse(item['total_harga'].toString()) ?? 0;
    }

    pengeluaran.value = totalPengeluaran;
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
    var selected = transaksi.firstWhere(
      (m) => m['id'].toString() == idTransaksi,
      orElse: () => {'no_transaksi_in': ''},
    );
    return selected['no_transaksi_in'] ?? "";
  }

  List<FlSpot> get produkChartSpots {
    final Map<String, int> grouped = {};

    for (var item in transaksiOut) {
      final dateStr = item['input_date'];
      final date = DateTime.tryParse(dateStr);
      if (date != null) {
        final key = DateFormat('yyyy-MM-dd').format(date);
        final jumlah = int.tryParse(item['jumlah_produk'].toString()) ?? 0;
        grouped.update(key, (value) => value + jumlah, ifAbsent: () => jumlah);
      }
    }

    final sortedKeys = grouped.keys.toList()..sort();
    _produkLabels.value = sortedKeys;

    return List.generate(sortedKeys.length, (index) {
      final jumlah = grouped[sortedKeys[index]]!;
      return FlSpot(index.toDouble(), jumlah.toDouble());
    });
  }

  List<FlSpot> get pendapatanChartSpots {
    final Map<String, int> grouped = {};

    for (var item in transaksiOut) {
      final dateStr = item['input_date'];
      final date = DateTime.tryParse(dateStr);
      if (date != null) {
        final key = DateFormat('yyyy-MM-dd').format(date);
        final jumlah = int.tryParse(item['total_transaksi'].toString()) ?? 0;
        grouped.update(key, (value) => value + jumlah, ifAbsent: () => jumlah);
      }
    }

    final sortedKeys = grouped.keys.toList()..sort();
    _pendapatanLabels.value = sortedKeys;

    return List.generate(sortedKeys.length, (index) {
      final jumlah = grouped[sortedKeys[index]]!;
      return FlSpot(index.toDouble(), jumlah.toDouble());
    });
  }

  List<FlSpot> get transaksiChartSpots {
    final Map<String, int> grouped = {};

    for (var item in transaksiOut) {
      final dateStr = item['input_date'];
      final date = DateTime.tryParse(dateStr);
      if (date != null) {
        final key = DateFormat('yyyy-MM-dd').format(date);
        grouped.update(key, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final sortedKeys = grouped.keys.toList()..sort();
    _transaksiLabels.value = sortedKeys;

    return List.generate(sortedKeys.length, (index) {
      final jumlah = grouped[sortedKeys[index]]!;
      return FlSpot(index.toDouble(), jumlah.toDouble());
    });
  }

  List<FlSpot> get pengeluaranChartSpots {
    final Map<String, int> grouped = {};

    for (var item in transaksiInDet) {
      final dateStr = item['input_date'];
      final date = DateTime.tryParse(dateStr);
      if (date != null) {
        final key = DateFormat('yyyy-MM-dd').format(date);
        final jumlah = int.tryParse(item['total_harga'].toString()) ?? 0;
        grouped.update(key, (value) => value + jumlah, ifAbsent: () => jumlah);
      }
    }

    final sortedKeys = grouped.keys.toList()..sort();
    _pengeluaranLabels.value = sortedKeys;

    return List.generate(sortedKeys.length, (index) {
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
          allTransaksiOut.value = data;
          filterData();
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
          List<Map<String, dynamic>> rawData =
              List<Map<String, dynamic>>.from(jsonData['data']);

          allTransaksiOutDet.value = rawData; // simpan data mentah
          filterTransaksiOutDet(); // lakukan filter dan proses
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
          allTransaksiInDet.value = transaksiList;
          filterTransaksiInDet();
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

  Future<void> pdfTransaksiOut() async {
    final pdf = pw.Document();

    if (transaksiOutDet.isEmpty) return;

    final Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var item in transaksiOutDet) {
      final String date = item['input_date'].substring(0, 10);

      if (groupedData.containsKey(date)) {
        groupedData[date]!.add(item);
      } else {
        groupedData[date] = [item];
      }
    }

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Laporan Transaksi', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              data: [
                [
                  'Tanggal',
                  'Jumlah Produk',
                  'Total Harga Dasar',
                  'Total Harga',
                  'Keuntungan'
                ],
                ...groupedData.entries.map((entry) {
                  final date = entry.key;
                  final items = entry.value;

                  int totalJumlah = items.fold(
                      0,
                      (sum, item) =>
                          sum + (int.tryParse(item['jumlah'].toString()) ?? 0));
                  int totalHargaDasar = items.fold(
                      0,
                      (sum, item) =>
                          sum +
                          (int.tryParse(item['total_harga_dasar'].toString()) ??
                              0));
                  int totalHarga = items.fold(
                      0,
                      (sum, item) =>
                          sum +
                          (int.tryParse(item['total_harga'].toString()) ?? 0));
                  int totalLaba = items.fold(
                      0,
                      (sum, item) =>
                          sum + (int.tryParse(item['laba'].toString()) ?? 0));

                  return [
                    date,
                    '$totalJumlah Pcs',
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(totalHargaDasar)}',
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(totalHarga)}',
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(totalLaba)}',
                  ];
                }).toList(),
              ],
            ),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/transaksi_report.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  Future<void> pdfTransaksiIn() async {
    final pdf = pw.Document();

    if (transaksiInDet.isEmpty) return;

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Laporan Transaksi Masuk',
                style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              context: context,
              data: [
                [
                  'No',
                  'Tanggal',
                  'No. Transaksi',
                  'Produk',
                  'Jumlah Produk',
                  'Total Harga'
                ],
                ...List.generate(transaksiInDet.length, (index) {
                  final item = transaksiInDet[index];

                  return [
                    '${index + 1}',
                    item['input_date'].toString().substring(0, 10),
                    NoTransaksi(item['id_transaksi_in']),
                    ProdukName(item['id_produk']),
                    '${item['jumlah']} Pcs',
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['total_harga'].toString()) ?? 0)}',
                  ];
                }),
              ],
            ),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/transaksi_masuk_report.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }
}
