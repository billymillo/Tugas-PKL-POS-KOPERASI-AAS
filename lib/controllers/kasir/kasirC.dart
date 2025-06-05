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
  final FocusNode barcodeFocusNode = FocusNode();
  var saldoController = TextEditingController();
  var topUpController = TextEditingController();

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
  String qrData =
      '00020101021126570011ID.DANA.WWW011893600915335349417602093534941760303UMI51440014ID.CO.QRIS.WWW0215ID10222268651970303UMI5204541153033605802ID5925Koperasi Anugrah Artha Ab6010Kota Depok6105164126304A768';

  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var url = ApiService.baseUrl + '/product';

  var urlTr = ApiServiceTr.baseUrlTr;
  var member = <Map<String, dynamic>>[].obs;
  var addOn = <Map<String, dynamic>>[].obs;
  var addOnPr = <Map<String, dynamic>>[].obs;
  var addOnTr = <Map<String, dynamic>>[].obs;
  var struk = <Map<String, dynamic>>[].obs;
  var selectedMember = Rxn<String>();
  var filteredMembers = <Map<String, dynamic>>[].obs;

  var status = <Map<String, dynamic>>[].obs;
  RxBool checkbox = false.obs;
  RxBool checkboxSaldo = false.obs;
  RxInt diskon = 0.obs;
  var transaksiId = ''.obs;

  var isLoading = true.obs;
  var isPrinting = false.obs;

  BlueThermalPrinter printer = BlueThermalPrinter.instance;
  BluetoothDevice? device;
  RxBool isConnected = false.obs;
  var selectedAddOn = <String>[].obs;
  var jumlahPesanan = 0.obs;

  var saldoInput = 0.obs;
  var topUpInput = 0.obs;

  double get totalHarga {
    double total = 0;

    for (var produk in listProduk) {
      if (produk['listDibeli'] != null) {
        for (var item in produk['listDibeli']) {
          total += double.tryParse(item['harga'].toString()) ?? 0;

          var addOns = item['addOn'];
          if (addOns is List && addOns.isNotEmpty && addOns.first != '1') {
            for (var id in addOns) {
              total +=
                  double.tryParse(addOnHarga(id.toString()).toString()) ?? 0;
            }
          }
        }
      }
    }

    double diskon = 0;
    if (checkbox.value && double.tryParse(MemberPoin.toString())! < total) {
      diskon = double.tryParse(MemberPoin.toString()) ?? 0;
    }

    double saldoDigunakan = 0;
    double saldo = double.tryParse(MemberSaldo.toString()) ?? 0;
    double totalHargaDiskon = total - diskon;

    if (checkboxSaldo.value) {
      if (totalHargaDiskon > saldo) {
        return totalHargaDiskon;
      } else if (totalHargaDiskon == saldo) {
        return 0;
      } else {
        return 0;
      }
    }

    return total - diskon - saldoDigunakan;
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
      } else if (checkbox.value == true) {
        return 0;
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

  int get saldoUpdate {
    if (selectedMember.value == null) return 0;

    int currentMemberSaldo = int.tryParse(MemberSaldo) ?? 0;
    int poin = int.tryParse(MemberPoin) ?? 0;

    double total = 0;
    for (var produk in listProduk) {
      if (produk['listDibeli'] != null) {
        for (var item in produk['listDibeli']) {
          total += double.tryParse(item['harga'].toString()) ?? 0;

          var addOns = item['addOn'];
          if (addOns is List && addOns.isNotEmpty && addOns.first != '1') {
            for (var id in addOns) {
              total +=
                  double.tryParse(addOnHarga(id.toString()).toString()) ?? 0;
            }
          }
        }
      }
    }
    int diskon = checkbox.value ? poin : 0;
    int totalHargaDiskon = (total - diskon).round();

    if (checkboxSaldo.value) {
      if (totalHargaDiskon > currentMemberSaldo) {
        return 0;
      } else if (totalHargaDiskon == currentMemberSaldo) {
        return currentMemberSaldo;
      } else {
        return totalHargaDiskon;
      }
    } else {
      return 0;
    }
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
    fetchAddonPr();
    fetchAddonTr();
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

  void tambahKeKeranjang(int i, varian, {List<String> addOnValue = const []}) {
    if (int.parse(filteredProduk[i]['jumlah']) >
        filteredProduk[i]['jumlahDibeli']) {
      filteredProduk[i]['jumlahDibeli'] += 1;

      if (varian.toString() == 'null') {
        banyakDibeli.value += 1;
        filteredProduk[i]['listDibeli'].add({
          "id": filteredProduk[i]['id'],
          "tipe": null,
          "Jumlah": '1',
          "harga": filteredProduk[i]['harga'],
          "harga_satuan": filteredProduk[i]['harga_satuan'],
          "addOn": addOnValue,
        });
      }

      simpanJumlahDibeli(
        filteredProduk[i]['id'],
        filteredProduk[i]['jumlahDibeli'],
        filteredProduk[i]['listDibeli'],
      );

      filteredProduk.refresh();
    } else {
      Get.snackbar(
        'Stok Produk Terbatas',
        'Tidak Bisa Membeli Produk Lebih Dari Stok Yang Ada.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    print("Jumlah Dibeli: ${filteredProduk[i]['jumlahDibeli']}");
    print("List Dibeli: ${filteredProduk[i]['listDibeli']}");
    print('banyak dibeli ${banyakDibeli.value}');
  }

  void simpanJumlahDibeli(
      String idProduk, int jumlahDibeliBaru, List listDibeliBaru) {
    final index = listProduk.indexWhere((e) => e['id'] == idProduk);
    if (index != -1) {
      listProduk[index]['jumlahDibeli'] = jumlahDibeliBaru;
      listProduk[index]['listDibeli'] = listDibeliBaru;
    }
  }

  void hapusKeranjang({
    required String nama,
    required List<String> addOn,
  }) {
    for (var i = 0; i < listProduk.length; i++) {
      var produk = listProduk[i];
      if (produk['nama'] == nama) {
        for (var j = 0; j < produk['listDibeli'].length; j++) {
          var item = produk['listDibeli'][j];

          List<String> itemAddOn = List<String>.from(item['addOn'] ?? []);
          List<String> addOnParam = List<String>.from(addOn);
          itemAddOn.sort();
          addOnParam.sort();

          bool isSameAddOn = itemAddOn.join(',') == addOnParam.join(',');

          if (isSameAddOn) {
            var idTerhapus = item['id'];
            var namaTerhapus = produk['nama'];
            print(
                "Barang dihapus: ID: $idTerhapus | Nama: $namaTerhapus | AddOn: $itemAddOn");

            produk['listDibeli'].removeAt(j);
            produk['jumlahDibeli'] -= 1;
            banyakDibeli.value -= 1;
            filteredProduk.refresh(); // tetap refresh tampilan
            return;
          }
        }
      }
    }
  }

  void searchProduk(String query) {
    searchQuery.value = query;
    filteredProduk.assignAll(listProduk.where((produk) {
      return produk['nama'].toLowerCase().contains(query.toLowerCase()) ||
          produk['barcode']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          produk['kategori']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          produk['tipe']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          produk['mitra']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
    }).toList());
  }

  Future<void> fetchProduk() async {
    var url = ApiService.baseUrl;
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(url + "/product"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          setData1(jsonData['data']);
          addAllItems();
        } else {
          throw Exception('Gagal mengambil data produk');
        }
      } else {
        throw Exception('Gagal load data api');
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
      });
      if (filtered.isEmpty) {
        addAllItems();
      } else {
        filteredProduk.assignAll(filtered); // referensi asli, bukan .toList()
      }
    }
  }

  void kategoriProdukTipe() {
    var filtered = listProduk.where((produk) => produk['tipe'] == '2');
    filteredProduk.assignAll(filtered); // tanpa .toList()
  }

  void addAllItems() {
    filteredProduk.assignAll(listProduk);
  }

  void setData1(List<dynamic> data) {
    listProduk.value = List<Map<String, dynamic>>.from(data.map((item) => {
          "id": item['id'],
          "nama": item['nama_barang'],
          "barcode": item['barcode_barang'].toString(),
          "harga": item['harga_jual'].toString(),
          "harga_satuan": item['harga_satuan'].toString(),
          "tipe": item['id_tipe_barang'].toString(),
          "mitra": item['mitra_name'] ?? "Tidak Memiliki Mitra",
          "kategori": item['kategori_name'],
          "addOn": [],
          "jumlah": item['stok'].toString(),
          "jumlahDibeli": 0,
          "listDibeli": [],
          "foto": "http://10.10.20.109/POS_CI/uploads/${item['gambar_barang']}",
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
      var response = await http.get(Uri.parse(urlTr + "/addon"));
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

  Future<void> fetchAddonPr() async {
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse(urlTr + "/addon/produk"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          addOnPr.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> fetchAddonTr() async {
    try {
      isLoading.value = true;
      var response = await http.get(Uri.parse(urlTr + "/addon/transaksi"));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          addOnTr.value = List<Map<String, dynamic>>.from(jsonData['data']);
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

  Future<void> addTransaksiAddOn(String idAddon, String idDetTransaksi) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userInput = prefs.getString('name') ?? 'system';
      final response = await apiServiceTr.addTransaksiAddOn(
          idAddon, idDetTransaksi, userInput);
      if (response['status'] == true) {
        print('ID : $idAddon dan $idDetTransaksi');
        print('AddOn Success: $response');
      } else if (response['status'] == false) {
        print('AddOn Gagal: $response');
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

  void updateAddOnToProduk() {
    for (var i = 0; i < listProduk.length; i++) {
      var produk = listProduk[i];
      var matchingAddOns = addOnPr
          .where(
              (item) => item['id_produk'].toString() == produk['id'].toString())
          .toList();
      produk['addOn'] = matchingAddOns.isNotEmpty ? matchingAddOns : [];
      listProduk[i] = Map<String, dynamic>.from(produk);
    }
    listProduk.refresh();
  }

  void toggleAddOnSelection(String id) {
    if (selectedAddOn.contains(id)) {
      selectedAddOn.remove(id);
    } else {
      selectedAddOn.add(id);
    }
  }

  int totalAddOnHarga() {
    int total = 0;
    for (var id in selectedAddOn) {
      total += addOnHarga(id);
    }
    return total;
  }

  Future<void> refreshPage() async {
    selectedMember.value = null;
    await fetchProduk();
    await fetchKategori();
    await fetchMember();
    await fetchStatus();
    banyakDibeli.value = 0;
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

  Future<void> ubahPoin(
    String id,
    String poin,
  ) async {
    isLoading.value = true;
    try {
      final response = await apiServiceTr.ubahPoin(
        id,
        poin,
      );
      if (response['status'] == true) {
        print('Berhasil' + response['message']);
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

  Future<void> ubahSaldo(
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
        print(response['message']);
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
      var response = await http.get(Uri.parse(urlTr + "/status"));
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
    String jumlah,
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
        jumlah,
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
        print(response['message']);
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

  Future<void> topupSaldo(
      String idMember, String totalKasbon, String idMetode) async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? userInput = prefs.getString('name') ?? 'system';
    final response = await ApiServiceTr.addTopup(
      idMember,
      totalKasbon,
      idMetode,
      userInput,
    );
    try {
      if (response['status'] == true) {
        Get.snackbar(
          'Berhasil',
          response['message'],
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
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

    List<Map<String, dynamic>> groupedList = [];

    for (var item in listDibeli) {
      final String idProduk = item['id'].toString();
      final List addOnList = item['addOn'] ?? [];
      final String addOnKey = addOnList.isEmpty
          ? ''
          : addOnList.map((e) => e.toString()).toList().join(',');

      final String groupKey = '$idProduk|$addOnKey';

      final existingIndex =
          groupedList.indexWhere((e) => e['groupKey'] == groupKey);

      int itemJumlah = int.tryParse(item['Jumlah'].toString()) ?? 1;
      int itemHarga = int.tryParse(item['harga'].toString()) ?? 0;
      int itemHargaSatuan = int.tryParse(item['harga_satuan'].toString()) ?? 0;

      int itemAddOnHarga = 0;
      for (var addOnId in addOnList) {
        itemAddOnHarga +=
            int.tryParse(addOnHarga(addOnId.toString()).toString()) ?? 0;
      }

      if (existingIndex != -1) {
        groupedList[existingIndex]['Jumlah'] += itemJumlah;
        groupedList[existingIndex]['totalAddOn'] += itemAddOnHarga;
      } else {
        groupedList.add({
          'groupKey': groupKey,
          'id': idProduk,
          'Jumlah': itemJumlah,
          'harga_satuan': itemHargaSatuan,
          'harga': itemHarga,
          'addOn': addOnList,
          'totalAddOn': itemAddOnHarga,
        });
      }
    }

    // Proses kirim hasil akhir
    for (var item in groupedList) {
      try {
        await addDetailTransaksiOut(
          item['id'].toString(),
          item['Jumlah'].toString(),
          item['harga_satuan'].toString(),
          item['harga'].toString(),
          item['totalAddOn'].toString(),
          item['addOn'],
        );
        await kurangStok(item['id'].toString(), item['Jumlah'].toString());
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
    List addOn,
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
        print(
            "Hasil Dari Detail BERHASIL " + response['data']['id'].toString());
        print("Hasil Dari Detail BERHASIL " + response['message']);
        final String idDetTransaksi = response['data']['id'].toString();
        if (addOn.isNotEmpty) {
          for (var idAddOn in addOn) {
            await addTransaksiAddOn(idAddOn.toString(), idDetTransaksi);
          }
        }
      } else {
        print("Hasil Dari Detail GAGAL " + response['message']);
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
      Map<String, Map<String, dynamic>> groupedProducts = {};

      for (var produk in listProduk) {
        if (produk['listDibeli'] != null && produk['listDibeli'].isNotEmpty) {
          for (var item in produk['listDibeli']) {
            String idProduk = item['id'].toString();
            String namaProduk = produk['nama'];
            int jumlah = int.tryParse(item['Jumlah'].toString()) ?? 1;
            int hargaJual = int.tryParse(item['harga_jual'].toString()) ?? 0;
            List<dynamic> addOnList = item['addOn'] ?? [];
            List<String> addonIds = addOnList.map((a) => a.toString()).toList()
              ..sort();
            String addonKey = addonIds.join(',');
            String key = '$idProduk|$addonKey';

            int totalAddOnHarga = 0;
            for (var addOnId in addonIds) {
              totalAddOnHarga += addOnHarga(addOnId);
            }

            if (!groupedProducts.containsKey(key)) {
              groupedProducts[key] = {
                'nama': namaProduk,
                'jumlah': jumlah,
                'harga_jual': hargaJual,
                'totalAddOn': totalAddOnHarga,
                'addOn': addonIds,
              };
            } else {
              groupedProducts[key]!['jumlah'] += jumlah;
              groupedProducts[key]!['totalAddOn'] += totalAddOnHarga;
            }
          }
        }
      }

      groupedProducts.forEach((key, value) {
        String nama = value['nama'];
        int hargaSatuan = value['harga_satuan'];
        int jumlah = value['jumlah'];
        int totalAddOnHarga = value['totalAddOn'];
        List<String> addonIds = value['addOn'];

        int hargaPerItem =
            hargaSatuan + (addonIds.isEmpty ? 0 : totalAddOnHarga ~/ jumlah);
        int totalHarga = hargaPerItem * jumlah;

        String formattedHargaPerItem =
            NumberFormat('#,##0', 'id_ID').format(hargaPerItem);
        String formattedTotalHarga =
            NumberFormat('#,##0', 'id_ID').format(totalHarga);

        printer.printLeftRight("$nama", "$formattedTotalHarga", 0);
        printer.printLeftRight("Qty: $jumlah x $formattedHargaPerItem", "", 0);

        if (addonIds.isNotEmpty) {
          for (var addOnId in addonIds) {
            String namaAddOn = addOnName(addOnId);
            int hargaAddOn = addOnHarga(addOnId);
            String hargaAddOnFormat =
                NumberFormat('#,##0', 'id_ID').format(hargaAddOn);
            printer.printCustom(" + $namaAddOn ($hargaAddOnFormat)", 0, 0);
          }
        }
      });

      printer.printCustom("--------------------------------", 0, 1);

      // Total Pembayaran
      printer.printLeftRight("Diskon", diskonRupiah ?? "null", 0);
      printer.printLeftRight("Total", totalHargaSt.toString(), 0);
      // Nanti diambil setelah Transaksi selesai dikirim
      printer.printLeftRight("Bayar ($metode)", totalBayar ?? "0", 0);
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
