import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceTr {
  static const String baseUrlTr = 'http://10.10.20.240/POS_CI/api';

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

  Future<Map<String, dynamic>> kurangStok(
      String id, String stok) async {
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

  Future<Map<String, dynamic>> member(String nama, String idPeg, String no_tlp,
      String saldo, String poin) async {
    final url = '$baseUrlTr/member';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'nama': nama,
        'id_peg_system': idPeg,
        'no_tlp': no_tlp,
        'saldo': saldo,
        'poin': poin,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> editMember(
      String id, String nama, String no_tlp, String saldo, String poin) async {
    final url = '$baseUrlTr/member/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'nama': nama,
        'no_tlp': no_tlp,
        'saldo': saldo,
        'poin': poin,
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

  Future<Map<String, dynamic>> metode(String metode) async {
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

  Future<Map<String, dynamic>> editMetode(String id, String metode) async {
    final url = '$baseUrlTr/transaksi_in/pembayaran/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'metode': metode,
      },
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
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> kasbonMember(
    String idMember,
    String totalKasbon,
    String statusKasbon,
  ) async {
    final url = '$baseUrlTr/kasbon';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_member': idMember,
          'total_kasbon': totalKasbon,
          'id_status': statusKasbon,
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

  static Future<Map<String, dynamic>> addDetTransaksiOut(
    String idProduk,
    String jumlah,
    String hargaSatuan,
    String hargaJual,
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
}
