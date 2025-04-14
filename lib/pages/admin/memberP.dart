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

class MemberP extends StatefulWidget {
  @override
  _MemberPState createState() => _MemberPState();
}

class _MemberPState extends State<MemberP> {
  final LibraryController memberController = Get.put(LibraryController());

  final TextEditingController newNameController = TextEditingController();
  final TextEditingController newIdPegController = TextEditingController();
  final TextEditingController newNoController = TextEditingController();
  final TextEditingController newSaldoController = TextEditingController();
  final TextEditingController newPoinController = TextEditingController();

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
                  await memberController.refresh();
                },
                child: NotificationListener<ScrollNotification>(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: Obx(() {
                          if (memberController.isLoading.value &&
                              memberController.member.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (memberController.member.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_2_outlined,
                                        size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      "Tidak Ada Member Tersedia",
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
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var item = memberController.member[index];
                                return buildProductCard(item, context);
                              },
                              childCount: memberController.member.length,
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          if (memberController.isLoading.value) {
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
              padding: EdgeInsets.only(top: 90, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.peopleArrows,
                          size: 25, color: PrimaryColor().blue),
                      SizedBox(width: 10),
                      Text(
                        'Member',
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: buildDialog(),
                  ),
                ],
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
              color: Color.fromARGB(255, 243, 208, 35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 166, 31, 31),
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
                            color: Color.fromARGB(255, 166, 31, 31), size: 45),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Member : ' + item['nama'],
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Saldo : " +
                            "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(item['saldo'].toString()))}",
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Poin : ' + item['poin'] + ' poin',
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        item['no_tlp'],
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
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
                                  item['saldo'],
                                  item['poin'],
                                );
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      elevation: 0,
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: Container(
                                                    padding: EdgeInsets.all(25),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 255, 169, 163),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red,
                                                      size: 50,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 25),
                                                Text(
                                                  "Hapus Member",
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Apakah anda yakin untuk menghapus Member ini?",
                                                  style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await memberController
                                                        .deleteMember(
                                                            item['id'],
                                                            fromButton: true);
                                                    await memberController
                                                        .refresh();
                                                    await memberController
                                                        .fetchMember();
                                                    Get.to(MemberP());
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Hapus',
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
                                                SizedBox(height: 5),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(width: 8),
                                                      Text(
                                                        'Batal',
                                                        style: TextStyle(
                                                          color: Colors.black,
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
                            "Tambah Member Baru",
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
                          buildInputLabel('Nama Member', " *"),
                          buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newNameController,
                            hintText: 'Nama',
                            prefixIcon: CupertinoIcons.person_2_alt,
                            type: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          buildInputLabel('Id Pegawai', " *"),
                          buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newIdPegController,
                            hintText: 'ID : 1',
                            prefixIcon: CupertinoIcons.person_2_alt,
                            type: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          buildInputLabel('No. Whatsapp', " *"),
                          buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(12),
                            controller: newNoController,
                            hintText: '0861-XXXX-XXXX',
                            prefixIcon: CupertinoIcons.phone_circle,
                            type: TextInputType.phone,
                          ),
                          SizedBox(height: 10),
                          buildInputLabel('Saldo', ' *'),
                          buildTextField(
                            controller: newSaldoController,
                            hintText: 'Rp. 50.000',
                            prefixIcon: FontAwesomeIcons.moneyBill,
                            type: TextInputType.number,
                            inputFormat:
                                FilteringTextInputFormatter.singleLineFormatter,
                          ),
                          SizedBox(height: 10),
                          buildInputLabel('Poin User', ' *'),
                          buildTextField(
                            controller: newPoinController,
                            hintText: '500 poin',
                            prefixIcon: Icons.star,
                            type: TextInputType.number,
                            inputFormat:
                                FilteringTextInputFormatter.singleLineFormatter,
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
                                onPressed: memberController.isLoading.value
                                    ? null
                                    : () async {
                                        memberController.isLoading.value = true;
                                        try {
                                          await memberController.addNewMember(
                                            newNameController.text,
                                            newIdPegController.text,
                                            newNoController.text,
                                            newSaldoController.text,
                                            newPoinController.text,
                                            fromButton: true,
                                          );
                                          await memberController.refresh();
                                          Navigator.pop(context);
                                          newNameController.clear();
                                          newNoController.clear();
                                          newSaldoController.clear();
                                          newPoinController.clear();
                                        } catch (e) {
                                          print(
                                              "Error saat menambahkan member: $e");
                                          Get.snackbar("Error", e.toString());
                                        } finally {
                                          memberController.isLoading.value =
                                              false;
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PrimaryColor().blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: memberController.isLoading.value
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
            'Tambah Member',
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

  void showEditDialog(BuildContext context, String id, String memberLama,
      String no_tlp, String saldo, String poin) {
    final TextEditingController namaMemberController =
        TextEditingController(text: memberLama);
    final TextEditingController noMemberController =
        TextEditingController(text: no_tlp);
    final TextEditingController saldoMemberController =
        TextEditingController(text: saldo);
    final TextEditingController poinMemberController =
        TextEditingController(text: poin);

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildInputLabel('Nama Member', ' *'),
                  buildTextField(
                    controller: namaMemberController,
                    hintText: 'Toko Kue XXXX',
                    prefixIcon: CupertinoIcons.person_2_alt,
                    type: TextInputType.name,
                    inputFormat:
                        FilteringTextInputFormatter.singleLineFormatter,
                  ),
                  SizedBox(height: 15),
                  buildInputLabel('No. Whatsapp', ' *'),
                  buildTextField(
                    controller: noMemberController,
                    hintText: '0891-XXXX-XXXX',
                    prefixIcon: CupertinoIcons.phone_circle,
                    type: TextInputType.number,
                    inputFormat:
                        FilteringTextInputFormatter.singleLineFormatter,
                  ),
                  SizedBox(height: 15),
                  buildInputLabel('Saldo', ' *'),
                  buildTextField(
                    controller: saldoMemberController,
                    hintText: 'Rp. 50.000',
                    prefixIcon: FontAwesomeIcons.moneyBill,
                    type: TextInputType.number,
                    inputFormat:
                        FilteringTextInputFormatter.singleLineFormatter,
                  ),
                  SizedBox(height: 15),
                  buildInputLabel('Poin User', ' *'),
                  buildTextField(
                    controller: poinMemberController,
                    hintText: '500 poin',
                    prefixIcon: Icons.star,
                    type: TextInputType.number,
                    inputFormat:
                        FilteringTextInputFormatter.singleLineFormatter,
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
                          await memberController.editMember(
                            id,
                            namaMemberController.text,
                            noMemberController.text,
                            saldoMemberController.text,
                            poinMemberController.text,
                            fromButton: true,
                          );
                          Navigator.pop(context);
                          await memberController.fetchMember();
                          await memberController.refresh();
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

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 40);
    path.quadraticBezierTo(size.width * 0.75, 70, size.width, 40);

    path.lineTo(size.width, size.height - 40);

    path.quadraticBezierTo(
        size.width * 0.75, size.height, size.width * 0.5, size.height - 40);
    path.quadraticBezierTo(
        size.width * 0.25, size.height - 80, 0, size.height - 40);

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
