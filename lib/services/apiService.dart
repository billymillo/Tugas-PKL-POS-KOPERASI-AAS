import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;

// Fetch Api
class ApiService {
  static const String baseUrl = 'https://api-koperasi.aaslabs.com/api';

  Future<List<dynamic>> fetchUsers({String? id}) async {
    final url = id == null ? '$baseUrl/users' : '$baseUrl/users?id=$id';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['data'];
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  // Method Login
  Future<Map<String, dynamic>> login(String name, String password) async {
    final url = '$baseUrl/users/login';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': name,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> logout(String userId) async {
    final url = '$baseUrl/users/logout';

    final response = await http.post(
      Uri.parse(url),
      body: {'id': userId},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> tipe(String tipe, userInput) async {
    final url = '$baseUrl/product/tipe';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'tipe': tipe,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> editTipe(
      String id, String tipe, String update) async {
    final url = '$baseUrl/product/tipe/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {'id': id, 'tipe': tipe, 'user_update': update},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteTipe(
    String id,
  ) async {
    final url = '$baseUrl/product/tipe/$id';
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

  Future<Map<String, dynamic>> kategori(
      String kategori, File? gambar_kategori, String userInput) async {
    final url = Uri.parse('$baseUrl/product/kategori');
    final request = http.MultipartRequest('POST', url);

    request.fields['kategori'] = kategori;
    var imageFile = await http.MultipartFile.fromPath(
        'gambar_kategori', gambar_kategori!.path);
    request.files.add(imageFile);
    request.fields['user_input'] = userInput;

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      Map<String, dynamic> result = jsonDecode(responseData.body);
      return {
        'status': response.statusCode == 200 || response.statusCode == 201,
        'message': result['message'] ?? 'Gagal menambahkan Kategori',
        'data': result['data'] ?? {},
      };
    } catch (e) {
      return {'status': false, 'message': 'Terjadi kesalahan: $e', 'data': {}};
    }
  }

  Future<Map<String, dynamic>> editKategori(
    String id,
    String kategori,
    File? gambar_kategori,
    String update,
  ) async {
    final url = Uri.parse('$baseUrl/product/kategori_edit?_method=PUT');
    final request = http.MultipartRequest('POST', url);

    request.fields['id'] = id;
    request.fields['kategori'] = kategori;
    request.fields['user_update'] = update;

    if (gambar_kategori != null) {
      var imageFile = await http.MultipartFile.fromPath(
          'gambar_kategori', gambar_kategori.path);
      request.files.add(imageFile);
    }

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      Map<String, dynamic> result = jsonDecode(responseData.body);

      return {
        'status': response.statusCode == 200 || response.statusCode == 201,
        'message': result['message'] ?? 'Gagal mengedit Kategori',
        'data': result['data'] ?? {},
      };
    } catch (e) {
      return {'status': false, 'message': 'Terjadi kesalahan: $e', 'data': {}};
    }
  }

  Future<Map<String, dynamic>> deleteKategori(
    String id,
  ) async {
    final url = '$baseUrl/product/kategori/$id';
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

  Future<Map<String, dynamic>> mitra(String nama, String no_tlp, String email,
      String bank, String noRek, String namaRek, String userInput) async {
    final url = '$baseUrl/product/mitra';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'nama': nama,
        'no_tlp': no_tlp,
        'email': email,
        'bank_rek': bank,
        'no_rek': noRek,
        'nama_rek': namaRek,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteMitra(
    String id,
  ) async {
    final url = '$baseUrl/product/mitra/$id';
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

  Future<Map<String, dynamic>> editMitra(
      String id,
      String nama,
      String no_tlp,
      String email,
      String bank,
      String noRek,
      String namaRek,
      String update) async {
    final url = '$baseUrl/product/mitra/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'nama': nama,
        'no_tlp': no_tlp,
        'email': email,
        'bank_rek': bank,
        'no_rek': noRek,
        'nama_rek': namaRek,
        'user_update': update
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> addProduk(
    String nama_barang,
    String barcode,
    File? gambar_barang,
    String id_kategori_barang,
    String id_tipe_barang,
    String id_mitra_barang,
    String harga_pack,
    String jml_pcs_pack,
    String harga_satuan,
    String harga_jual,
    String stok,
    String userInput,
  ) async {
    final url = Uri.parse('$baseUrl/product');
    final request = http.MultipartRequest('POST', url);

    request.fields['nama_barang'] = nama_barang;
    request.fields['barcode_barang'] = barcode;
    request.fields['id_kategori_barang'] = id_kategori_barang;
    request.fields['id_tipe_barang'] = id_tipe_barang;
    request.fields['id_mitra_barang'] = id_mitra_barang;
    request.fields['harga_pack'] = harga_pack;
    request.fields['jml_pcs_pack'] = jml_pcs_pack;
    request.fields['harga_satuan'] = harga_satuan;
    request.fields['harga_jual'] = harga_jual;
    request.fields['stok'] = stok;
    request.fields['user_input'] = userInput;

    var imageFile =
        await http.MultipartFile.fromPath('gambar_barang', gambar_barang!.path);
    request.files.add(imageFile);

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      Map<String, dynamic> result = jsonDecode(responseData.body);
      return {
        'status': response.statusCode == 200 || response.statusCode == 201,
        'message': result['message'] ?? 'Gagal menambahkan produk',
        'data': result['data'] ?? {},
      };
    } catch (e) {
      return {'status': false, 'message': 'Terjadi kesalahan: $e', 'data': {}};
    }
  }

  Future<Map<String, dynamic>> editProduk(
    String id,
    String nama_barang,
    String barcode,
    File? gambar_barang,
    String id_kategori_barang,
    String id_tipe_barang,
    String id_mitra_barang,
    String id_add_on,
    String harga_pack,
    String jml_pcs_pack,
    String harga_satuan,
    String harga_jual,
    String stok,
    String update,
  ) async {
    final url = Uri.parse('$baseUrl/product/$id');
    final request = http.MultipartRequest('POST', url); // Gunakan POST
    request.fields['_method'] = 'PUT'; // Simulasi PUT request

    // Tambahkan data produk
    request.fields['id'] = id;
    request.fields['nama_barang'] = nama_barang;
    request.fields['barcode_barang'] = barcode;
    request.fields['id_kategori_barang'] = id_kategori_barang;
    request.fields['id_tipe_barang'] = id_tipe_barang;
    request.fields['id_mitra_barang'] = id_mitra_barang;
    request.fields['id_add_on'] = id_add_on;
    request.fields['harga_pack'] = harga_pack;
    request.fields['jml_pcs_pack'] = jml_pcs_pack;
    request.fields['harga_satuan'] = harga_satuan;
    request.fields['harga_jual'] = harga_jual;
    request.fields['stok'] = stok;
    request.fields['user_update'] = update;

    // Jika ada gambar yang dipilih, tambahkan ke request
    if (gambar_barang != null) {
      var imageFile = await http.MultipartFile.fromPath(
          'gambar_barang', gambar_barang.path);
      request.files.add(imageFile);
    }

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      Map<String, dynamic> result = jsonDecode(responseData.body);

      return {
        'status': response.statusCode == 200 || response.statusCode == 201,
        'message': result['message'] ?? 'Gagal mengedit produk',
        'data': result['data'] ?? {},
      };
    } catch (e) {
      return {'status': false, 'message': 'Terjadi kesalahan: $e', 'data': {}};
    }
  }

  Future<Map<String, dynamic>> deleteProduk(
    String id,
  ) async {
    final url = '$baseUrl/product/$id';
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

  static Future<Map<String, dynamic>> addOpname(
      String status, String tipeOpname, String userInput) async {
    final url = '$baseUrl/opname';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'status_opname': status,
        'tipe_opname': tipeOpname,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> editOpname(
      String id, String status, String user_update) async {
    final url = '$baseUrl/opname';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'status_opname': status,
        'user_update': user_update,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> addDetOpname(
      String idProduk,
      String idOpname,
      String stok,
      String stokAsli,
      String hargaSatuan,
      String hargaJual,
      String catatan,
      String userInput) async {
    final url = '$baseUrl/opname/detail';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id_produk': idProduk,
        'id_opname': idOpname,
        'stok': stok,
        'stok_asli': stokAsli,
        'harga_satuan': hargaSatuan,
        'harga_jual': hargaJual,
        'catatan': catatan,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  static Future<Map<String, dynamic>> editDetOpname(
      String id,
      String stok,
      String stokAsli,
      String hargaSatuan,
      String hargaJual,
      String catatan,
      String user_update) async {
    final url = '$baseUrl/opname/detail';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'stok': stok,
        'stok_asli': stokAsli,
        'harga_satuan': hargaSatuan,
        'harga_jual': hargaJual,
        'catatan': catatan,
        'user_update': user_update,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteOpname(
      String id, String userUpdate) async {
    final url = '$baseUrl/opname/';
    final response = await http.delete(
      Uri.parse(url),
      body: {'id': id, 'user_update': userUpdate},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> addAddOn(
      String addOn, String harga, String userInput) async {
    final url = '$baseUrl/addon';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'add_on': addOn,
        'harga': harga,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> editAddOn(
      String id, String add_on, String harga, String update) async {
    final url = '$baseUrl/addon/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {'id': id, 'add_on': add_on, 'harga': harga, 'user_update': update},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteAddOn(
    String id,
    String userUpdate,
  ) async {
    final url = '$baseUrl/addon/$id';
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

  // Jika produk baru ditambahkan pake ini
  // karena id_produk diambil dari latest produk dari CI
  Future<Map<String, dynamic>> addProdukAddOnNewest(
      String idAddon, String userInput) async {
    final url = '$baseUrl/addon/produk';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id_add_on': idAddon,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  // Jika produk lama pake ini
  // karena id_produk diambil dari id_produk yang ada di ProdukPage
  Future<Map<String, dynamic>> addProdukAddOnOld(
      String idAddon, String idProduk, String userInput) async {
    final url = '$baseUrl/addon/produk';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id_add_on': idAddon,
        'id_produk': idProduk,
        'user_input': userInput,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> deleteProdukAddOn(
    String id,
    String userUpdate,
  ) async {
    final url = '$baseUrl/addon/produk/';
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
}
