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
  final TextEditingController barcodeProdukController = TextEditingController();
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
    barcodeProdukController.text = item['barcode_barang']?.toString() ?? '';
    hargaSatuanProdukController.text = item['harga_satuan']?.toString() ?? '';
    hargaJualProdukController.text = item['harga_jual']?.toString() ?? '';
    stokProdukController.text = item['stok']?.toString() ?? '';
    hargaPackProdukController.text = item['harga_pack']?.toString() ?? '';
    jumlahIsiProdukController.text = item['jml_pcs_pack']?.toString() ?? '';
    editController.imageUrl.value =
        "https://api-koperasi.aaslabs.com/uploads/${item['gambar_barang']}";
    editController.hasNewImage.value = false;
    fetchData();
    editController.fetchAddOn();
    editController.editProduct(
      item['id']?.toString() ?? '',
      namaProdukController.text,
      barcodeProdukController.text,
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
                    EdgeInsets.only(bottom: 50, left: 50, right: 50, top: 50),
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
                    AdminW().buildInputLabel('Nama Produk', ' *'),
                    AdminW().buildTextField(
                      inputFormat: LengthLimitingTextInputFormatter(200),
                      controller: namaProdukController,
                      hintText: 'Masukkan nama produk',
                      prefixIcon: Icons.fastfood_outlined,
                      type: TextInputType.name,
                    ),
                    SizedBox(height: 20),
                    AdminW().buildInputLabel('Barcode Produk', ' '),
                    AdminW().buildTextField(
                      inputFormat: LengthLimitingTextInputFormatter(200),
                      controller: barcodeProdukController,
                      hintText: 'Masukkan barcode produk',
                      prefixIcon: Icons.barcode_reader,
                      type: TextInputType.name,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AdminW().buildInputLabel("Kategori", " *"),
                              Obx(() {
                                return AdminW().buildDropdown(
                                  selectedValue:
                                      editController.selectedKategori,
                                  label: 'Pilih Kategori',
                                  items: editController.kategori,
                                  onChanged: (newValue) {
                                    setState(() {
                                      editController.selectedKategori.value =
                                          newValue ?? '';
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
                              AdminW().buildInputLabel("Tipe", " *"),
                              Obx(() {
                                return AdminW().buildDropdown(
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
                            AdminW()
                                .buildInputLabel('Mitra Produk (Opsional)', ""),
                            AdminW().buildDropdown(
                              selectedValue: editController.selectedMitra,
                              label: 'Pilih Mitra',
                              items: editController.mitra,
                              onChanged: (newValue) {
                                editController.selectedMitra.value =
                                    newValue ?? '';
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
                        AdminW().buildInputLabel('Add On', " *"),
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
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => Visibility(
                              visible: editController.hargaPack.value == false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AdminW().buildInputLabel('Harga Pack', " *"),
                                  AdminW().buildTextField(
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
                                  AdminW().buildInputLabel(
                                      'Jumlah Isi Per-pack', " *"),
                                  AdminW().buildTextField(
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
                    SizedBox(height: 20),
                    AdminW().buildInputLabel('Tambah Stok', " *"),
                    AdminW().buildTextField(
                      inputFormat: RupiahFormaters(),
                      controller: stokProdukController,
                      hintText: 'Jumlah yang ditambahkan',
                      prefixIcon: Icons.inventory_2_outlined,
                      type: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AdminW().buildInputLabel(
                                    'Harga Jual Per-pcs', " *"),
                                AdminW().buildTextField(
                                  inputFormat: RupiahFormaters(),
                                  controller: hargaJualProdukController,
                                  hintText: 'Rp 5.500',
                                  prefixIcon: FontAwesomeIcons.moneyBill1Wave,
                                  type: TextInputType.number,
                                  onChanged: (value) {
                                    editController.hitungLaba(
                                      editController.hargaDasar.value,
                                      value,
                                    );
                                  },
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
                                  AdminW().buildInputLabel(
                                      'Harga Dasar Per-pcs', " *"),
                                  AdminW().buildTextField(
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
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AdminW().buildInputLabel('Gambar', " *"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final isLandscape =
                                MediaQuery.of(context).orientation ==
                                    Orientation.landscape;

                            return Dialog(
                              elevation: 2,
                              backgroundColor: Colors.transparent,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double dialogWidth =
                                      constraints.maxWidth * 0.5;
                                  double dialogHeight = isLandscape
                                      ? constraints.maxHeight * 0.6
                                      : constraints.maxHeight * 0.25;

                                  return Container(
                                    width: dialogWidth,
                                    height: dialogHeight,
                                    padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Kamera Button
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              editController.pickImageCam();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8),
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
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.camera_alt,
                                                      color: Colors.white,
                                                      size: 40),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Kamera',
                                                    style: TextStyle(
                                                      fontSize: 16,
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

                                        // Galeri Button
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              editController.pickImage();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8),
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
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.photo_library,
                                                      color: Colors.white,
                                                      size: 40),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    'Galeri',
                                                    style: TextStyle(
                                                      fontSize: 16,
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
                                  );
                                },
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
                    Obx(() => Visibility(
                          visible: editController.hargaPack.value == false,
                          child: Text(
                            'Harga Dasar Per-pcs: ' +
                                editController.formatRupiah(
                                    editController.hargaDasar.value),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )),
                    SizedBox(width: 20),
                    Obx(() => Visibility(
                          visible: editController.hargaPack.value == false,
                          child: Text(
                            'Laba Per-pcs: ' +
                                editController.formatRupiah(
                                    editController.totalLaba.value),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        )),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() => ElevatedButton(
                            onPressed: editController.isLoading.value
                                ? null
                                : () async {
                                    File? imageFile =
                                        editController.imagePath.value;
                                    var laba = int.tryParse(
                                            editController.totalLaba.value) ??
                                        0;
                                    if (laba < 0) {
                                      Get.snackbar(
                                        'Gagal',
                                        'Laba tidak boleh minus, Silahkan cek kembali data produk anda!',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.5),
                                        icon: Icon(Icons.crisis_alert,
                                            color: Colors.black),
                                      );
                                      return;
                                    }
                                    if (editController.selectedTipe.value ==
                                        '1') {
                                      final int hargaPack = int.tryParse(
                                              hargaPackProdukController.text) ??
                                          0;
                                      final int jumlahIsi = int.tryParse(
                                              jumlahIsiProdukController.text) ??
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
                                      barcodeProdukController.text,
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

                                    await productController.refresh();
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
