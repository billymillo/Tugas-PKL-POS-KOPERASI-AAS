import 'dart:convert';
import 'dart:io';

import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransaksiOutMController extends GetxController {
  final ApiService apiService = ApiService();
  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var url = ApiService.baseUrl + '/product';
  var urlTr = ApiService.baseUrl;
  var selectedStartDate = DateTime.now().obs;
  var selectedEndDate = DateTime.now().obs;
  var dateLabel = 'Pilih Tanggal'.obs;
  var isLoading = false.obs;

  var mitra = <Map<String, dynamic>>[].obs;
  var produk = <Map<String, dynamic>>[].obs;
  var transaksiOutDet = <Map<String, dynamic>>[].obs;
  var transaksiOutDetSaldo = <Map<String, dynamic>>[].obs;
  var allTransaksiOutDet = <Map<String, dynamic>>[].obs;
  var selectedMitra = ''.obs;

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
    fetchMitra();
    fetchTransaksiOutDet();
    fetchProduk();
  }

  String MitraId(String idProduct) {
    var selected = produk.firstWhere(
      (m) => m['id'].toString() == idProduct,
      orElse: () => {'id_mitra_barang': '0'},
    );
    return selected['id_mitra_barang'] ?? "0";
  }

  String ProdukName(String idProduct) {
    var selected = produk.firstWhere(
      (m) => m['id'].toString() == idProduct,
      orElse: () => {'nama_barang': '0'},
    );
    return selected['nama_barang'] ?? "0";
  }

  String MitraName(String mitraId) {
    var selected = mitra.firstWhere(
      (m) => m['id'].toString() == mitraId,
      orElse: () => {'nama': 'Pilih Mitra Terlebih Dahulu'},
    );
    return selected['nama'] ?? "Pilih Mitra Terlebih Dahulu";
  }

  int get totalSaldo {
    return transaksiOutDet.fold<int>(
      0,
      (sum, item) =>
          sum +
          (int.tryParse((double.tryParse(item['saldo'].toString()) ?? 0)
                  .toStringAsFixed(0)) ??
              0),
    );
  }

  int get totalJumlah {
    return transaksiOutDet.fold<int>(
      0,
      (sum, item) =>
          sum +
          (int.tryParse((double.tryParse(item['jumlah'].toString()) ?? 0)
                  .toStringAsFixed(0)) ??
              0),
    );
  }

  void filterTransaksiOutDet() {
    final start = selectedStartDate.value;
    final end = selectedEndDate.value;
    final selectedMitraId = selectedMitra.value;

    final Map<String, Map<String, dynamic>> grouped = {};

    for (var item in allTransaksiOutDet) {
      final inputDate = DateTime.tryParse(item['input_date']);
      if (inputDate == null) continue;

      final idProduk = item['id_produk']?.toString() ?? '';
      final mitraId = MitraId(idProduk);
      if (mitraId != selectedMitraId) continue;

      if (inputDate.isBefore(start) || inputDate.isAfter(end)) continue;

      final tanggalStr = DateFormat('yyyy-MM-dd').format(inputDate);
      final groupKey = '$tanggalStr|$idProduk';

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = {
          'id_produk': idProduk,
          'tanggal': tanggalStr,
          'jumlah': 0,
          'harga_satuan': item['harga_satuan'],
          'harga_jual': item['harga_jual'],
          'total_harga_dasar': 0,
          'total_harga': 0,
          'laba': 0,
          'saldo': 0,
          'input_date': item['input_date'],
        };
      }

      grouped[groupKey]!['jumlah'] +=
          int.tryParse(item['jumlah']?.toString() ?? '0') ?? 0;
      grouped[groupKey]!['total_harga_dasar'] +=
          int.tryParse(item['total_harga_dasar']?.toString() ?? '0') ?? 0;
      grouped[groupKey]!['total_harga'] +=
          int.tryParse(item['total_harga']?.toString() ?? '0') ?? 0;
      grouped[groupKey]!['laba'] +=
          int.tryParse(item['laba']?.toString() ?? '0') ?? 0;
      grouped[groupKey]!['saldo'] +=
          int.tryParse(item['saldo']?.toString() ?? '0') ?? 0;
    }

    final result = grouped.values.toList()
      ..sort((a, b) => a['input_date'].compareTo(b['input_date']));

    transaksiOutDet.value = result;
    print("GROUPED PER PRODUK PER TANGGAL: ${result.length}");
  }

  void filterAllTransaksiOutDet() {
    final start = selectedStartDate.value;
    final end = selectedEndDate.value;
    final selectedMitraId = selectedMitra.value;

    final filtered = allTransaksiOutDet.where((item) {
      final inputDate = DateTime.tryParse(item['input_date']);
      if (inputDate == null) return false;

      final idProduk = item['id_produk']?.toString() ?? '';
      final mitraId = MitraId(idProduk);

      return inputDate.isAfter(start.subtract(Duration(days: 1))) &&
          inputDate.isBefore(end.add(Duration(days: 1))) &&
          mitraId == selectedMitraId;
    }).toList();

    transaksiOutDetSaldo.value = filtered;
    print("FILTERED LENGTH: ${filtered.length}");
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

  Future<void> fetchProduk() async {
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
          filterAllTransaksiOutDet();
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

  Future<void> updateSaldo(
    String id,
    String saldo,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';

    try {
      final response = await apiServiceTr.updateSaldo(id, saldo, userUpdate);
      if (response['status'] == true) {
        print(response['message']);
      } else {
        print(response['message']);
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

  Future<void> addTransaksiOutMitra(
    String mitra,
    String jumlah,
    String total,
    String status,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiServiceTr.addTransaksiOutMitra(
      mitra,
      jumlah,
      total,
      status,
      tanggalAwal,
      tanggalAkhir,
      userInput,
    );
    try {
      if (response['status'] == 'true') {
        Get.snackbar(
          'Berhasil',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
        );
        print("Cek Cek Berhasil $response['message']");
      } else if (response['status'] == 'false') {
        Get.snackbar(
          'Gagal',
          response['message'],
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
        print("Cek Gagal $response['message']");
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
      isLoading.value = false;
    }
  }

  Future<void> tarikSaldoMitra() async {
    final List<Map<String, dynamic>> data = transaksiOutDetSaldo;

    for (var item in data) {
      final String id = item['id'].toString();
      await updateSaldo(id, '0');
    }

    print("Semua saldo berhasil dihapus sebanyak ${data.length} data.");
  }

  Future<void> undoTarikSaldo() async {
    final List<Map<String, dynamic>> data = transaksiOutDetSaldo;

    for (var item in data) {
      final String id = item['id'].toString();
      final String totalHargaDasar = item['total_harga_dasar'].toString();
      await updateSaldo(id, totalHargaDasar);
    }

    print("Semua saldo berhasil dihapus sebanyak ${data.length} data.");
  }

  Future<void> pdfTransaksiOutDet() async {
    final pdf = pw.Document();

    if (transaksiOutDet.isEmpty) return;

    final formatCurrency = NumberFormat('#,##0', 'id_ID');
    int grandTotal = 0;

    final tanggalCetak =
        DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

    final imageKiri = pw.MemoryImage(
        (await rootBundle.load('assets/image/logo_kopindo.png'))
            .buffer
            .asUint8List());
    final imageKanan = pw.MemoryImage(
        (await rootBundle.load('assets/image/aas_logo.png'))
            .buffer
            .asUint8List());
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header dengan logo kiri, teks tengah, dan logo kanan
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(imageKiri, width: 60),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text('KOPERASI KARYAWAN DIVISI TIC SARASWANTI',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Text('ANUGRAH ARTHA ABADI',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Text(
                          'SK KEMENKUMHAM AHU-AHU-0000720.AH.01.38 TAHUN 2025',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.Text(
                          'HEAD OFFICE: GRAHA AAS, G. Floor, Jl. Raya Jakarta-Bogor KM. 37',
                          style: pw.TextStyle(fontSize: 10),
                          textAlign: pw.TextAlign.center),
                      pw.Text('Sukamaju, Cilodong, Kota Depok, Jawa Barat',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.Text('anugraharthaa@gmail.com | 082125931519',
                          style: pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
                pw.Image(imageKanan, width: 60),
              ],
            ),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 10),

            // Judul invoice
            pw.Text('INVOICE PEMBAYARAN MITRA',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text(
              'Tanggal Cetak: $tanggalCetak',
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Tanggal Penjualan: ' +
                  '${formatTanggal(selectedStartDate.value.toString())} - ${formatTanggal(selectedEndDate.value.toString())}',
            ),
            pw.SizedBox(height: 10),
            pw.Text("Nama Mitra : " + MitraName(selectedMitra.value.toString()),
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            // Tabel transaksi
            pw.TableHelper.fromTextArray(
              context: context,
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              data: [
                [
                  'No',
                  'Tanggal',
                  'Nama Barang',
                  'Jumlah',
                  'Harga Satuan',
                  'Total Harga',
                ],
                ...List.generate(transaksiOutDet.length, (index) {
                  final item = transaksiOutDet[index];
                  final hargaSatuan =
                      int.tryParse(item['harga_satuan'].toString()) ?? 0;
                  final totalHargaDasar =
                      int.tryParse(item['total_harga_dasar'].toString()) ?? 0;

                  grandTotal += totalHargaDasar;

                  return [
                    '${index + 1}',
                    item['tanggal'] ?? '',
                    ProdukName(item['id_produk']),
                    item['jumlah'].toString(),
                    'Rp ${formatCurrency.format(hargaSatuan)}',
                    'Rp ${formatCurrency.format(totalHargaDasar)}',
                  ];
                }),
              ],
            ),
            pw.SizedBox(height: 20),

            // Total pembayaran
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.black),
                    borderRadius: pw.BorderRadius.circular(4),
                    color: PdfColors.grey100,
                  ),
                  child: pw.Text(
                    'Total Pembayaran: Rp ${formatCurrency.format(grandTotal)}',
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ));

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_pembayaran_mitra.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  String formatRupiah(dynamic number) {
    final value = int.tryParse(number.toString()) ?? 0;
    return NumberFormat.currency(
            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
        .format(value);
  }

  String formatTanggal(String? tanggalStr) {
    if (tanggalStr == null) return '-';
    final date = DateTime.tryParse(tanggalStr);
    if (date == null) return '-';
    return DateFormat("d MMMM yyyy", "id_ID").format(date);
  }
}
