import 'dart:io';

import 'package:bluetooth_thermal_printer_example/controllers/admin/libraryC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MetodeP extends StatefulWidget {
  @override
  _MetodePState createState() => _MetodePState();
}

class _MetodePState extends State<MetodeP> {
  final LibraryController metodeController = Get.put(LibraryController());
  final TextEditingController newMetodeController = TextEditingController();
  final TextEditingController poinController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: RefreshIndicator(
                onRefresh: () async {
                  await metodeController.refresh();
                },
                child: NotificationListener<ScrollNotification>(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Obx(() {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.people,
                                              size: 25,
                                              color: PrimaryColor().blue),
                                          SizedBox(width: 10),
                                          Text(
                                            'Metode Pembayaran',
                                            style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: buildNewMetodeDialog(),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: metodeController.metode.length,
                                    itemBuilder: (context, index) {
                                      var metode =
                                          metodeController.metode[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Stack(
                                          children: [
                                            buildMetodeDialog(
                                                metode['id'], metode['metode']),
                                            Positioned(
                                              right: 4,
                                              top: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            10),
                                                                    child:
                                                                        Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              25),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            255,
                                                                            169,
                                                                            163),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .delete_outline,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            50,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          25),
                                                                  Text(
                                                                    "Hapus Metode",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Text(
                                                                    "Apakah anda yakin untuk menghapus Metode ini?",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await metodeController.deleteMetode(
                                                                          metode[
                                                                              'id'],
                                                                          fromButton:
                                                                              true);
                                                                      await metodeController
                                                                          .refresh();
                                                                      Get.to(
                                                                          MetodeP());
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                8),
                                                                        Text(
                                                                          'Hapus',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor: Colors
                                                                          .grey
                                                                          .shade200,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                8),
                                                                        Text(
                                                                          'Batal',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                14,
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
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'X',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 32),
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.star_circle_fill,
                                      size: 25, color: PrimaryColor().blue),
                                  SizedBox(width: 10),
                                  Text(
                                    'Konfigurasi Poin Member',
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 32, top: 20),
                                  width: 300,
                                  child: buildTextField(
                                      controller: poinController,
                                      hintText: '1 Poin = "..." Rupiah',
                                      prefixIcon: Icons.star,
                                      type: TextInputType.number,
                                      inputFormat:
                                          LengthLimitingTextInputFormatter(20)),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    int newValue =
                                        int.tryParse(poinController.text) ??
                                            100;
                                    metodeController.simpanPoin(newValue);
                                    poinController.clear();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: PrimaryColor().blue,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Text(
                                        'Simpan',
                                        style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          if (metodeController.isLoading.value) {
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
          ],
        ),
      ),
      drawer: buildDrawer(context),
    );
  }

  Widget buildNewMetodeDialog() {
    return ElevatedButton(
      onPressed: () {
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
                            CupertinoIcons.person_2,
                            color: PrimaryColor().blue,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Tambahkan Metode Pembayaran ",
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
                          buildInputLabel('Nama Metode Pembayaran', " *"),
                          buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newMetodeController,
                            hintText: 'Metode Pembayaran',
                            prefixIcon: FontAwesomeIcons.moneyCheck,
                            type: TextInputType.name,
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
                          Obx(() => ElevatedButton(
                                onPressed: metodeController.isLoading.value
                                    ? null
                                    : () async {
                                        metodeController.isLoading.value = true;
                                        try {
                                          await metodeController.addMetode(
                                            newMetodeController.text,
                                          );
                                          newMetodeController.clear();
                                          await metodeController.refresh();
                                          Navigator.pop(context);
                                          newMetodeController.clear();
                                        } catch (e) {
                                          Get.snackbar("Error", e.toString());
                                        } finally {
                                          metodeController.isLoading.value =
                                              false;
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PrimaryColor().blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: metodeController.isLoading.value
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
                              )),
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
            'Tambah Metode',
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

  Widget buildMetodeDialog(String id, String metodeLama) {
    final TextEditingController namaMetodeController =
        TextEditingController(text: metodeLama);
    return GestureDetector(
      onTap: () {
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
                            FontAwesomeIcons.moneyCheck,
                            color: PrimaryColor().blue,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Edit Metode Pembayaran ",
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
                          buildInputLabel('Nama Metode Pembayaran', " *"),
                          buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: namaMetodeController,
                            hintText: 'Metode Pembayaran',
                            prefixIcon: FontAwesomeIcons.moneyCheck,
                            type: TextInputType.name,
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
                          ElevatedButton(
                            onPressed: () async {
                              await metodeController.editMetode(
                                id,
                                namaMetodeController.text,
                                fromButton: true,
                              );
                              await metodeController.refresh();
                              Navigator.pop(context);
                              namaMetodeController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PrimaryColor().blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.black,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.creditCard,
                  color: Colors.amber.shade300,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  metodeLama,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
      ),
    );
  }
}
