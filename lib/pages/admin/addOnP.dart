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

class AddOnP extends StatefulWidget {
  @override
  _AddOnPState createState() => _AddOnPState();
}

class _AddOnPState extends State<AddOnP> {
  final LibraryController addOnC = Get.put(LibraryController());
  final TextEditingController namaAddOnNewController = TextEditingController();
  final TextEditingController hargaAddOnNewController = TextEditingController();
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
                  await addOnC.refresh();
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
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.landscape
                                                  ? 0.75
                                                  : 0.55),
                                          child: Row(
                                            children: [
                                              Icon(Icons.add_to_photos_outlined,
                                                  size: 25,
                                                  color: PrimaryColor().blue),
                                              SizedBox(width: 10),
                                              Text(
                                                'Add On Barang',
                                                style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: buildNewAddOnDialog(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  padding: EdgeInsets.only(top: 10),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: addOnC.addOn.length,
                                    itemBuilder: (context, index) {
                                      var addOn = addOnC.addOn[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Stack(
                                          children: [
                                            buildAddOnDialog(
                                                addOn['id'],
                                                addOn['add_on'],
                                                addOn['harga']),
                                            Positioned(
                                              right: 4,
                                              top: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  AdminW().deleteDialog(
                                                    context,
                                                    'Hapus Add On',
                                                    'Apakah anda yakin ingin menghapus Add On ini ?',
                                                    () async {
                                                      await addOnC.deleteAddOn(
                                                          addOn['id'],
                                                          fromButton: true);
                                                      await addOnC.refresh();
                                                      Get.to(AddOnP());
                                                      Navigator.pop(context);
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
                        child: Obx(() {
                          if (addOnC.isLoading.value) {
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

  Widget buildNewAddOnDialog() {
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
                            Icons.add_to_photos_outlined,
                            color: PrimaryColor().blue,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Tambah Add On",
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
                          AdminW().buildInputLabel('Nama Add On', " *"),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: namaAddOnNewController,
                            hintText: 'Rebus',
                            prefixIcon: Icons.add_to_photos_outlined,
                            type: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          AdminW().buildInputLabel('Harga Add On', " *"),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: hargaAddOnNewController,
                            hintText: 'Rp. ',
                            prefixIcon: FontAwesomeIcons.moneyBillWave,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: 10),
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
                                onPressed: addOnC.isLoading.value
                                    ? null
                                    : () async {
                                        addOnC.isLoading.value = true;
                                        try {
                                          await addOnC.addAddOn(
                                            namaAddOnNewController.text,
                                            hargaAddOnNewController.text,
                                          );
                                          await addOnC.refresh();
                                          namaAddOnNewController.clear();
                                          hargaAddOnNewController.clear();
                                          Navigator.pop(context);
                                        } catch (e) {
                                          Get.snackbar("Error", e.toString());
                                        } finally {
                                          addOnC.isLoading.value = false;
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PrimaryColor().blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: addOnC.isLoading.value
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
            'Tambah Add On',
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

  Widget buildAddOnDialog(String id, String addOn, String harga) {
    final TextEditingController newAddOnText =
        TextEditingController(text: addOn);
    final TextEditingController newAddOnHargaText =
        TextEditingController(text: harga);
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
                            Icons.add_to_photos_outlined,
                            color: PrimaryColor().blue,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Edit Add On ",
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
                          AdminW().buildInputLabel('Nama Add On', " *"),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newAddOnText,
                            hintText: 'Rebus',
                            prefixIcon: Icons.add_to_photos_outlined,
                            type: TextInputType.name,
                          ),
                          SizedBox(height: 10),
                          AdminW().buildInputLabel('Harga Add On', " *"),
                          AdminW().buildTextField(
                            inputFormat: LengthLimitingTextInputFormatter(200),
                            controller: newAddOnHargaText,
                            hintText: 'Rp. ',
                            prefixIcon: FontAwesomeIcons.moneyBillWave,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: 10),
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
                              await addOnC.editAddOn(
                                id,
                                newAddOnText.text,
                                newAddOnHargaText.text,
                                fromButton: true,
                              );
                              await addOnC.refresh();
                              newAddOnText.clear();
                              newAddOnHargaText.clear();
                              Navigator.pop(context);
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
        color: Colors.white,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 120),
            child: Column(
              children: [
                Text(
                  truncateWords(addOn, 10),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String truncateWords(String text, int maxWords) {
    final words = text.trim().split(RegExp(r'\s+'));
    if (words.length <= maxWords) return text;
    return words.take(maxWords).join(' ') + '...';
  }
}
