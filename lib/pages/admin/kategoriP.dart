import 'dart:io';

import 'package:bluetooth_thermal_printer_example/controllers/admin/libraryC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/admin/adminW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class KategoriP extends StatefulWidget {
  @override
  _KategoriPState createState() => _KategoriPState();
}

class _KategoriPState extends State<KategoriP> {
  final TextEditingController newKategoriController = TextEditingController();
  final newGambarKategoriController = FileImage(File(''));
  final LibraryController kategoriController = Get.put(LibraryController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController namaKategoriController = TextEditingController();
  final gambarKategoriController = FileImage(File(''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: RefreshIndicator(
                onRefresh: () async {
                  await kategoriController.refresh();
                },
                child: NotificationListener<ScrollNotification>(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: Obx(() {
                          if (kategoriController.isLoading.value &&
                              kategoriController.kategori.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (kategoriController.kategori.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_2_outlined,
                                        size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      "Tidak Ada Kategori Tersedia",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio:
                                  (MediaQuery.of(context).orientation ==
                                          Orientation.landscape
                                      ? 5
                                      : 4),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var item = kategoriController.kategori[index];
                                return buildProductCard(item, context);
                              },
                              childCount: kategoriController.kategori.length,
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          if (kategoriController.isLoading.value) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  'Koperasi Anugrah Artha Abadi',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            NavbarDrawer(context, scaffoldKey),
            Padding(
              padding: EdgeInsets.only(top: 80, left: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width *
                          (MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 0.75
                              : 0.65),
                      child: Row(
                        children: [
                          Icon(Icons.category,
                              size: 25, color: PrimaryColor().blue),
                          SizedBox(width: 10),
                          Text(
                            'Kategori Barang',
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: buildDialog(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: buildDrawer(context),
    );
  }

  Widget buildProductCard(Map<String, dynamic> item, BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://api-koperasi.aaslabs.com/kategori/${item['gambar_kategori']}",
                  ),
                  fit: BoxFit.cover,
                ),
                color: PrimaryColor().blue,
                borderRadius: BorderRadius.circular(10)),
            height: 150,
          ),
          Container(
            padding: EdgeInsets.only(left: 17),
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                color: Colors.black38, borderRadius: BorderRadius.circular(10)),
            height: 150,
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 40,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            size: 13,
                            Icons.fastfood,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          item['kategori'],
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: GestureDetector(
                              child: Text(
                                'Edit',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.blue),
                              ),
                              onTap: () {
                                showEditDialog(
                                  context,
                                  item['id'],
                                  item['kategori'],
                                  "https://api-koperasi.aaslabs.com/uploads/${item['gambar_kategori']}",
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: GestureDetector(
                              child: Text(
                                'Hapus',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.red),
                              ),
                              onTap: () {
                                AdminW().deleteDialog(
                                  context,
                                  "Hapus Kategori",
                                  "Apakah anda yakin ingin menghapus kategori ini?",
                                  () async {
                                    await kategoriController.deleteKategori(
                                        item['id'],
                                        fromButton: true);
                                    await kategoriController.refresh();
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          )
                        ],
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
  }

  Widget buildDialog() {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: SingleChildScrollView(
                child: Dialog(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AdminW().buildInputLabel('Nama Kategori', " *"),
                            AdminW().buildTextField(
                              inputFormat: LengthLimitingTextInputFormatter(30),
                              controller: newKategoriController,
                              hintText: 'Makanan',
                              prefixIcon: CupertinoIcons.square_grid_2x2,
                              type: TextInputType.name,
                            ),
                            SizedBox(height: 20),
                            AdminW().buildInputLabel('Gambar Kategori', " *"),
                            GestureDetector(
                              onTap: () {
                                kategoriController.pickImageKategoriNew();
                              },
                              child: Obx(() {
                                if (kategoriController.imagePathNewK.value ==
                                    null) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 2),
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
                                            Icons.category,
                                            size: 40,
                                            color: PrimaryColor().blue,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          'Tambahkan Foto Kategori',
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
                                    child: Image.file(
                                        kategoriController.imagePathNewK.value!,
                                        fit: BoxFit.cover),
                                  );
                                }
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Batal',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Obx(
                              () => ElevatedButton(
                                onPressed: kategoriController.isLoading.value
                                    ? null // Disable button ketika sedang loading
                                    : () async {
                                        File? imageFileKategori =
                                            kategoriController
                                                .imagePathNewK.value;
                                        if (imageFileKategori == null) {
                                          Get.snackbar(
                                            'Error',
                                            'Harap pilih gambar terlebih dahulu!',
                                            backgroundColor:
                                                Colors.red.withOpacity(0.5),
                                            icon: Icon(Icons.crisis_alert,
                                                color: Colors.white),
                                          );
                                          return;
                                        }
                                        kategoriController.isLoading.value =
                                            true;
                                        try {
                                          await kategoriController
                                              .addNewKategori(
                                                  newKategoriController.text,
                                                  imageFileKategori)
                                              .then((_) {
                                            kategoriController
                                                .imagePathNewK.value = null;
                                            if (newKategoriController.text ==
                                                false) {
                                              Get.snackbar(
                                                'Error',
                                                'Tolong lengkapi data kategori',
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.5),
                                                icon: Icon(Icons.crisis_alert,
                                                    color: Colors.white),
                                              );
                                            }
                                          });
                                        } catch (e) {
                                          Get.snackbar("Error", e.toString());
                                        } finally {
                                          kategoriController.isLoading.value =
                                              false;
                                        }
                                        await kategoriController.refresh();
                                        Navigator.pop(context);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PrimaryColor().blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: kategoriController.isLoading.value
                                    ? SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
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
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 4,
      ),
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Tambah Kategori',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  int getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) return 1; // Tablet landscape
    if (width > 600) return 1; // Tablet portrait
    return 1; // Phone
  }

  void showEditDialog(
      BuildContext context, String id, String kategoriLama, String gambarLama) {
    TextEditingController editKategoriController =
        TextEditingController(text: kategoriLama);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Edit Kategori",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  AdminW().buildInputLabel('Nama Kategori', ' *'),
                  AdminW().buildTextField(
                    controller: editKategoriController,
                    hintText: kategoriLama,
                    prefixIcon: CupertinoIcons.square_grid_2x2,
                    type: TextInputType.name,
                    inputFormat: LengthLimitingTextInputFormatter(30),
                  ),
                  SizedBox(height: 20),
                  AdminW().buildInputLabel('Gambar Kategori', ' *'),
                  Obx(() => GestureDetector(
                        onTap: () async {
                          await kategoriController.pickImageKategori();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: kategoriController.hasNewImage.value &&
                                  kategoriController.imagePathK.value != null
                              ? Image.file(
                                  kategoriController.imagePathK.value!,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  gambarLama,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      )),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          await kategoriController.editKategori(
                            id,
                            editKategoriController.text,
                            kategoriController.imagePathK.value,
                            fromButton: true,
                          );
                          Navigator.pop(context);
                          await kategoriController.fetchMitra();
                          await kategoriController.refresh();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PrimaryColor().blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.pencil,
                                size: 18, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Simpan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
  }
}
