import 'dart:io';

import 'package:bluetooth_thermal_printer_example/controllers/admin/libraryC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/admin/adminW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MitraP extends StatefulWidget {
  @override
  _MitraPState createState() => _MitraPState();
}

class _MitraPState extends State<MitraP> {
  final LibraryController mitraController = Get.put(LibraryController());

  final TextEditingController newTipeController = TextEditingController();

  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newNoController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();

  final TextEditingController newNoRekController = TextEditingController();
  final TextEditingController newRekNamaController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final gambarProdukController = FileImage(File(''));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130),
              child: RefreshIndicator(
                onRefresh: () async {
                  await mitraController.refresh();
                },
                child: NotificationListener<ScrollNotification>(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: Obx(() {
                          if (mitraController.isLoading.value &&
                              mitraController.mitra.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (mitraController.mitra.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_2_outlined,
                                        size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      "Tidak Ada Mitra Tersedia",
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
                              crossAxisCount: getCrossAxisCount(context),
                              childAspectRatio: 0.5,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var item = mitraController.mitra[index];
                                return buildProductCard(item, context);
                              },
                              childCount: mitraController.mitra.length,
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          if (mitraController.isLoading.value) {
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
                          Icon(FontAwesomeIcons.peopleArrows,
                              size: 25, color: PrimaryColor().blue),
                          SizedBox(width: 10),
                          Text(
                            'Mitra Barang',
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
    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            color: PrimaryColor().blue, size: 45),
                      ),
                      SizedBox(height: 10),
                      Text(item['nama'],
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                      Text(
                        item['no_tlp'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Visibility(
                        visible: item['email'] != null &&
                            item['email'].toString().trim().isNotEmpty,
                        child: Text(
                          item['email'],
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Visibility(
                        visible: item['no_rek'] != null &&
                            item['no_rek'].toString().trim().isNotEmpty,
                        child: Text(
                          item['no_rek'],
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Visibility(
                        visible: item['nama_rek'] != null &&
                            item['nama_rek'].toString().trim().isNotEmpty,
                        child: Text(
                          '${item['nama_rek']} (${item['bank_rek'] ?? ' '})',
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue,
                            ),
                            child: GestureDetector(
                              child: Text(
                                'Edit',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              onTap: () {
                                showEditDialog(
                                    context,
                                    item['id'],
                                    item['nama'],
                                    item['no_tlp'],
                                    item['email'] ?? ' ',
                                    item['bank_rek'] ?? ' ',
                                    item['no_rek'] ?? ' ',
                                    item['nama_rek'] ?? ' ');
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 13, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red,
                            ),
                            child: GestureDetector(
                              child: Text(
                                'Hapus',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                              onTap: () {
                                AdminW().deleteDialog(
                                  context,
                                  'Hapus Mitra',
                                  'Apakah anda yakin ingin menghapus mitra ${item['nama']} ?',
                                  () async {
                                    await mitraController.deleteMitra(
                                        item['id'],
                                        fromButton: true);
                                    await mitraController.refresh();
                                    Get.to(MitraP());
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdminW().buildInputLabel('Nama Mitra', " *"),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newNameController,
                            hintText: 'Toko Kue XXXX',
                            prefixIcon: CupertinoIcons.person_2_alt,
                            type: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          AdminW().buildInputLabel('No. Whatsapp', " *"),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(12),
                            controller: newNoController,
                            hintText: '0861-XXXX-XXXX',
                            prefixIcon: CupertinoIcons.phone_circle,
                            type: TextInputType.phone,
                          ),
                          SizedBox(height: 10),
                          AdminW()
                              .buildInputLabel('Email Mitra (opsional)', " "),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newEmailController,
                            hintText: 'contoh: 3yL6A@example.com',
                            prefixIcon: Icons.alternate_email,
                            type: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 10),
                          AdminW().buildInputLabel('Nama Bank (opsional)', " "),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                AdminW()
                                    .showBankDialog(context, mitraController);
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
                                  Obx(() =>
                                      mitraController.selectedBank.value == null
                                          ? Text(
                                              'Pilih Bank',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : Text(
                                              mitraController.selectedBank.value
                                                      .toString() +
                                                  " (${mitraController.KodeBank})",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          AdminW()
                              .buildInputLabel('No Rekening (opsional)', " "),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newNoRekController,
                            hintText: 'contoh: 01982173019',
                            prefixIcon: Icons.account_balance_wallet,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: 10),
                          AdminW().buildInputLabel(
                              'Nama Pemilik Rekening (opsional)', " "),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newRekNamaController,
                            hintText: 'contoh: ARTHA ABADI',
                            prefixIcon: Icons.face,
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
                                onPressed: mitraController.isLoading.value
                                    ? null
                                    : () async {
                                        mitraController.isLoading.value = true;
                                        try {
                                          await mitraController.addNewMitra(
                                            newNameController.text,
                                            newNoController.text,
                                            newEmailController.text,
                                            mitraController.selectedBank.value
                                                .toString(),
                                            newNoRekController.text,
                                            newRekNamaController.text,
                                            fromButton: true,
                                          );
                                          Navigator.pop(context);
                                          newNameController.clear();
                                          newNoController.clear();
                                          newEmailController.clear();
                                          newNoRekController.clear();
                                          newRekNamaController.clear();
                                          mitraController.selectedBank.value =
                                              null;
                                          await mitraController.refresh();
                                        } catch (e) {
                                          Get.snackbar("Error", e.toString());
                                        } finally {
                                          mitraController.isLoading.value =
                                              false;
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PrimaryColor().blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: mitraController.isLoading.value
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
        ).then((value) {
          mitraController.selectedBank.value = null;
        });
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
            'Tambah Mitra',
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

  void showEditDialog(BuildContext context, String id, String mitraLama,
      String no_tlp, String email, String bank, String noRek, String namaRek) {
    final TextEditingController namaMitraController =
        TextEditingController(text: mitraLama);
    final TextEditingController noMitraController =
        TextEditingController(text: no_tlp);
    String selectedBankEdit = bank;
    final TextEditingController emailMitraController =
        TextEditingController(text: email);
    final TextEditingController noRekMitraController =
        TextEditingController(text: noRek);
    final TextEditingController namaRekMitraController =
        TextEditingController(text: namaRek);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print("Cek isi nya $bank");
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.peopleArrows,
                        color: PrimaryColor().blue,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Edit Member ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      AdminW().buildInputLabel('Nama Mitra', ' *'),
                      AdminW().buildTextField(
                        controller: namaMitraController,
                        hintText: 'Toko Kue XXXX',
                        prefixIcon: CupertinoIcons.person_2_alt,
                        type: TextInputType.name,
                        inputFormat:
                            FilteringTextInputFormatter.singleLineFormatter,
                      ),
                      SizedBox(height: 15),
                      AdminW().buildInputLabel('No. Whatsapp', ' *'),
                      AdminW().buildTextField(
                        controller: noMitraController,
                        hintText: '0891-XXXX-XXXX',
                        prefixIcon: CupertinoIcons.phone_circle,
                        type: TextInputType.number,
                        inputFormat:
                            FilteringTextInputFormatter.singleLineFormatter,
                      ),
                      SizedBox(height: 15),
                      AdminW().buildInputLabel('Email Mitra(opsional)', ' *'),
                      AdminW().buildTextField(
                        controller: emailMitraController,
                        hintText: 'contoh: 3yL6A@example.com',
                        prefixIcon: Icons.alternate_email,
                        type: TextInputType.emailAddress,
                        inputFormat:
                            FilteringTextInputFormatter.singleLineFormatter,
                      ),
                      SizedBox(height: 10),
                      AdminW().buildInputLabel('Nama Bank (opsional)', " "),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            AdminW().showBankDialog(context, mitraController,
                                namaBank: selectedBankEdit);
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
                              Obx(() =>
                                  mitraController.selectedBank.value == null
                                      ? Text(
                                          selectedBankEdit,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          mitraController.selectedBank.value
                                                  .toString() +
                                              " (${mitraController.KodeBank})",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      AdminW().buildInputLabel('No Rekening (opsional)', " "),
                      AdminW().buildTextField(
                        inputFormat: LengthLimitingTextInputFormatter(200),
                        controller: noRekMitraController,
                        hintText: 'contoh: 01982173019',
                        prefixIcon: Icons.account_balance_wallet,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      AdminW().buildInputLabel(
                          'Nama Pemilik Rekening (opsional)', " "),
                      AdminW().buildTextField(
                        inputFormat: LengthLimitingTextInputFormatter(200),
                        controller: namaRekMitraController,
                        hintText: 'contoh: ARTHA ABADI',
                        prefixIcon: Icons.face,
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
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          var selectedBank =
                              mitraController.selectedBank.value ??
                                  selectedBankEdit;
                          await mitraController.editMitra(
                            id,
                            namaMitraController.text,
                            noMitraController.text,
                            emailMitraController.text,
                            selectedBank.toString(),
                            noRekMitraController.text,
                            namaRekMitraController.text,
                            fromButton: true,
                          );
                          Navigator.pop(context);
                          await mitraController.fetchMitra();
                          await mitraController.refresh();
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
    ).then((value) {
      mitraController.selectedBank.value = null;
    });
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height - 60, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

int getCrossAxisCount(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width > 900) return 5;
  if (width > 600) return 3;
  return 2;
}
