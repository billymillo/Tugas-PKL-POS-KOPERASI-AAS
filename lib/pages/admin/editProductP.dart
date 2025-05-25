import 'dart:io';
import 'dart:math';

import 'package:bluetooth_thermal_printer_example/controllers/admin/editPageC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/productC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/addOnP.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/widgets/admin/adminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditProductP extends StatefulWidget {
  @override
  _EditProductPState createState() => _EditProductPState();
}

class _EditProductPState extends State<EditProductP> {
  final EditPageController editController = Get.put(EditPageController());
  final ProductController productController = Get.put(ProductController());

  final TextEditingController namaProdukController = TextEditingController();
  final gambarProdukController = FileImage(File(''));
  final TextEditingController hargaSatuanProdukController =
      TextEditingController();
  final TextEditingController hargaJualProdukController =
      TextEditingController();
  final TextEditingController stokProdukController = TextEditingController();
  final TextEditingController hargaPackProdukController =
      TextEditingController();
  final TextEditingController jumlahIsiProdukController =
      TextEditingController();

  late Map<String, dynamic> item;

  void initState() {
    super.initState();
    item = Get.arguments;
    namaProdukController.text = item['nama_barang'] ?? '';
    hargaSatuanProdukController.text = item['harga_satuan']?.toString() ?? '';
    hargaJualProdukController.text = item['harga_jual']?.toString() ?? '';
    stokProdukController.text = item['stok']?.toString() ?? '';
    hargaPackProdukController.text = item['harga_pack']?.toString() ?? '';
    jumlahIsiProdukController.text = item['jml_pcs_pack']?.toString() ?? '';
    editController.imageUrl.value =
        "http://192.168.1.7/POS_CI/uploads/${item['gambar_barang']}";
    editController.hasNewImage.value = false;
    fetchData();
    editController.fetchAddOn();
    editController.editProduct(
      item['id']?.toString() ?? '',
      namaProdukController.text,
      gambarProdukController.file,
      editController.selectedKategori.string,
      editController.selectedTipe.string,
      editController.selectedMitra.string,
      editController.selectedAddOn.string,
      hargaPackProdukController.text,
      jumlahIsiProdukController.text,
      hargaSatuanProdukController.text,
      hargaJualProdukController.text,
      stokProdukController.text,
    );
  }

