import 'dart:io';

import 'package:bluetooth_thermal_printer_example/controllers/addC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/AddPageC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/dashboardAdminC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/validationC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/productP.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/widgets/admin/adminW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddProductP extends StatefulWidget {
  @override
  _AddProductPState createState() => _AddProductPState();
}

class _AddProductPState extends State<AddProductP> {
  final AddPageController addController = Get.put(AddPageController());

  final TextEditingController namaAddOnNewController = TextEditingController();
  final TextEditingController hargaAddOnNewController = TextEditingController();

  final TextEditingController namaMitraNewController = TextEditingController();
  final TextEditingController noMitraNewController = TextEditingController();
  final TextEditingController emailMitraNewController = TextEditingController();
  final TextEditingController bankMitraNewController = TextEditingController();
  final TextEditingController noRekMitraNewController = TextEditingController();
  final TextEditingController namaRekMitraNewController =
      TextEditingController();

  final TextEditingController newTipeController = TextEditingController();
  final TextEditingController newKategoriController = TextEditingController();
  final gambarKategoriController = FileImage(File(''));

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

  void initState() {
    super.initState();
    addController.addNewAddOn(
        namaAddOnNewController.text, hargaAddOnNewController.text);
    addController.addNewTipe(newTipeController.text);
    addController.addNewKategori(
        newKategoriController.text, gambarKategoriController.file);

    addController.addNewMitra(
      namaMitraNewController.text,
      noMitraNewController.text,
      emailMitraNewController.text,
      bankMitraNewController.text,
      noRekMitraNewController.text,
      namaRekMitraNewController.text,
    );

    addController.addProduct(
      namaProdukController.text,
      gambarProdukController.file,
      addController.selectedKategori.string,
      addController.selectedTipe.string,
      addController.selectedMitra.string,
      addController.selectedAddOn.string,
      addController.hargaDasar.string,
      jumlahIsiProdukController.text,
      hargaSatuanProdukController.text,
      hargaJualProdukController.text,
      stokProdukController.text,
    );
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      body: Container(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                padding:
                    EdgeInsets.only(bottom: 50, left: 50, right: 50, top: 130),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.add_box_rounded,
                          color: PrimaryColor().blue,
                          size: 30,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Tambahkan Produk Baru',
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
                                  selectedValue: addController.selectedKategori,
                                  label: 'Pilih Kategori',
                                  items: addController.kategori,
                                  onChanged: (newValue) {
                                    setState(() {
                                      addController.selectedKategori.value =
                                          newValue;
                                    });
                                  },
                                  key: 'kategori',
                                );
                              }),
                              buildDialogButton(
                                label: "Tambah Kategori Baru",
                                showDialog: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.add_circled,
                                                    color: PrimaryColor().blue,
                                                    size: 24,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "Tambah Kategori Baru",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildInputLabel(
                                                      'Nama Kategori', " *"),
                                                  buildTextField(
                                                    inputFormat:
                                                        LengthLimitingTextInputFormatter(
                                                            200),
                                                    controller:
                                                        newKategoriController,
                                                    hintText: 'Makanan',
                                                    prefixIcon: CupertinoIcons
                                                        .square_grid_2x2,
                                                    type: TextInputType.name,
                                                  ),
                                                  SizedBox(height: 20),
                                                  buildInputLabel(
                                                      'Gambar Kategori', " *"),
                                                  GestureDetector(
                                                    onTap: () {
                                                      addController
                                                          .pickImageKategori();
                                                    },
                                                    child: Obx(() {
                                                      if (addController
                                                              .imagePathK
                                                              .value ==
                                                          null) {
                                                        return Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 40),
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                width: 2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: Colors
                                                                .grey.shade50,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            16),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blue
                                                                      .withOpacity(
                                                                          0.1),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Icon(
                                                                  Icons
                                                                      .category,
                                                                  size: 40,
                                                                  color:
                                                                      PrimaryColor()
                                                                          .blue,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 12),
                                                              Text(
                                                                'Tambahkan Foto Kategori',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(
                                                          width: 800,
                                                          height: 250,
                                                          color: Colors.grey,
                                                          child: Image.file(
                                                              addController
                                                                  .imagePathK
                                                                  .value!,
                                                              fit:
                                                                  BoxFit.cover),
                                                        );
                                                      }
                                                    }),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'Batal',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      File? imageFileKategori =
                                                          addController
                                                              .imagePathK.value;
                                                      if (imageFileKategori ==
                                                          null) {
                                                        Get.snackbar(
                                                          'Error',
                                                          'Harap pilih gambar terlebih dahulu!',
                                                          backgroundColor:
                                                              Colors.red
                                                                  .withOpacity(
                                                                      0.5),
                                                          icon: Icon(
                                                              Icons
                                                                  .crisis_alert,
                                                              color:
                                                                  Colors.white),
                                                        );
                                                        return;
                                                      }
                                                      await addController
                                                          .addNewKategori(
                                                              newKategoriController
                                                                  .text,
                                                              imageFileKategori)
                                                          .then((_) {
                                                        addController.imagePathK
                                                            .value = null;
                                                      });
                                                      await addController
                                                          .refresh();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          PrimaryColor().blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons.add,
                                                          size: 18,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Tambah',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
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
                              ),
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
                                  selectedValue: addController.selectedTipe,
                                  label: 'Pilih Tipe',
                                  items: addController.tipe,
                                  onChanged: (newValue) {
                                    addController.selectedTipe.value = newValue;
                                    if (newValue == '1') {
                                      addController.showMitra.value = false;
                                      addController.jumlahPcsPack.value = false;
                                      addController.hargaPack.value = false;
                                      addController.harga.value = true;

                                      addController.selectedMitra.value = null;
                                      hargaSatuanProdukController.text = '';
                                      hargaPackProdukController.text = '';
                                      jumlahIsiProdukController.text = '';
                                    } else {
                                      addController.showMitra.value = true;
                                      addController.jumlahPcsPack.value = true;
                                      addController.hargaPack.value = true;
                                      addController.harga.value = false;
                                    }
                                  },
                                  key: 'tipe',
                                );
                              }),
                              buildDialogButton(
                                label: "Tambah Tipe Baru",
                                showDialog: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.add_circled,
                                                    color: PrimaryColor().blue,
                                                    size: 24,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "Tambah Tipe Baru",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildInputLabel(
                                                      'Nama Tipe', " *"),
                                                  buildTextField(
                                                    inputFormat:
                                                        LengthLimitingTextInputFormatter(
                                                            200),
                                                    controller:
                                                        newTipeController,
                                                    hintText: 'Titipan',
                                                    prefixIcon: CupertinoIcons
                                                        .person_2_fill,
                                                    type: TextInputType.name,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'Batal',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await addController
                                                          .addNewTipe(
                                                              newTipeController
                                                                  .text);
                                                      await addController
                                                          .refresh();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          PrimaryColor().blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons.add,
                                                          size: 18,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Tambah',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      return Visibility(
                        visible: addController.showMitra.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildInputLabel('Mitra Produk (Opsional)', ""),
                            buildDropdown(
                              selectedValue: addController.selectedMitra,
                              label: 'Pilih Mitra',
                              items: addController.mitra,
                              onChanged: (newValue) {
                                addController.selectedMitra.value = newValue;
                              },
                              key: 'nama',
                            ),
                            buildDialogButton(
                              label: "Tambah Mitra Baru",
                              showDialog: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.add_circled,
                                                    color: PrimaryColor().blue,
                                                    size: 24,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    "Tambah Mitra Baru",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  buildInputLabel(
                                                      'Nama Mitra', " *"),
                                                  buildTextField(
                                                    inputFormat:
                                                        LengthLimitingTextInputFormatter(
                                                            200),
                                                    controller:
                                                        namaMitraNewController,
                                                    hintText: 'Toko Kue XXXX',
                                                    prefixIcon: CupertinoIcons
                                                        .person_2_alt,
                                                    type: TextInputType.name,
                                                  ),
                                                  SizedBox(height: 10),
                                                  buildInputLabel(
                                                      'Nama No. Telepon', " *"),
                                                  buildTextField(
                                                    inputFormat:
                                                        LengthLimitingTextInputFormatter(
                                                            12),
                                                    controller:
                                                        noMitraNewController,
                                                    hintText: '0861-XXXX-XXXX',
                                                    prefixIcon: CupertinoIcons
                                                        .phone_circle,
                                                    type: TextInputType.phone,
                                                  ),
                                                  SizedBox(height: 10),
                                                  buildInputLabel(
                                                      'Email Mitra (opsional)',
                                                      " "),
                                                  buildTextField(
                                                    inputFormat:
                                                        LengthLimitingTextInputFormatter(
                                                            200),
                                                    controller:
                                                        emailMitraNewController,
                                                    hintText:
                                                        'contoh: 3yL6A@example.com',
                                                    prefixIcon:
                                                        Icons.alternate_email,
                                                    type: TextInputType
                                                        .emailAddress,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 24),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      'Batal',
                                                      style: TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      await addController
                                                          .addNewMitra(
                                                        namaMitraNewController
                                                            .text,
                                                        noMitraNewController
                                                            .text,
                                                        emailMitraNewController
                                                            .text,
                                                        bankMitraNewController
                                                            .text,
                                                        noRekMitraNewController
                                                            .text,
                                                        namaRekMitraNewController
                                                            .text,
                                                        fromButton: true,
                                                      );
                                                      await addController
                                                          .refresh();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          PrimaryColor().blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons.add,
                                                          size: 18,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Tambah',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildInputLabel('Add On Produk', " "),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              AdminW().AddOnDialog(context, addController);
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
                              mainAxisAlignment:
                                  MainAxisAlignment.start, // rata kiri
                              children: [
                                Icon(Icons.add, color: Colors.black54),
                                SizedBox(width: 8),
                                Text(
                                  'Pilih Add On',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(() {
                          return addController.selectedAddOn.isNotEmpty
                              ? Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: addController.selectedAddOn
                                      .map<Widget>((item) {
                                    final addOn =
                                        item['add_on'] ?? 'Tidak ada nama';

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
                                                  addOn,
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
                                            onTap: () =>
                                                addController.selectAddOn(item),
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
                        buildDialogButton(
                          label: "Tambah Add On Baru",
                          showDialog: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                CupertinoIcons.add_circled,
                                                color: PrimaryColor().blue,
                                                size: 24,
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                "Tambah Add On Baru",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              buildInputLabel(
                                                  'Nama Add On', " *"),
                                              buildTextField(
                                                inputFormat:
                                                    LengthLimitingTextInputFormatter(
                                                        200),
                                                controller:
                                                    namaAddOnNewController,
                                                hintText: 'Rebus',
                                                prefixIcon:
                                                    Icons.add_box_outlined,
                                                type: TextInputType.name,
                                              ),
                                              SizedBox(height: 10),
                                              buildInputLabel(
                                                  'Harga Add On', " *"),
                                              buildTextField(
                                                inputFormat:
                                                    LengthLimitingTextInputFormatter(
                                                        200),
                                                controller:
                                                    hargaAddOnNewController,
                                                hintText: 'Rp. ',
                                                prefixIcon: FontAwesomeIcons
                                                    .moneyBillWave,
                                                type: TextInputType.number,
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                          SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  'Batal',
                                                  style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await addController
                                                      .addNewAddOn(
                                                    namaAddOnNewController.text,
                                                    hargaAddOnNewController
                                                        .text,
                                                    fromButton: true,
                                                  );
                                                  await addController.refresh();
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      PrimaryColor().blue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.add,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Tambah',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            flex: addController.harga.value ? 1 : 1,
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
                          if (!addController.harga.value) ...[
                            SizedBox(width: 16),
                            Expanded(
                              flex: 1,
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
                          ],
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
                              visible: addController.hargaPack.value == false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildInputLabel('Harga Pack', " *"),
                                  buildTextField(
                                    inputFormat: RupiahFormaters(),
                                    controller: hargaPackProdukController,
                                    hintText: 'Rp 0',
                                    prefixIcon: FontAwesomeIcons.moneyBill1Wave,
                                    type: TextInputType.number,
                                    onChanged: (value) {
                                      addController.hitungHargaDasar(
                                        value,
                                        jumlahIsiProdukController.text,
                                      );
                                    },
                                  ),
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
                                  addController.jumlahPcsPack.value == false,
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
                                        addController.hitungHargaDasar(
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
                                            addController.pickImageCam();
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
                                            addController.pickImage();
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
                        if (addController.imagePath.value == null) {
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
                        } else {
                          return Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.grey,
                            child: Image.file(addController.imagePath.value!,
                                fit: BoxFit.cover),
                          );
                        }
                      }),
                    ),
                    SizedBox(height: 20),
                    Obx(() => Text(
                          'Harga Dasar: ' +
                              addController
                                  .formatRupiah(addController.hargaDasar.value),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        )),
                    SizedBox(height: 40),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: Obx(() => ElevatedButton(
                            onPressed: addController.isLoading.value
                                ? null
                                : () async {
                                    File? imageFile =
                                        addController.imagePath.value;
                                    if (imageFile == null) {
                                      Get.snackbar(
                                        'Error',
                                        'Harap pilih gambar terlebih dahulu!',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.5),
                                        icon: Icon(Icons.crisis_alert,
                                            color: Colors.black),
                                      );
                                      return;
                                    }
                                    addController.isLoading.value = true;

                                    if (addController.selectedTipe.value ==
                                        '1') {
                                      final int hargaPack = int.tryParse(
                                              hargaPackProdukController.text
                                                  .replaceAll('.', '')) ??
                                          0;
                                      final int jumlahIsi = int.tryParse(
                                              jumlahIsiProdukController.text
                                                  .replaceAll('.', '')) ??
                                          1;
                                      addController.hargaDasar.value =
                                          (hargaPack ~/ jumlahIsi).toString();
                                    } else {
                                      addController.hargaDasar.value =
                                          hargaSatuanProdukController.text
                                              .replaceAll('.', '');
                                    }

                                    try {
                                      await addController.addProduct(
                                        namaProdukController.text,
                                        imageFile,
                                        addController.selectedKategori.string,
                                        addController.selectedTipe.string,
                                        addController.selectedMitra.string,
                                        '2',
                                        hargaPackProdukController.text
                                            .replaceAll('.', ''),
                                        jumlahIsiProdukController.text
                                            .replaceAll('.', ''),
                                        addController.hargaDasar.value,
                                        hargaJualProdukController.text
                                            .replaceAll('.', ''),
                                        stokProdukController.text
                                            .replaceAll('.', ''),
                                      );

                                      for (var item
                                          in addController.selectedAddOn) {
                                        await addController.addProdukAddOn(
                                            item['id'].toString());
                                      }

                                      addController.imagePath.value = null;
                                      namaProdukController.clear();
                                      hargaPackProdukController.clear();
                                      jumlahIsiProdukController.clear();
                                      hargaSatuanProdukController.clear();
                                      hargaJualProdukController.clear();
                                      stokProdukController.clear();
                                      addController.selectedAddOn.clear();
                                      addController.selectedKategori.value =
                                          null;
                                      addController.selectedTipe.value = null;
                                      addController.selectedMitra.value = null;
                                    } catch (e) {
                                      Get.snackbar(
                                        'Error',
                                        'Terjadi kesalahan! $e',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.5),
                                        icon: Icon(Icons.crisis_alert,
                                            color: Colors.black),
                                      );
                                    } finally {
                                      addController.isLoading.value =
                                          false; // Hide loader
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PrimaryColor().blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: addController.isLoading.value
                                ? SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_circle_outline,
                                          color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Tambahkan Produk',
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
              NavbarDrawer(context, scaffoldKey),
            ],
          ),
        ),
      ),
      drawer: buildDrawer(context), // Keep your existing drawer
    );
  }

  Widget buildDialogButton({required String label, required showDialog()}) {
    return CupertinoPageScaffold(
      child: CupertinoButton(
        color: Colors.white,
        padding: EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: PrimaryColor().blue,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        onPressed: () {
          showDialog();
        },
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
              value: selectedValue.value,
              icon: SizedBox.shrink(),
              style: TextStyle(fontSize: 14, color: Colors.black87),
              onChanged: (newValue) {
                selectedValue.value = newValue;
                onChanged(newValue);
              },
              items: items.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['id'].toString(),
                  child: SizedBox(
                    width: double.infinity, // Menghindari overflow
                    child: Text(
                      item[key] ?? 'No Name',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                );
              }).toList(),
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
