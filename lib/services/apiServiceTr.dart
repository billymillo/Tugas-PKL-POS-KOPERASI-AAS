import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceTr {
  static const String baseUrlTr = 'http://10.10.20.50/POS_CI/api';

  Future<String?> getUserInput() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  static Future<Map<String, dynamic>> TransaksiOut(
    String idMember,
    String produk,
    String metodePem,
    String totalTr,
    String diskon,
    String statusTr,
    String potPoin,
    String getPoin,
    String userInput,
  ) async {
    final url = '$baseUrlTr/transaksi_out';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'id_member': idMember,
          'jumlah_produk': produk,
          'id_metode_pembayaran': metodePem,
          'total_transaksi': totalTr,
          'diskon': diskon,
          'status_transaksi': statusTr,
          'potongan_poin': potPoin,
          'mendapatkan_poin': getPoin,
          'user_input': userInput,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  Future<Map<String, dynamic>> tambahPoin(String id, String poin) async {
    final url = '$baseUrlTr/member/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'poin': poin,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> kurangStok(String id, String stok) async {
    final url = '$baseUrlTr/product/kurang';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'stok': stok,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> tambahStok(
      String id, String stok, String userUpdate) async {
    final url = '$baseUrlTr/product/tambah';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'stok': stok,
        'user_update': userUpdate,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> gunakanSaldo(String id, String saldo) async {
    final url = '$baseUrlTr/member/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'saldo': saldo,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> member(
    String nama,
    String idPeg,
    String no_tlp,
    String saldo,
    String poin,
    String userInput,
  ) async {
    final url = '$baseUrlTr/member';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'nama': nama,
        'id_peg_system': idPeg,
        'no_tlp': no_tlp,
        'saldo': saldo,
        'poin': poin,
        'user_input': userInput
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> editMember(String id, String nama, String no_tlp,
      String saldo, String poin, String update) async {
    final url = '$baseUrlTr/member/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'nama': nama,
        'no_tlp': no_tlp,
        'saldo': saldo,
        'poin': poin,
        'user_update': update,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteMember(
    String id,
  ) async {
    final url = '$baseUrlTr/member/$id';
    final response = await http.delete(
      Uri.parse(url),
      body: {
        'id': id,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> metode(
    String metode,
    String userInput,
  ) async {
    final url = '$baseUrlTr/transaksi_in/pembayaran';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'metode': metode,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> editMetode(
      String id, String metode, String update) async {
    final url = '$baseUrlTr/transaksi_in/pembayaran/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {'id': id, 'metode': metode, 'user_update': update},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteMetode(
    String id,
  ) async {
    final url = '$baseUrlTr/transaksi_in/pembayaran/$id';
    final response = await http.delete(
      Uri.parse(url),
      body: {
        'id': id,
      },
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> kasbonMember(
    String idMember,
    String totalKasbon,
    String statusKasbon,
    String userInput,
  ) async {
    final url = '$baseUrlTr/kasbon';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_member': idMember,
          'total_kasbon': totalKasbon,
          'id_status': statusKasbon,
          'user_input': userInput,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> detKasbon(
    String idTransaksi,
    String userInput,
  ) async {
    final url = '$baseUrlTr/kasbon/detail';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_transaksi_out': idTransaksi,
          'user_input': userInput,
        },
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> pemKasbon(
    String idKasbon,
    String totalBayar,
    String userUpdate,
  ) async {
    final url = '$baseUrlTr/kasbon/pembayaran';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_kasbon': idKasbon,
          'total_bayar': totalBayar,
          'user_update': userUpdate,
        },
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  Future<Map<String, dynamic>> lunasKasbon(
    String id,
    String totalKasbon,
    String statusTr,
    String userUpdate,
  ) async {
    final url = '$baseUrlTr/transaksi_out/';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'total_transaksi': totalKasbon,
        'status_transaksi': statusTr,
        'user_update': userUpdate,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteKasbon(
      String id, String userUpdate) async {
    final url = '$baseUrlTr/kasbon';
    final response = await http.delete(
      Uri.parse(url),
      body: {
        'id': id,
        'user_update': userUpdate,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> addDetTransaksiOut(
    String idProduk,
    String jumlah,
    String hargaSatuan,
    String hargaJual,
    String hargaAddOn,
    String userInput,
  ) async {
    final url = '$baseUrlTr/transaksi_out/detail';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_produk': idProduk,
          'jumlah': jumlah,
          'harga_satuan': hargaSatuan,
          'harga_jual': hargaJual,
          'harga_add_on': hargaAddOn,
          'user_input': userInput,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return {
          'status': true,
          'message': jsonData['message'],
          'data': jsonData['data'],
        };
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> addDetTransaksiIn(
    String idProduk,
    String jumlah,
    String hargaSatuan,
    String hargaJual,
    String userInput,
  ) async {
    final url = '$baseUrlTr/transaksi_in/detail';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_produk': idProduk,
          'jumlah': jumlah,
          'harga_satuan': hargaSatuan,
          'harga_jual': hargaJual,
          'user_input': userInput,
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> addDetTransaksiMitra(
    String idProduk,
    String jumlah,
    String hargaSatuan,
    String hargaJual,
    String userInput,
  ) async {
    final url = '$baseUrlTr/transaksi_mitra/detail';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_produk': idProduk,
          'jumlah': jumlah,
          'harga_satuan': hargaSatuan,
          'harga_jual': hargaJual,
          'user_input': userInput,
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> addTransaksiIn(
    String jumlah,
    String total,
    String userInput,
  ) async {
    final url = '$baseUrlTr/transaksi_in/';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'jumlah_produk': jumlah,
          'total_transaksi': total,
          'user_input': userInput,
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  static Future<Map<String, dynamic>> addTransaksiInMitra(
    String mitra,
    String jumlah,
    String total,
    String status,
    String userInput,
  ) async {
    final url = '$baseUrlTr/transaksi_mitra/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_mitra': mitra,
          'jumlah_produk': jumlah,
          'total_transaksi': total,
          'status_transaksi': status,
          'user_input': userInput,
        },
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  Future<Map<String, dynamic>> duplikatProduk(
    String idProduk,
    String stok,
    String hargaSatuan,
    String hargaJual,
    String userUpdate,
  ) async {
    final url = '$baseUrlTr/product/duplicate';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id': idProduk,
          'stok': stok,
          'harga_satuan': hargaSatuan,
          'harga_jual': hargaJual,
          'user_update': userUpdate,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': false,
          'message': 'Error ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'status': false, 'message': 'Request failed: $e'};
    }
  }

  Future<Map<String, dynamic>> editProduk(String id, String stok,
      String hargaSatuan, String hargaJual, String userUpdate) async {
    final url = '$baseUrlTr/product/ubah/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'stok': stok,
        'harga_satuan': hargaSatuan,
        'harga_jual': hargaJual,
        'user_update': userUpdate,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> addTransaksiAddOn(
      String idAddon, String idDetTransaksi, String userInput) async {
    final url = '$baseUrlTr/addon/transaksi';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id_add_on': idAddon,
        'id_det_transaksi_out': idDetTransaksi,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }
}
