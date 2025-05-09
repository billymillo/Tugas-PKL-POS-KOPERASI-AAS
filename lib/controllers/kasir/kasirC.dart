import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/libraryC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/memberP.dart';
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KasirC extends GetxController {
  TextEditingController searchController = TextEditingController();

  final LibraryController poinController = Get.put(LibraryController());

  var listProduk = <Map<String, dynamic>>[].obs;
  RxList<dynamic> selectedVarian = [].obs;
  RxInt banyakDibeli = 0.obs;
  RxString searchQuery = ''.obs;
  String? idTransaksiOut;
  String? noTransaksi;
  String? diskonStruk;
  String? bayarTransaksi;

  var produk = <Map<String, dynamic>>[].obs;
  var kategori = <Map<String, dynamic>>[].obs;
  var filteredProduk = <Map<String, dynamic>>[].obs;
  var selectedCategory = 'All'.obs;
  var metodePembayaran = 0.obs;
  var statusTr = 0.obs;
  var statusId = 0.obs;

  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var url = ApiService.baseUrl + '/product';

  var urlTr = ApiServiceTr.baseUrlTr;
  var member = <Map<String, dynamic>>[].obs;
  var addOn = <Map<String, dynamic>>[].obs;
  var struk = <Map<String, dynamic>>[].obs;
  var selectedMember = Rxn<String>();
  var filteredMembers = <Map<String, dynamic>>[].obs;

  var status = <Map<String, dynamic>>[].obs;
  RxBool checkbox = false.obs;
  RxBool checkboxSaldo = false.obs;
  RxInt diskon = 0.obs;
  var transaksiId = ''.obs;

  var isLoading = true.obs;
  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  BluetoothDevice? device;
  RxBool isConnected = false.obs;
  var selectedAddOn = ''.obs;
  var jumlahPesanan = 0.obs;

  double get totalHarga {
    double total = 0;
    bool addOnAdded = false;

    for (var produk in listProduk) {
      if (produk['listDibeli'] != null) {
        for (var item in produk['listDibeli']) {
          total += double.tryParse(item['harga'].toString()) ?? 0;
        }
      }
    }
    if (!addOnAdded) {
      for (var produk in listProduk) {
        if (produk['listDibeli'] != null) {
          for (var item in produk['listDibeli']) {
            var addOn = item['addOn'];
            if (addOn != null && addOn != '1') {
              total += double.tryParse(addOnHarga(addOn).toString()) ?? 0;
              addOnAdded = true;
              break;
            }
          }
        }
        if (addOnAdded) break;
      }
    }

    double diskon = 0;
    if (checkbox.value && double.tryParse(MemberPoin.toString())! < total) {
      diskon = (double.tryParse(MemberPoin.toString()) ?? 0) * 10;
    }

    return total - diskon;
  }

  double get totalHargaSebelum {
    double total = 0;
    for (var produk in listProduk) {
      if (produk['listDibeli'] != null) {
        for (var item in produk['listDibeli']) {
          total += double.tryParse(item['harga'].toString()) ?? 0;
        }
      }
    }
    return total;
  }

  int get poinUpdate {
    int currentMemberPoin = int.tryParse(MemberPoin) ?? 0;
    if (selectedMember.value == null) {
      return 0;
    } else {
      if (checkbox.value == false) {
        return (totalHarga ~/ 100) + currentMemberPoin;
      } else if (checkbox.value &&
          double.tryParse(MemberPoin.toString())! < totalHarga) {
        return currentMemberPoin;
      } else {
        return 0;
      }
    }
  }

  int get saldoUpdate {
    int currentMemberSaldo = int.tryParse(MemberSaldo) ?? 0;
    if (selectedMember.value == null) {
      return 0;
    } else {
      if (checkboxSaldo.value == true) {
        return currentMemberSaldo - totalHarga.toInt();
      } else {
        return 0;
      }
    }
  }

  int get poinDapat {
    int currentMemberPoin = int.tryParse(MemberPoin) ?? 0;
    int conversionValue = LibraryController.poinToRupiah.value;
    int poinUpdate = (totalHarga ~/ conversionValue) + currentMemberPoin;

    if (selectedMember.value == null) {
      return 0;
    } else {
      if (checkbox.value == false) {
        return poinUpdate - currentMemberPoin;
      } else {
        return 0;
      }
    }
  }

  double get potonganHarga {
    return poinDapat * 100.0;
  }

  String get MemberName {
    var selected = member.firstWhere(
      (m) => m['id'] == selectedMember.value,
      orElse: () => {'nama': 'Non Member'},
    );
    return selected['nama'] ?? 0;
  }

  String get MemberPoin {
    var selected = member.firstWhere(
      (m) => m['id'] == selectedMember.value,
      orElse: () => {'Poin': '0'},
    );
    return selected['poin'] ?? '0';
  }

  String get MemberSaldo {
    var selected = member.firstWhere(
      (m) => m['id'] == selectedMember.value,
      orElse: () => {'Saldo': '0'},
    );
    return selected['saldo'] ?? '0';
  }

  int get calculateDiskon {
    var selected = member.firstWhere(
      (m) => m['id'] == selectedMember.value,
      orElse: () => {'poin': '0'},
    );

    int poin = int.tryParse(selected['poin'].toString()) ?? 0;

    if (checkbox.value) {
      return poin;
    } else {
      return poin = 0;
    }
  }

  String addOnName(String idAddon) {
    var selected = addOn.firstWhere(
      (m) => m['id'].toString() == idAddon,
      orElse: () => {'add_on': 'Tidak Ada'},
    );
    return selected['add_on'] ?? "Tidak Ada";
  }

  int addOnHarga(String idAddon) {
    var selected = addOn.firstWhere(
      (m) => m['id'].toString() == idAddon,
      orElse: () => {'harga': '0'},
    );

    final hargaStr = selected['harga']?.toString() ?? '0';

    return int.tryParse(hargaStr) ?? 0;
  }

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    fetchProduk();
    fetchKategori();
    fetchMember();
    fetchAddon();
    fetchTransaksiStruk();

    if (listProduk.isEmpty || filteredProduk.isEmpty) {
      setData2();
      addAllItems();
    }

    super.onInit();
  }

  void kurangKeKeranjang(i, varian) {
    if (filteredProduk[i]['jumlahDibeli'] > 0) {
      banyakDibeli.value = banyakDibeli.value - 1;
      filteredProduk[i]['jumlahDibeli'] = filteredProduk[i]['jumlahDibeli'] - 1;
      filteredProduk[i]['listDibeli']
          .removeAt(filteredProduk[i]['listDibeli'].length - 1);
      filteredProduk.refresh();
    }
  }

  void tambahKeKeranjang(int i, varian, {String addOnValue = '1'}) {
    if (int.parse(filteredProduk[i]['jumlah']) >
        filteredProduk[i]['jumlahDibeli']) {
      filteredProduk[i]['jumlahDibeli'] = filteredProduk[i]['jumlahDibeli'] + 1;

      if (varian.toString() == 'null') {
        banyakDibeli.value = banyakDibeli.value + 1;
        filteredProduk[i]['listDibeli'].add({
          "id": filteredProduk[i]['id'],
          "tipe": null,
          "Jumlah": '1',
          'harga': filteredProduk[i]['harga'],
          "harga_satuan": filteredProduk[i]['harga_satuan'],
          'addOn': addOnValue,
        });
      }
      print('Jumlah Dibeli: ${filteredProduk[i]['jumlahDibeli']}');
      print('List Dibeli: ${filteredProduk[i]['listDibeli']}');
      filteredProduk.refresh();
    } else {
      Get.snackbar(
        'Stok Produk Terbatas',
        'Tidak Bisa Membeli Produk Lebih Dari Stok Yang Ada.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void searchProduk(String query) {
    searchQuery.value = query;
    filteredProduk.assignAll(listProduk.where((produk) {
      return produk['nama'].toLowerCase().contains(query.toLowerCase()) ||
          produk['kategori_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          produk['tipe_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          produk['mitra_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList());
  }

  Future<void> fetchProduk() async {
    var url = ApiService.baseUrl + '/product';
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/produk"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          setData1(jsonData['data']);
          addAllItems();
        } else {
          throw Exception('Gagal mengambil data produk');
        }
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchKategori() async {
    try {
      isLoading.value = true;
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
      isLoading.value = false;
    }
  }

  void kategoriProduk(String query) {
    if (query.isEmpty) {
      filteredProduk.assignAll(listProduk); // ambil referensi asli
    } else {
      var filtered = listProduk.where((produk) {
        return produk['kategori']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();

      if (filtered.isEmpty) {
        addAllItems();
      } else {
        filteredProduk.assignAll(filtered); // tetap referensi asli
      }
    }
  }

  void kategoriProdukTipe() {
    var filtered = listProduk.where((produk) => produk['tipe'] == '2').toList();
    filteredProduk.assignAll(filtered);
  }

  void addAllItems() {
    filteredProduk.assignAll(listProduk);
  }

  void setData1(List<dynamic> data) {
    listProduk.value = List<Map<String, dynamic>>.from(data.map((item) => {
          "id": item['id'],
          "nama": item['nama_barang'],
          "harga": item['harga_jual'].toString(),
          "harga_satuan": item['harga_satuan'].toString(),
          "tipe": item['id_tipe_barang'].toString(),
          "mitra": item['mitra_name'] ?? "Tidak Memiliki Mitra",
          "kategori": item['kategori_name'],
          "addOn": item['id_add_on'],
          "jumlah": item['stok'].toString(),
          "jumlahDibeli": 0,
          "listDibeli": [],
          "foto": "http://10.10.20.50/POS_CI/uploads/${item['gambar_barang']}",
        }));
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

  Future<void> fetchAddon() async {
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse(url + "/add_on"));
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
      isLoading.value = false;
    }
  }

  Future<void> refreshPage() async {
    selectedMember.value = null;
    await fetchProduk();
    await fetchKategori();
    await fetchMember();
    await fetchStatus();
  }

  void searchMember(
      String query, List<Map<String, dynamic>> originalMemberList) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredMembers.assignAll(originalMemberList);
    } else {
      filteredMembers.assignAll(originalMemberList.where((member) {
        final nama = member['nama'].toString().toLowerCase();
        final id = member['id'].toString().toLowerCase();

        return nama.contains(query.toLowerCase()) ||
            id.contains(query.toLowerCase());
      }).toList());
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredMembers.assignAll([]);
  }

  Future<void> tambahPoin(
    String id,
    String poin,
  ) async {
    isLoading.value = true;
    try {
      final response = await apiServiceTr.tambahPoin(
        id,
        poin,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Berhasil',
          'Poin Member berhasil ditambahkan ke Member',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Non Member',
          'Pembelian Berjenis Non Member',
          backgroundColor: Colors.blue.withOpacity(0.5),
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

  Future<void> kurangSaldo(
    String id,
    String saldo,
  ) async {
    isLoading.value = true;
    try {
      final response = await apiServiceTr.gunakanSaldo(
        id,
        saldo,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Berhasil',
          'Berhasil Saldo Member telah dipakai',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Non Member',
          'Pembelian Berjenis Non Member',
          backgroundColor: Colors.blue.withOpacity(0.5),
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
      checkboxSaldo.value = false;
    }
  }

  Future<void> kurangStok(
    String id,
    String stok,
  ) async {
    isLoading.value = true;
    try {
      final response = await apiServiceTr.kurangStok(
        id,
        stok,
      );
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

  Future<void> fetchStatus() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(urlTr + "/member/status"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          status.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  List<Map<String, dynamic>> searchMembers(String query) {
    return member.where((member) {
      return member['nama'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> addTransaksiOut(
    String? idMember,
    String produk,
    String metodePem,
    String totalTr,
    String? diskon,
    String statusTr,
    String? potPoin,
    String? getPoin, {
    bool fromButton = false,
  }) async {
    if (!fromButton) return;
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';

    try {
      final response = await ApiServiceTr.TransaksiOut(
        idMember ?? '',
        produk,
        metodePem,
        totalTr,
        diskon ?? '',
        statusTr,
        potPoin ?? '',
        getPoin ?? '',
        userInput,
      );
      if (response['status'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'],
          backgroundColor: Colors.green,
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTransaksiStruk() async {
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse(urlTr + "/transaksi_out/struk"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          var transaksiData = jsonData['data'];
          // Ambil nilai yang diinginkan
          idTransaksiOut = transaksiData['id'] ?? 'Tidak ada';
          print('ID TRANSAKSI!' + ' $idTransaksiOut');
          noTransaksi = transaksiData['no_transaksi_out'] ?? 'Tidak ada';
          diskonStruk = transaksiData['diskon'] ?? '0';
          bayarTransaksi = transaksiData['total_transaksi'] ?? '0';
        } else {
          throw Exception('Failed to load data');
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

  Future<void> kasbonMember(
    String idMember,
    String totalKasbon,
    String statusKasbon,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiServiceTr.kasbonMember(
      idMember,
      totalKasbon,
      statusKasbon,
      userInput,
    );
    try {
      if (response['status'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'],
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
      } else if (response['status'] == false) {
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

  Future<void> detKasbon(
    String idTransaksi,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    try {
      final response = await ApiServiceTr.detKasbon(
        idTransaksi,
        userInput,
      );
      if (response['status'] == true) {
        print('HASIL' + ' $response');
      } else if (response['status'] == false) {
        print('HASIL' + ' $response');
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

  Future<void> addAllDetailTransaksiOut(List<dynamic> listDibeli) async {
    print('MENERIMA ITEM UNTUK DIPROSES: $listDibeli');
    for (var item in listDibeli) {
      try {
        print('Memproses item: ${item['id']}');
        await addDetailTransaksiOut(
          item['id'] ?? '',
          item['Jumlah'].toString(),
          item['harga_satuan'].toString(),
          item['harga'].toString(),
          addOnHarga(item['addOn']).toString(),
        );
        await kurangStok(item['id'] ?? '', item['Jumlah'].toString());
      } catch (e) {
        print('Gagal memproses item: ${item['id']} - Error: $e');
      }
    }
  }

  Future<void> addDetailTransaksiOut(
    String idProduk,
    String jumlah,
    String hargaSatuan,
    String hargaJual,
    String hargaAddOn,
  ) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    try {
      final response = await ApiServiceTr.addDetTransaksiOut(
        idProduk,
        jumlah,
        hargaSatuan,
        hargaJual,
        hargaAddOn,
        userInput,
      );
      if (response['status'] == true) {
        print("Hasil Dari Detail BERHASIl" + response['message']);
      } else if (response['status'] == false) {
        print("Hasil Dari Detail GAGAL" + response['message']);
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

  Future<void> scanForDevices() async {
    try {
      bool? isConnectedStatus = await printer.isConnected;

      if (isConnectedStatus != null && isConnectedStatus) {
        print("Printer sudah terhubung.");
        return;
      }

      print("Scanning perangkat yang sudah dipasangkan...");
      List<BluetoothDevice> devices = await printer.getBondedDevices();
      print("Jumlah perangkat ditemukan: ${devices.length}");

      if (devices.isNotEmpty) {
        for (var dev in devices) {
          print("Perangkat ditemukan: ${dev.name} - ${dev.address}");
        }

        device = devices.first;
        await connectToPrinter(device!);
      } else {
        print("Tidak ada perangkat printer yang ditemukan.");
      }
    } catch (e) {
      print("Error saat mencari perangkat: $e");
    }
  }

  // Untuk menghubungkan ke printer
  Future<void> connectToPrinter(BluetoothDevice device) async {
    try {
      await printer.connect(device);
      isConnected.value = true;
      print("Berhasil terhubung ke printer: ${device.name}");
    } catch (e) {
      print("Gagal menghubungkan ke printer: $e");
    }
  }

  // Untuk memutuskan koneksi dengan printer
  Future<void> disconnectPrinter() async {
    try {
      if ((await printer.isConnected)!) {
        await printer.disconnect();
        print("Printer telah diputuskan.");
      } else {
        print("Printer sudah dalam keadaan tidak terhubung.");
      }
    } catch (e) {
      print("Error saat memutuskan koneksi: $e");
    }
  }

  // Untuk mencetak teks
  Future<void> printReceipt(String text, String metode) async {
    if ((await printer.isConnected)!) {
      printer.printNewLine();
      String formattedDate =
          DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      String? member = MemberName;
      String poinMember = MemberPoin.toString();
      String totalHargaSt = NumberFormat('#,##0', 'id_ID')
          .format(double.parse(totalHarga.toString()));

      String totalHargaSebelumSt = NumberFormat('#,##0', 'id_ID')
          .format(double.parse(totalHargaSebelum.toString()));
      String totalBayar = NumberFormat('#,##0', 'id_ID')
          .format(double.parse(bayarTransaksi.toString()));
      double kembalian = double.parse(bayarTransaksi.toString()) -
          double.parse(totalHarga.toString());
      String kembalianSt = NumberFormat('#,##0', 'id_ID').format(kembalian);

      String diskonRupiah = NumberFormat('#,##0', 'id_ID')
          .format(double.parse(diskonStruk.toString()));

      // Header - Nama Toko
      printer.printCustom("Koperasi", 2, 1);
      printer.printCustom("Artha Abadi", 2, 1);
      printer.printNewLine();
      printer.printCustom("Jl. Raya Jakarta-Bogor No.KM.37", 0, 1);
      printer.printCustom("Sukamaju, Kec. Cilodong,", 0, 1);
      printer.printCustom(" Kota Depok, Jawa Barat 16415", 0, 1);
      printer.printCustom("Telp. Kantor: (021) 29629393", 0, 1);
      printer.printNewLine();

      // Info Transaksi
      printer.printLeftRight("Tanggal", formattedDate.toString(), 0);
      printer.printLeftRight("Kasir", userInput.toString(), 0);
      printer.printLeftRight("No. Transaksi", noTransaksi ?? "Tidak ada", 0);
      printer.printCustom("--------------------------------", 0, 1);
      printer.printLeftRight("Nama Produk", "Harga", 0);
      printer.printCustom("--------------------------------", 0, 1);
      // Loop here
      Set<String> displayedProducts = {};
      for (var i = 0; i < listProduk.length; i++) {
        if (listProduk[i]['listDibeli'].isNotEmpty) {
          for (var x = 0; x < listProduk[i]['listDibeli'].length; x++) {
            String productKey =
                '${listProduk[i]['nama']}-${listProduk[i]['listDibeli'][x]['tipe']}';
            if (!displayedProducts.contains(productKey)) {
              displayedProducts.add(productKey);
              String productName = listProduk[i]['nama'];
              String productPrice = NumberFormat('#,##0', 'id_ID').format(
                  double.parse(
                      listProduk[i]['listDibeli'][x]['harga'].toString()));
              String quantity = listProduk[i]['listDibeli'].length.toString();
              // Ambil harga per produk dalam bentuk double
              double hargaPerItem = double.parse(
                  listProduk[i]['listDibeli'][x]['harga'].toString());

              int jumlah = listProduk[i]['listDibeli'].length;

              double totalHarga = hargaPerItem * jumlah;

              String formattedTotal =
                  NumberFormat('#,##0', 'id_ID').format(totalHarga);

              // Mencetak nama produk dan subtotal
              printer.printLeftRight("$productName", "$formattedTotal", 0);
              printer.printLeftRight("Qty: $quantity x $productPrice", "", 0);
              String idAddOn =
                  listProduk[i]['listDibeli'][x]['addOn'].toString();
              if (idAddOn != "1") {
                String addOnNama = addOnName(idAddOn);
                String addOnHargaStr =
                    NumberFormat('#,##0', 'id_ID').format(addOnHarga(idAddOn));
                printer.printLeftRight("$addOnNama", "+$addOnHargaStr", 0);
              }
            }
          }
        }
      }

      printer.printCustom("--------------------------------", 0, 1);

      // Total Pembayaran
      printer.printLeftRight("Subtotal", totalHargaSebelumSt.toString(), 0);
      printer.printLeftRight("Diskon", diskonRupiah ?? "null", 0);
      printer.printLeftRight("Total", totalHargaSt.toString(), 0);
      // Nanti diambil setelah Transaksi selesai dikirim
      printer.printLeftRight("Bayar ($metode)", totalBayar ?? "0", 0);
      // Nanti diambil setelah Transaksi selesai dikirim
      printer.printLeftRight("Kembalian", kembalianSt, 0);
      printer.printCustom("--------------------------------", 0, 1);

      printer.printLeftRight(
          "Nama Member", member.toString() ?? "Non Member", 0);
      printer.printLeftRight(
          "Poin Member", poinMember.toString() ?? "Non Member", 0);
      printer.printCustom("--------------------------------", 0, 1);

      // Pesan Penutup
      printer.printCustom("Terima Kasih!", 0, 1);
      printer.printCustom("Selamat Berbelanja Kembali", 0, 1);

      // Potong Kertas
      printer.printNewLine();
      printer.printNewLine();
      printer.paperCut();
    } else {
      print("Printer tidak terhubung.");
    }
  }

  // Mengecek status koneksi
  Future<bool> checkPrinterStatus() async {
    bool? isConnectedStatus = await printer.isConnected;
    if (isConnectedStatus != null && isConnectedStatus) {
      return true; // Printer terhubung
    } else {
      return false; // Printer tidak terhubung
    }
  }

  void setData2() {
    produk.value = [
      {
        "nama": 'Botol Aqua',
        "harga": '5000',
        "varian": null,
        "jumlah": "2",
        "jumlahDibeli": 0,
        "listDibeli": [],
        "foto":
            "https://solvent-production.s3.amazonaws.com/media/images/products/2021/06/DSC_0047_copy_TaS0jlu.jpg"
      },
      {
        "nama": 'Indomie Goreng',
        "harga": '4000',
        "varian": [
          {
            "varian": "direbus",
            "plus_harga": "3000",
          },
          {
            "varian": "mentah",
            "plus_harga": "3000",
          }
        ],
        "jumlah": "10",
        "jumlahDibeli": 0,
        "listDibeli": [],
        "foto":
            "https://images.tokopedia.net/img/cache/700/VqbcmM/2024/4/13/a55ae577-91f2-444c-851e-9d5c8a0c3673.jpg"
      },
      {
        "nama": 'Yakult',
        "harga": '3000',
        "varian": null,
        "jumlah": "12",
        "jumlahDibeli": 0,
        "listDibeli": [],
        "foto":
            "https://res.cloudinary.com/dk0z4ums3/image/upload/v1709014802/attached_image/yakult.jpg"
      },
      {
        "nama": 'Golda Coffee',
        "harga": '4500',
        "varian": null,
        "jumlah": "9",
        "jumlahDibeli": 0,
        "listDibeli": [],
        "foto":
            "https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//101/MTA-2644895/golda_golda-coffee-dolce-latte--200-ml--pet-_full03.jpg"
      },
    ];
  }
}
