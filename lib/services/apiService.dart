import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;

// Fetch Api
class ApiService {
  static const String baseUrl = 'http://10.10.20.240/POS_CI/api/';
  // static const String baseUrl = 'http://192.168.1.7/POS_CI/api/';
  // static const String baseUrl = 'http://192.168.198.73/POS_CI/api/';

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

  Future<Map<String, dynamic>> tipe(String tipe) async {
    final url = '$baseUrl/product/tipe';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'tipe': tipe,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(response.body);
    }
  }

  Future<Map<String, dynamic>> editTipe(
    String id, String tipe) async {
    final url = '$baseUrl/product/tipe/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'tipe': tipe,
      },
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
      String kategori, File? gambar_kategori) async {
    final url = Uri.parse('$baseUrl/product/kategori');
    final request = http.MultipartRequest('POST', url);

    request.fields['kategori'] = kategori;
    var imageFile = await http.MultipartFile.fromPath(
        'gambar_kategori', gambar_kategori!.path);
    request.files.add(imageFile);

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
  ) async {
    final url = Uri.parse('$baseUrl/product/kategori_edit?_method=PUT');
    final request = http.MultipartRequest('POST', url);

    request.fields['id'] = id;
    request.fields['kategori'] = kategori;

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

  Future<Map<String, dynamic>> mitra(
      String nama, String no_tlp, String email) async {
    final url = '$baseUrl/product/mitra';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'nama': nama,
        'no_tlp': no_tlp,
        'email': email,
      },
    );
    if (response.statusCode == 200) {
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
    String id, String nama, String no_tlp, String email) async {
    final url = '$baseUrl/product/mitra/$id';
    final response = await http.put(
      Uri.parse(url),
      body: {
        'id': id,
        'nama': nama,
        'no_tlp': no_tlp,
        'email': email,
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
    File? gambar_barang,
    String id_kategori_barang,
    String id_tipe_barang,
    String id_mitra_barang,
    String harga_pack,
    String jml_pcs_pack,
    String harga_satuan,
    String harga_jual,
    String stok,
  ) async {
    final url = Uri.parse('$baseUrl/product');
    final request = http.MultipartRequest('POST', url);

    request.fields['nama_barang'] = nama_barang;
    request.fields['id_kategori_barang'] = id_kategori_barang;
    request.fields['id_tipe_barang'] = id_tipe_barang;
    request.fields['id_mitra_barang'] = id_mitra_barang;
    request.fields['harga_pack'] = harga_pack;
    request.fields['jml_pcs_pack'] = jml_pcs_pack;
    request.fields['harga_satuan'] = harga_satuan;
    request.fields['harga_jual'] = harga_jual;
    request.fields['stok'] = stok;

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
    File? gambar_barang,
    String id_kategori_barang,
    String id_tipe_barang,
    String id_mitra_barang,
    String harga_pack,
    String jml_pcs_pack,
    String harga_satuan,
    String harga_jual,
    String stok,
  ) async {
    final url = Uri.parse('$baseUrl/product/$id');
    final request = http.MultipartRequest('POST', url); // Gunakan POST
    request.fields['_method'] = 'PUT'; // Simulasi PUT request

    // Tambahkan data produk
    request.fields['id'] = id;
    request.fields['nama_barang'] = nama_barang;
    request.fields['id_kategori_barang'] = id_kategori_barang;
    request.fields['id_tipe_barang'] = id_tipe_barang;
    request.fields['id_mitra_barang'] = id_mitra_barang;
    request.fields['harga_pack'] = harga_pack;
    request.fields['jml_pcs_pack'] = jml_pcs_pack;
    request.fields['harga_satuan'] = harga_satuan;
    request.fields['harga_jual'] = harga_jual;
    request.fields['stok'] = stok;

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
}
