import 'dart:convert';

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
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpNameDetController extends GetxController {
  final ApiService apiService = ApiService();
  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var url = ApiService.baseUrl;

  var stokControllers = <TextEditingController>[].obs;
  var totalHargaList = <int>[].obs;

  var isLoading = false.obs;
  var opname = <Map<String, dynamic>>[].obs;
  var opnameDet = <Map<String, dynamic>>[].obs;
  var status = <Map<String, dynamic>>[].obs;

  var isEditList = <bool>[].obs;
  var isCheckedList = <bool>[].obs;
  var isLastPage = false.obs;
  final startPage = 0.obs;

  RxMap<int, bool> isEditMap = <int, bool>{}.obs;
  RxMap<int, bool> hasBeenSavedMap = <int, bool>{}.obs;

  RxList<Map<String, dynamic>> produk = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> get selectedProduk =>
      produk.where((item) => item['checked'] == true).toList().obs;

  RxInt currentPage = 0.obs;
  final int itemsPerPage = 10;

  var tipeOpname = ''.obs;
  late var idOpname;
  late var statusOpname;

  int get totalPages => (produk.length / itemsPerPage).ceil();
  List<Map<String, dynamic>> get filteredProduk {
    if (statusOpname == '3') {
      final filteredOpnameDet = opnameDet
          .where((item) => item['id_opname'].toString() == idOpname)
          .toList();

      return produk.where((produkItem) {
        return filteredOpnameDet.any((opnameItem) =>
            opnameItem['id_produk'].toString() == produkItem['id'].toString());
      }).toList();
    } else {
      return produk;
    }
  }

  List<Map<String, dynamic>> get paginatedProduk {
    final filtered = filteredProduk;
    final start = currentPage.value * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  final NotchBottomBarController notchController =
      NotchBottomBarController(index: 0);

  @override
  void onInit() {
    super.onInit();
    fetchOpName();
    final args = Get.arguments;
    idOpname = args['id_opname'].toString();
    statusOpname = args['status'].toString();
    print("Cek Id dan Status " + '$idOpname $statusOpname');
    fetchDetOpName();
    fetchStatus();
    fetchProduk();
    WidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('id_ID', null);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void toggleEdit(int index) {
    isEditMap[index] = !(isEditMap[index] ?? false);
  }

  void toggleCheck(int index, bool value) {
    produk[index]['checked'] = value;
    produk.refresh();
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      currentPage.value = page;

      // Atur jendela tampilan blok halaman agar tetap 5
      if (page < startPage.value) {
        startPage.value = page;
      } else if (page >= startPage.value + 5) {
        startPage.value = page - 4;
      }
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;

      if (currentPage.value >= startPage.value + 5) {
        startPage.value++;
      }
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;

      if (currentPage.value < startPage.value) {
        startPage.value--;
      }
    }
  }

  String TipeOpname(String idopname) {
    var selected = opname.firstWhere(
      (m) => m['id'].toString() == idopname,
      orElse: () => {'tipe_opname': '0'},
    );
    return selected['tipe_opname'] ?? "0";
  }

  bool isAllItemSaved(String idOpname) {
    final currentOpnameDetails = opnameDet
        .where((op) => op['id_opname'].toString() == idOpname)
        .toList();

    return produk.every((item) {
      final matchingDetail = currentOpnameDetails.firstWhere(
        (op) => op['id_produk'].toString() == item['id'].toString(),
        orElse: () => {},
      );
      return matchingDetail.isNotEmpty;
    });
  }

  Future<void> saveAllUnsavedItems(String idOpname) async {
    for (int i = 0; i < produk.length; i++) {
      final produkItem = produk[i];

      final alreadySaved = opnameDet.any((item) =>
          item['id_produk'].toString() == produkItem['id'].toString() &&
          item['id_opname'].toString() == idOpname);

      if (!alreadySaved) {
        final stok = int.tryParse(produkItem['stok_input']?.toString() ?? '') ??
            produkItem['stok'];
        final stokAsli =
            int.tryParse(produkItem['stok_asli_input']?.toString() ?? '') ??
                produkItem['stok_asli'];
        final hargaSatuan =
            int.tryParse(produkItem['harga_satuan_input']?.toString() ?? '') ??
                produkItem['harga_satuan'];
        final hargaJual =
            int.tryParse(produkItem['harga_jual_input']?.toString() ?? '') ??
                produkItem['harga_jual'];
        final catatan = '';

        await addDetOpname(
          produkItem['id'].toString(),
          idOpname,
          stok.toString(),
          stokAsli.toString(),
          hargaSatuan.toString(),
          hargaJual.toString(),
          catatan,
        );
      }
    }

    await fetchDetOpName();
    await fetchProduk();
  }

  String statusName(String idStatus) {
    var selected = status.firstWhere(
      (m) => m['id'].toString() == idStatus,
      orElse: () => {'status': 'Belum ada pendataan'},
    );
    return selected['status'] ?? "Belum ada pendataan";
  }

  Future<void> fetchProduk() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/product"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          final filteredData = (jsonData['data'] as List)
              .where((item) =>
                  item['id_tipe_barang'] == TipeOpname(idOpname.toString()))
              .toList();
          print('Cek idOpname $idOpname');
          print('Cek Tipe ${TipeOpname(idOpname.toString())}');
          produk.value = List<Map<String, dynamic>>.from(filteredData);
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

  Future<void> fetchOpName() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/opname"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          List<Map<String, dynamic>> sortedData =
              List<Map<String, dynamic>>.from(jsonData['data'])
                ..sort((a, b) => int.parse(b['id'].toString())
                    .compareTo(int.parse(a['id'].toString())));

          opname.value = sortedData;
        } else {
          throw Exception('Failed to load opname');
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

  Future<void> fetchDetOpName() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/opname/detail"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          opnameDet.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load opname');
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

  Future<void> fetchStatus() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/status"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          status.value = List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          throw Exception('Failed to load status');
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

  Future<void> editOpname(
    String Id,
    String status,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    final response = await ApiService.editOpname(
      Id,
      status,
      userUpdate,
    );
    try {
      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.5),
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (response['status'] == false) {
        Get.snackbar(
          'Selesai',
          'Opname Sudah Pernah Disimpan',
          backgroundColor: Colors.blue.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
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
      isLoading.value = false;
    }
  }

  Future<void> deleteOpname(String id) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userUpdate = prefs.getString('name') ?? 'system';
      final response = await apiService.deleteOpname(
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
        print('Success: $response');
      } else {
        Get.snackbar(
          'Error',
          '${response['message']}',
          backgroundColor: Colors.red.withOpacity(0.5),
          icon: Icon(Icons.error, color: Colors.white),
        );
        print('Gagal: $response');
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

  Future<void> addDetOpname(
    String idProduk,
    String idOpname,
    String stok,
    String stokAsli,
    String hargaSatuan,
    String hargaJual,
    String catatan,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiService.addDetOpname(
      idProduk,
      idOpname,
      stok,
      stokAsli,
      hargaSatuan,
      hargaJual,
      catatan,
      userInput,
    );
    try {
      if (response['status'] == true) {
        print("Opname Berhasil" + response['message']);
      } else if (response['status'] == false) {
        print("Opname Gagal $response");
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

  Future<void> editDetOpname(
    String Id,
    String stok,
    String stokAsli,
    String hargaSatuan,
    String hargaJual,
    String catatan,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userUpdate = prefs.getString('name') ?? 'system';
    final response = await ApiService.editDetOpname(
      Id,
      stok,
      stokAsli,
      hargaSatuan,
      hargaJual,
      catatan,
      userUpdate,
    );
    try {
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
          'Error Saat Mengubah Opname Detail',
          backgroundColor: DarkColor().red.withOpacity(0.5),
          icon: Icon(Icons.crisis_alert, color: Colors.black),
        );
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
}