  Future<void> fetchData() async {
    await Future.wait([
      editController.fetchMitra(),
      editController.fetchTipe(),
      editController.fetchKategori(),
    ]);
    setState(() {
      editController.selectedKategori.value =
          item['id_kategori_barang']?.toString();
      editController.selectedTipe.value = item['id_tipe_barang']?.toString();
      editController.selectedMitra.value = item['id_mitra_barang']?.toString();
    });
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Get.back(),
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 70),
            child: Text(
              'Edit Produk',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ),
      ),
      key: scaffoldKey,
      extendBody: true,
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding:
                    EdgeInsets.only(bottom: 50, left: 50, right: 50, top: 100),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.edit_calendar_rounded,
                          color: PrimaryColor().blue,
                          size: 30,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Edit Produk',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    buildInputLabel('Nama Produk', ' *'),
                    buildTextField(
                      inputFormat: LengthLimitingTextInputFormatter(200),
                      controller: namaProdukController,
                      hintText: 'Masukkan nama produk',
                      prefixIcon: Icons.fastfood_outlined,
                      type: TextInputType.name,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInputLabel("Kategori", " *"),
                              Obx(() {
                                return buildDropdown(
                                  selectedValue:
                                      editController.selectedKategori,
                                  label: 'Pilih Kategori',
                                  items: editController.kategori,
                                  onChanged: (newValue) {
                                    setState(() {
                                      editController.selectedKategori.value =
                                          newValue;
                                    });
                                  },
                                  key: 'kategori',
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildInputLabel("Tipe", " *"),
                              Obx(() {
                                return buildDropdown(
                                  selectedValue: editController.selectedTipe,
                                  label: 'Pilih Tipe',
                                  items: editController.tipe,
                                  onChanged: (newValue) {
                                    editController.selectedTipe.value =
                                        newValue;
                                    if (newValue == '1') {
                                      editController.showMitra.value = false;
                                      editController.jumlahPcsPack.value =
                                          false;
                                      editController.hargaPack.value = false;
                                      editController.harga.value = true;
                                      editController.selectedMitra.value = null;
                                    } else {
                                      editController.showMitra.value = true;
                                      editController.jumlahPcsPack.value = true;
                                      editController.hargaPack.value = true;
                                      editController.harga.value = false;
                                    }
                                  },
                                  key: 'tipe',
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return Visibility(
                        visible: editController.showMitra
                            .value, // Menyembunyikan dropdown mitra berdasarkan selectedTipe
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInputLabel('Mitra Produk (Opsional)', ""),
                            buildDropdown(
                              selectedValue: editController.selectedMitra,
                              label: 'Pilih Mitra',
                              items: editController.mitra,
                              onChanged: (newValue) {
                                editController.selectedMitra.value = newValue;
                              },
                              key: 'nama',
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInputLabel('Add On', " *"),
                        ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Obx(() {
                                      if (editController.isLoading.value) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tambah Add On',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Wrap(
                                            spacing: 12,
                                            runSpacing: 12,
                                            children: editController
                                                .filteredAddOnByProduk(
                                                    item['id'].toString())
                                                .map((item) {
                                              final id = item['id'];
                                              final name = item['add_on'] ?? '';
                                              final isSelected = editController
                                                  .selectedAddOn
                                                  .any((e) => e['id'] == id);

                                              return GestureDetector(
                                                onTap: () {
                                                  final index = editController
                                                      .selectedAddOn
                                                      .indexWhere(
                                                          (e) => e['id'] == id);
                                                  if (index >= 0) {
                                                    editController.selectedAddOn
                                                        .removeAt(index);
                                                  } else {
                                                    editController.selectedAddOn
                                                        .add(item);
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                                  decoration: BoxDecoration(
                                                    color: isSelected
                                                        ? PrimaryColor().blue
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      color:
                                                          PrimaryColor().blue,
                                                      width: 1,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey.shade200,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    name,
                                                    style: TextStyle(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : PrimaryColor().blue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(height: 20),
                                          Container(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                final selectedIds =
                                                    editController.selectedAddOn
                                                        .map((e) => e['id'])
                                                        .toList();
                                                print(
                                                    'Selected AddOn IDs: $selectedIds');
                                                for (var data in editController
                                                    .selectedAddOn) {
                                                  await editController
                                                      .addProdukAddOn(
                                                          data['id'].toString(),
                                                          item['id']
                                                              .toString());
                                                }
                                                await editController.refresh();
                                                await editController
                                                    .selectedAddOn.clear;
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    PrimaryColor().blue,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                'Simpan',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.add, color: Colors.black54),
                              SizedBox(width: 8),
                              Text(
                                'Tambah Add On',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          final idProduk = item['id'] ?? 0;
                          final filteredAddOn = editController.addOnPr
                              .where((e) => e['id_produk'] == idProduk)
                              .toList();
                          return filteredAddOn.isNotEmpty
                              ? Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: filteredAddOn.map((item) {
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 20),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            color: Colors.white,
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 10),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: 120),
                                                child: Text(
                                                  editController.AddonName(
                                                      item['id_add_on']
                                                          .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              AdminW().deleteDialog(
                                                  context,
                                                  'Hapus Add On',
                                                  'Apakah anda yakin ingin menghapus add on ini',
                                                  () async {
                                                await editController
                                                    .deleteProdukAddOn(
                                                  item['id'].toString(),
                                                  fromButton: true,
                                                );
                                                await editController.refresh();
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1.5),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.close,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }).toList(),
                                )
                              : const SizedBox(height: 1);
                        }),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildInputLabel('Harga Jual Per-pcs', " *"),
                                buildTextField(
                                  inputFormat: RupiahFormaters(),
                                  controller: hargaJualProdukController,
                                  hintText: 'Rp 5.500',
                                  prefixIcon: FontAwesomeIcons.moneyBill1Wave,
                                  type: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          if (!editController.harga.value) ...[
                            SizedBox(width: 16),
                            Expanded(
                              flex: editController.harga.value ? 1 : 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInputLabel('Harga Dasar Per-pcs', " *"),
                                  buildTextField(
                                    inputFormat: RupiahFormaters(),
                                    controller: hargaSatuanProdukController,
                                    hintText: 'Rp 5.000',
                                    prefixIcon: FontAwesomeIcons.moneyBill1Wave,
                                    type: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    buildInputLabel('Tambah Stok', " *"),
                    buildTextField(
                      inputFormat: RupiahFormaters(),
                      controller: stokProdukController,
                      hintText: 'Jumlah yang ditambahkan',
                      prefixIcon: Icons.inventory_2_outlined,
                      type: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => Visibility(
                              visible: editController.hargaPack.value == false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInputLabel('Harga Pack', " *"),
                                  buildTextField(
                                      inputFormat: RupiahFormaters(),
                                      controller: hargaPackProdukController,
                                      hintText: 'Rp 0',
                                      prefixIcon:
                                          FontAwesomeIcons.moneyBill1Wave,
                                      type: TextInputType.number,
                                      onChanged: (value) {
                                        editController.hitungHargaDasar(
                                          value,
                                          jumlahIsiProdukController.text,
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => Visibility(
                              visible:
                                  editController.jumlahPcsPack.value == false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInputLabel('Jumlah Isi Per-pack', " *"),
                                  buildTextField(
                                      inputFormat: RupiahFormaters(),
                                      controller: jumlahIsiProdukController,
                                      hintText: '0 pcs',
                                      prefixIcon: Icons.inventory_2_outlined,
                                      type: TextInputType.number,
                                      onChanged: (value) {
                                        editController.hitungHargaDasar(
                                          hargaPackProdukController.text,
                                          value,
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        buildInputLabel('Gambar', " *"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Action for Camera
                                            editController.pickImageCam();
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: PrimaryColor().green,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 6,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.camera_alt,
                                                      color: Colors.white,
                                                      size: 60),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Kamera',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        GestureDetector(
                                          onTap: () {
                                            // Action for Gallery
                                            editController.pickImage();
                                          },
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: PrimaryColor().blue,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 6,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.photo_library,
                                                      color: Colors.white,
                                                      size: 60),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Galeri',
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Obx(() {
                        if (editController.hasNewImage.value &&
                            editController.imagePath.value != null) {
                          // Jika gambar baru dipilih
                          return Container(
                            width: 800,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image:
                                    FileImage(editController.imagePath.value!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else if (editController.imageUrl.value != null &&
                            !editController.hasNewImage.value) {
                          // Jika belum ada gambar baru, tampilkan gambar lama dari URL
                          return Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: NetworkImage(
                                    editController.imageUrl.value!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        } else {
                          // Placeholder jika belum ada gambar
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade50,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 40,
                                    color: PrimaryColor().blue,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Tambahkan Foto Produk',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                    ),
                    SizedBox(height: 40),
                    Obx(() => Text(
                          'Harga Dasar: ' +
                              editController.formatRupiah(
                                  editController.hargaDasar.value),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        )),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() => ElevatedButton(
                            onPressed: editController.isLoading.value
                                ? null
                                : () async {
                                    File? imageFile =
                                        editController.imagePath.value;
                                    if (editController.selectedTipe.value ==
                                        '1') {
                                      final int hargaPack = int.tryParse(
                                              hargaPackProdukController.text
                                                  .replaceAll('.', '')) ??
                                          0;
                                      final int jumlahIsi = int.tryParse(
                                              jumlahIsiProdukController.text
                                                  .replaceAll('.', '')) ??
                                          1;
                                      editController.hargaDasar.value =
                                          (hargaPack ~/ jumlahIsi).toString();
                                    } else {
                                      editController.hargaDasar.value =
                                          hargaSatuanProdukController.text
                                              .replaceAll('.', '');
                                    }
                                    await editController.editProduct(
                                      item['id'],
                                      namaProdukController.text,
                                      imageFile,
                                      editController.selectedKategori.string,
                                      editController.selectedTipe.string,
                                      editController.selectedMitra.string,
                                      editController.selectedAddOn.string,
                                      hargaPackProdukController.text
                                          .replaceAll('.', ''),
                                      jumlahIsiProdukController.text
                                          .replaceAll('.', ''),
                                      editController.hargaDasar.value,
                                      hargaJualProdukController.text
                                          .replaceAll('.', ''),
                                      stokProdukController.text
                                          .replaceAll('.', ''),
                                      fromButton: true,
                                    );

                                    await productController.fetchProduk();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PrimaryColor().blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: editController.isLoading.value
                                ? CircularProgressIndicator(
                                    color: Colors.white) // Loader
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Simpan Perubahan',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          )),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Koperasi Anugrah Artha Abadi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputLabel(String label, String label2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Text(label2,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: DarkColor().red,
              )),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required TextInputType type,
    required inputFormat,
    Function(String)? onChanged,
    // controller
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        inputFormatters: [inputFormat],
        keyboardType: type,
        controller: controller,
        cursorColor: PrimaryColor().blue,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey.shade600,
            size: 20,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildDropdown({
    required Rxn<String> selectedValue,
    required String label,
    required List<Map<String, dynamic>> items,
    required ValueChanged<String?> onChanged,
    required String key,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
              value: items.any(
                      (item) => item['id'].toString() == selectedValue.value)
                  ? selectedValue.value
                  : null,
              icon: SizedBox.shrink(),
              style: TextStyle(fontSize: 14, color: Colors.black87),
              onChanged: (newValue) {
                selectedValue.value = newValue;
                onChanged(newValue);
              },
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('${label}'),
                ),
                ...items.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        item[key] ?? 'No Name',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.keyboard_arrow_down,
                color: Colors.grey.shade600, size: 20),
          ),
        ],
      ),
    );
  }
}

class RupiahFormaters extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    String formattedText = NumberFormat.decimalPattern('id_ID').format(
      int.parse(newText),
    );

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: formattedText.length,
      ),
    );
  }
}
