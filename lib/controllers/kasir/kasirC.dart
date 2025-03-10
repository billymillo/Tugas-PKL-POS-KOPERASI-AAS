import 'dart:convert';

import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/services/apiService.dart';
import 'package:bluetooth_thermal_printer_example/services/apiServiceTr.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class KasirC extends GetxController {
  TextEditingController searchController = TextEditingController();

  var listProduk = <Map<String, dynamic>>[].obs;
  RxList<dynamic> selectedVarian = [].obs;
  RxInt banyakDibeli = 0.obs;
  RxString searchQuery = ''.obs;

  var produk = <Map<String, dynamic>>[].obs;
  var kategori = <Map<String, dynamic>>[].obs;
  var filteredProduk = <Map<String, dynamic>>[].obs;
  var selectedCategory = 'All'.obs;
  var metodePembayaran = 0.obs;
  var statusTr = 0.obs;

  final ApiServiceTr apiServiceTr = ApiServiceTr();
  var url = ApiService.baseUrl + '/product';

  var urlTr = ApiServiceTr.baseUrlTr;
  var member = <Map<String, dynamic>>[].obs;
  var selectedMember = Rxn<String>();
  var filteredMembers = <Map<String, dynamic>>[].obs;

  var status = <Map<String, dynamic>>[].obs;
  RxBool checkbox = false.obs;
  RxInt diskon = 0.obs;

  var isLoading = true.obs;

  double get totalHarga {
    double total = 0;
    for (var produk in listProduk) {
      if (produk['listDibeli'] != null) {
        for (var item in produk['listDibeli']) {
          total += double.tryParse(item['harga'].toString()) ?? 0;
        }
      }
    }
    double diskon = 0;
    if (checkbox.value && double.tryParse(MemberPoin.toString())! < total) {
      diskon = double.tryParse(MemberPoin.toString()) ?? 0 * 10;
    }
    return total - diskon;
  }

  int get poinUpdate {
    int currentMemberPoin = int.tryParse(MemberPoin) ?? 0;
    if (selectedMember.value == null) {
      return 0;
    } else {
      if (checkbox.value == false) {
        return (totalHarga ~/ 100) + currentMemberPoin;
      } else {
        return 0;
      }
    }
  }

  int get poinDapat {
    int currentMemberPoin = int.tryParse(MemberPoin) ?? 0;
    int poinUpdate = (totalHarga ~/ 100) + currentMemberPoin;
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
      orElse: () => {'nama': 'Tidak Ada'},
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

  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    fetchProduk();
    fetchKategori();
    fetchMember();

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

  void searchProduk(String query) {
    searchQuery.value = query;
    filteredProduk.assignAll(listProduk.where((produk) {
      return produk['nama'].toLowerCase().contains(query.toLowerCase());
    }).toList());
  }

  void tambahKeKeranjang(i, varian) {
    if (int.parse(filteredProduk[i]['jumlah']) >
        filteredProduk[i]['jumlahDibeli']) {
      filteredProduk[i]['jumlahDibeli'] = filteredProduk[i]['jumlahDibeli'] + 1;
      if (varian.toString() == 'null') {
        banyakDibeli.value = banyakDibeli.value + 1;
        filteredProduk[i]['listDibeli'].add(
            {"tipe": null, "Jumlah": '1', 'harga': filteredProduk[i]['harga']});
      }
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
      filteredProduk.assignAll(listProduk.asMap().entries.map((entry) {
        return {...entry.value, 'originalIndex': entry.key};
      }).toList());
    } else {
      var filtered = listProduk.asMap().entries.where((entry) {
        return entry.value['kategori']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).map((entry) {
        return {...entry.value, 'originalIndex': entry.key};
      }).toList();

      if (filtered.isEmpty) {
        addAllItems();
      }
      filteredProduk.assignAll(filtered);
    }
  }

  void kategoriProdukTipe() {
    var filtered = listProduk.asMap().entries.where((entry) {
      return entry.value['tipe'] == '2';
    }).map((entry) {
      return {...entry.value, 'originalIndex': entry.key};
    }).toList();
    print(filtered);
    filteredProduk.assignAll(filtered);
  }

  void addAllItems() {
    filteredProduk.assignAll(listProduk);
  }

  void setData1(List<dynamic> data) {
    listProduk.value = List<Map<String, dynamic>>.from(data.map((item) => {
          "nama": item['nama_barang'],
          "harga": item['harga_jual'].toString(),
          "tipe": item['id_tipe_barang'].toString(),
          "mitra": item['mitra_name'] ?? "Tidak Memiliki Mitra",
          "kategori": item['kategori_name'],
          "jumlah": item['stok'].toString(),
          "jumlahDibeli": 0,
          "listDibeli": [],
          "foto": "http://10.10.20.240/POS_CI/uploads/${item['gambar_barang']}",
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
        final kategori = member['kategori_name'].toString().toLowerCase();
        final tipe = member['tipe_name'].toString().toLowerCase();
        final mitra = member['mitra_name'].toString().toLowerCase();

        return nama.contains(query.toLowerCase()) ||
            id.contains(query.toLowerCase()) ||
            kategori.contains(query.toLowerCase()) ||
            tipe.contains(query.toLowerCase()) ||
            mitra.contains(query.toLowerCase());
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
          response['message'],
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

  Future<void> kasbonMember(
    String idMember,
    String totalKasbon,
    String statusKasbon,
  ) async {
    isLoading.value = true;
    try {
      final response = await ApiServiceTr.kasbonMember(
        idMember,
        totalKasbon,
        statusKasbon,
      );
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
    } finally {
      isLoading.value = false;
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
