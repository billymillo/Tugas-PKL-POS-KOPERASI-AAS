import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceTr {
  static const String baseUrlTr = 'http://10.10.20.240/POS_CI/api';

  Future<Map<String, dynamic>> TransaksiOut(
    String idMember,
    List<Map<String, dynamic>> produk,
    String totalTr,
    String diskon,
    String statusTr,
    String potPoin,
    String getPoin,
  ) async {
    final url = '$baseUrlTr/transaksi_out';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_member': idMember,
        'jumlah_produk': produk,
        'total_transaksi': totalTr,
        'diskon': diskon,
        'status_transaksi': statusTr,
        'potongan_poin': potPoin,
        'mendapatkan_poin': getPoin,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }
}
