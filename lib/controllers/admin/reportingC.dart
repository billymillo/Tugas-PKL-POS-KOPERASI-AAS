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
  var kasbon = <Map<String, dynamic>>[].obs;
  var produk = <Map<String, dynamic>>[].obs;
  var member = <Map<String, dynamic>>[].obs;

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
  var groupedProduk = <Map<String, dynamic>>[].obs;

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
    fetchKasbon();
    fetchMember();
  }

  void toggleCard(int index) {
    if (index >= 0 && index < selectedIndexes.length) {
      selectedIndexes[index] = !selectedIndexes[index];
    }
  }

  String MemberName(String idMember) {
    var selected = member.firstWhere(
      (m) => m['id'].toString() == idMember,
      orElse: () => {'nama': 'Non Member'},
    );
    return selected['nama'] ?? "Non Member";
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
      orElse: () => {'gambar_barang': 'default.png'},
    );
    return selected['gambar_barang'] ?? "default.png";
  }

  String NoTransaksi(String idTransaksi) {
    var selected = transaksi.firstWhere(
      (m) => m['id'].toString() == idTransaksi,
      orElse: () => {'no_transaksi_in': ''},
    );
    return selected['no_transaksi_in'] ?? "";
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

    for (var item in filtered) {
      jumlah += int.tryParse(item['jumlah_produk'].toString()) ?? 0;
    }
    totalProduk.value = jumlah;

    // PERUBAHAN: Hitung pendapatan dari transaksiOutDet yang sudah difilter
    int totalPendapatan = 0;
    for (var item in transaksiOutDet) {
      totalPendapatan += int.tryParse(item['total_harga'].toString()) ?? 0;
    }
    pendapatan.value = totalPendapatan;
  }

  void groupAndSortTransaksi(List<Map<String, dynamic>> transaksi) {
    final Map<int, Map<String, dynamic>> grouped = {};

    for (var item in transaksi) {
      final idProduk = int.tryParse(item['id_produk'].toString()) ?? 0;
      final jumlah = int.tryParse(item['jumlah'].toString()) ?? 0;
      final totalHarga = int.tryParse(item['total_harga'].toString()) ?? 0;
      final totalHargaDasar =
          int.tryParse(item['total_harga_dasar'].toString()) ?? 0;

      if (grouped.containsKey(idProduk)) {
        grouped[idProduk]!['jumlah'] =
            (grouped[idProduk]!['jumlah'] ?? 0) + jumlah;
        grouped[idProduk]!['total_harga'] =
            (grouped[idProduk]!['total_harga'] ?? 0) + totalHarga;
        grouped[idProduk]!['total_harga_dasar'] =
            (grouped[idProduk]!['total_harga_dasar'] ?? 0) + totalHargaDasar;

        // Hitung ulang laba
        grouped[idProduk]!['laba'] = (grouped[idProduk]!['total_harga'] ?? 0) -
            (grouped[idProduk]!['total_harga_dasar'] ?? 0);
      } else {
        grouped[idProduk] = {
          ...item,
          'jumlah': jumlah,
          'total_harga': totalHarga,
          'total_harga_dasar': totalHargaDasar,
          'laba': totalHarga - totalHargaDasar,
        };
      }
    }

    final result = grouped.values.toList()
      ..sort((a, b) => (b['jumlah'] ?? 0).compareTo(a['jumlah'] ?? 0));

    groupedProduk.value = result;
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

    // PERUBAHAN: Update pendapatan setelah filter transaksiOutDet
    int totalPendapatan = 0;
    for (var item in filtered) {
      totalPendapatan += int.tryParse(item['total_harga'].toString()) ?? 0;
    }
    pendapatan.value = totalPendapatan;
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

    // PERUBAHAN: Gunakan transaksiOutDet instead of transaksiOut
    for (var item in transaksiOutDet) {
      final dateStr = item['input_date'];
      final date = DateTime.tryParse(dateStr);
      if (date != null) {
        final key = DateFormat('yyyy-MM-dd').format(date);
        // PERUBAHAN: Gunakan total_harga dari detail transaksi
        final jumlah = int.tryParse(item['total_harga'].toString()) ?? 0;
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
    var url = ApiService.baseUrl + '/Transaksi_Out';
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
          // PERUBAHAN: Panggil filterTransaksiOutDet untuk update pendapatan
          if (allTransaksiOutDet.isNotEmpty) {
            filterTransaksiOutDet();
          }
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

// Ubah fetchTransaksiOutDet untuk memanggil filterData juga
  Future<void> fetchTransaksiOutDet() async {
    var url = ApiService.baseUrl + '/Transaksi_Out/detail';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          List<Map<String, dynamic>> rawData =
              List<Map<String, dynamic>>.from(jsonData['data']);

          allTransaksiOutDet.value = rawData;
          filterTransaksiOutDet();
          // PERUBAHAN: Panggil filterData untuk update data lain jika transaksiOut sudah ada
          if (allTransaksiOut.isNotEmpty) {
            filterData();
          }
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
    var url = ApiService.baseUrl + '/Transaksi_In/detail';
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
    var url = ApiService.baseUrl + '/Transaksi_In';
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

  Future<void> fetchMember() async {
    var url = ApiService.baseUrl + '/member';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url));
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
          List<Map<String, dynamic>> data =
              List<Map<String, dynamic>>.from(jsonData['data']);

          Map<int, int> dataKasbon = {};
          for (var item in data) {
            int idMember = int.parse(item['id_member'].toString());
            int totalKasbon = int.parse(item['total_kasbon'].toString());

            if (dataKasbon.containsKey(idMember)) {
              dataKasbon[idMember] = dataKasbon[idMember]! + totalKasbon;
            } else {
              dataKasbon[idMember] = totalKasbon;
            }
          }

          kasbon.value = dataKasbon.entries.map((entry) {
            return {
              'id_member': entry.key,
              'total_kasbon': entry.value,
            };
          }).toList();
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
      groupedData.putIfAbsent(date, () => []).add(item);
    }

    // Load both logo images
    final ByteData logoKiriData =
        await rootBundle.load('assets/image/logo_kopindo.png');
    final ByteData logoKananData =
        await rootBundle.load('assets/image/aas_logo.png');

    final Uint8List logoKiriBytes = logoKiriData.buffer.asUint8List();
    final Uint8List logoKananBytes = logoKananData.buffer.asUint8List();

    final logoKiri = pw.MemoryImage(logoKiriBytes);
    final logoKanan = pw.MemoryImage(logoKananBytes);

    final tanggalCetak =
        DateFormat('dd MMMM yyyy hh:mm:ss', 'id_ID').format(DateTime.now());

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(logoKiri, width: 70, height: 70),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('KOPERASI KARYAWAN DIVISI TIC SARASWANTI',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.Text('ANUGRAH ARTHA ABADI',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'SK KEMENKUMHAM AHU-AHU-0000720.AH.01.38 TAHUN 2025',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text(
                          'HEAD OFFICE: GRAHA AAS, G. Floor, Jl. Raya Jakarta-Bogor KM. 37',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('Sukamaju, Cilodong, Kota Depok, Jawa Barat',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('anugraharthaa@gmail.com | 082125931519',
                          style: pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
                pw.Image(logoKanan, width: 70, height: 70),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.SizedBox(height: 12),

            // Judul
            pw.Text('Laporan Transaksi Out',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text(
              'Tanggal Cetak: $tanggalCetak',
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
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

    // Load logo kiri dan kanan
    final ByteData logoKiriData =
        await rootBundle.load('assets/image/logo_kopindo.png');
    final ByteData logoKananData =
        await rootBundle.load('assets/image/aas_logo.png');

    final Uint8List logoKiriBytes = logoKiriData.buffer.asUint8List();
    final Uint8List logoKananBytes = logoKananData.buffer.asUint8List();

    final logoKiri = pw.MemoryImage(logoKiriBytes);
    final logoKanan = pw.MemoryImage(logoKananBytes);

    final tanggalCetak =
        DateFormat('dd MMMM yyyy hh:mm:ss', 'id_ID').format(DateTime.now());

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header dengan dua logo
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(logoKiri, width: 70, height: 70),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('KOPERASI KARYAWAN DIVISI TIC SARASWANTI',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.Text('ANUGRAH ARTHA ABADI',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'SK KEMENKUMHAM AHU-AHU-0000720.AH.01.38 TAHUN 2025',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text(
                          'HEAD OFFICE: GRAHA AAS, G. Floor, Jl. Raya Jakarta-Bogor KM. 37',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('Sukamaju, Cilodong, Kota Depok, Jawa Barat',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('anugraharthaa@gmail.com | 082125931519',
                          style: pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
                pw.Image(logoKanan, width: 70, height: 70),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.SizedBox(height: 12),

            // Judul
            pw.Text('Laporan Transaksi In',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text(
              'Tanggal Cetak: $tanggalCetak',
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
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

  Future<void> pdfProduk() async {
    final pdf = pw.Document();

    if (groupedProduk.isEmpty) return;

    // Load logo kiri dan kanan
    final ByteData logoKiriData =
        await rootBundle.load('assets/image/logo_kopindo.png');
    final ByteData logoKananData =
        await rootBundle.load('assets/image/aas_logo.png');

    final Uint8List logoKiriBytes = logoKiriData.buffer.asUint8List();
    final Uint8List logoKananBytes = logoKananData.buffer.asUint8List();

    final logoKiri = pw.MemoryImage(logoKiriBytes);
    final logoKanan = pw.MemoryImage(logoKananBytes);
    final tanggalCetak =
        DateFormat('dd MMMM yyyy hh:mm:ss', 'id_ID').format(DateTime.now());

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(logoKiri, width: 70, height: 70),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('KOPERASI KARYAWAN DIVISI TIC SARASWANTI',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.Text('ANUGRAH ARTHA ABADI',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'SK KEMENKUMHAM AHU-AHU-0000720.AH.01.38 TAHUN 2025',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text(
                          'HEAD OFFICE: GRAHA AAS, G. Floor, Jl. Raya Jakarta-Bogor KM. 37',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('Sukamaju, Cilodong, Kota Depok, Jawa Barat',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('anugraharthaa@gmail.com | 082125931519',
                          style: pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
                pw.Image(logoKanan, width: 70, height: 70),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.SizedBox(height: 12),
            pw.Text('Laporan Produk',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text(
              'Tanggal Cetak: $tanggalCetak',
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
              data: [
                [
                  'No',
                  'Nama Produk',
                  'Jumlah',
                  'Total Harga Dasar',
                  'Total Harga Jual',
                  'Laba'
                ],
                ...List.generate(groupedProduk.length, (index) {
                  final item = groupedProduk[index];
                  final jumlah = item['jumlah'] ?? 0;
                  final hargaDasar = item['total_harga_dasar'] ?? 0;
                  final totalHarga = item['total_harga'] ?? 0;
                  final laba = totalHarga - hargaDasar;

                  return [
                    '${index + 1}',
                    ProdukName(item['id_produk'].toString()),
                    '$jumlah pcs',
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(hargaDasar)}',
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(totalHarga)}',
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(laba)}',
                  ];
                }),
              ],
            ),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/grouped_produk_report.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  Future<void> pdfKasbon() async {
    final pdf = pw.Document();

    if (kasbon.isEmpty) return;

    // Load logo kiri dan kanan
    final ByteData logoKiriData =
        await rootBundle.load('assets/image/logo_kopindo.png');
    final ByteData logoKananData =
        await rootBundle.load('assets/image/aas_logo.png');

    final Uint8List logoKiriBytes = logoKiriData.buffer.asUint8List();
    final Uint8List logoKananBytes = logoKananData.buffer.asUint8List();

    final logoKiri = pw.MemoryImage(logoKiriBytes);
    final logoKanan = pw.MemoryImage(logoKananBytes);

    final sortedKasbon = [...kasbon];
    sortedKasbon.sort((a, b) => int.parse(b['total_kasbon'].toString())
        .compareTo(int.parse(a['total_kasbon'].toString())));
    final tanggalCetak =
        DateFormat('dd MMMM yyyy hh:mm:ss', 'id_ID').format(DateTime.now());

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(logoKiri, width: 70, height: 70),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('KOPERASI KARYAWAN DIVISI TIC SARASWANTI',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.Text('ANUGRAH ARTHA ABADI',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'SK KEMENKUMHAM AHU-AHU-0000720.AH.01.38 TAHUN 2025',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text(
                          'HEAD OFFICE: GRAHA AAS, G. Floor, Jl. Raya Jakarta-Bogor KM. 37',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('Sukamaju, Cilodong, Kota Depok, Jawa Barat',
                          style: pw.TextStyle(fontSize: 9)),
                      pw.Text('anugraharthaa@gmail.com | 082125931519',
                          style: pw.TextStyle(fontSize: 9)),
                    ],
                  ),
                ),
                pw.Image(logoKanan, width: 70, height: 70),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Divider(),
            pw.SizedBox(height: 12),
            pw.Text('Laporan Kasbon Member',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text(
              'Tanggal Cetak: $tanggalCetak',
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
              data: [
                ['No', 'ID Member', 'Nama Member', 'Total Kasbon'],
                ...List.generate(sortedKasbon.length, (index) {
                  final item = sortedKasbon[index];
                  return [
                    '${index + 1}',
                    item['id_member'].toString(),
                    MemberName(item['id_member'].toString()),
                    'Rp ${NumberFormat('#,##0', 'id_ID').format(item['total_kasbon'])}',
                  ];
                }),
              ],
            ),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/laporan_kasbon.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }
}
