import 'dart:ui';

import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/kasir/kasirC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/dividerW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class KasirW {
  final AuthController logoutController = Get.put(AuthController());
  final KasirC controller = Get.put(KasirC());

  GestureDetector logout(context) {
    return GestureDetector(
      child: Text(
        "Logout",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: PrimaryColor().blue,
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 169, 163),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.logout_outlined,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Apakah anda yakin untuk melakukan Logout?",
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                            await logoutController.logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Batal',
                                style: TextStyle(
                                  color: Colors.black,
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
            );
          },
        );
      },
    );
  }

  GestureDetector product(
      nama,
      mitra,
      harga,
      stok,
      foto,
      varian,
      addOn,
      listDibeli,
      tambahKeKeranjangFunc,
      kurangKeKeranjangFunc,
      context,
      index) {
    return GestureDetector(
      onTap: () {
        print(listDibeli.length.toString());
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(foto), fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                nama,
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mitra ?? "Tidak Memiliki Mitra",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w300,
                      fontSize: 8,
                      color: PrimaryColor().black,
                    ),
                  ),
                  Text(
                    stok ?? "Stok Telah Habis",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w300,
                      fontSize: 9,
                      color: PrimaryColor().black,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp. ' + harga,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: PrimaryColor().blue,
                    ),
                  ),
                  Text(
                    varian,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w300,
                      fontSize: 8,
                      color: PrimaryColor().blue,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 7,
              ),
              listDibeli.length.toString() != '0'
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: PrimaryColor().grey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: kurangKeKeranjangFunc,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: PrimaryColor().blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                size: 13,
                                FontAwesomeIcons.minus,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            listDibeli.length.toString(),
                            style: GoogleFonts.nunito(
                                fontSize: 14, color: PrimaryColor().blue),
                          ),
                          GestureDetector(
                            onTap: tambahKeKeranjangFunc,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: PrimaryColor().blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                size: 13,
                                FontAwesomeIcons.plus,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ))
                  : stok != 'Stok : 0'
                      ? GestureDetector(
                          onTap: () {
                            if (addOn != '1') {
                              final int hargaAsli = int.tryParse(
                                      harga.replaceAll(RegExp(r'[^\d]'), '')) ??
                                  0; // Mengambil harga asli dari harga yang diformat
                              showAddOnDialog(
                                  context,
                                  index,
                                  nama,
                                  hargaAsli,
                                  stok,
                                  addOn,
                                  kurangKeKeranjangFunc,
                                  tambahKeKeranjangFunc,
                                  foto);
                            } else {
                              tambahKeKeranjangFunc();
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: PrimaryColor().grey,
                                border: Border.all(
                                    width: 1, color: PrimaryColor().blue)),
                            child: Text(
                              'Tambahkan',
                              style: GoogleFonts.nunito(
                                  fontSize: 11, color: PrimaryColor().blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : GestureDetector(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                                border:
                                    Border.all(width: 1, color: Colors.red)),
                            child: Text(
                              'Stok Telah Habis',
                              style: GoogleFonts.nunito(
                                  fontSize: 11, color: DarkColor().red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
            ],
          )),
    );
  }

  void showAddOnDialog(BuildContext context, int index, nama, harga, stok,
      addOn, kurangKeKeranjangFunc, tambahKeKeranjangFunc, foto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add On',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(foto), fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          nama,
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$stok',
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Obx(() {
                              final int jumlah = controller.jumlahPesanan.value;
                              final int hargaTambahan =
                                  controller.addOnHarga(addOn);
                              final int totalHarga =
                                  (controller.selectedAddOn.value == 'Rebus')
                                      ? harga * jumlah + hargaTambahan
                                      : harga * jumlah;

                              return Text(
                                "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(totalHarga.toString()))}",
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: PrimaryColor().blue,
                                ),
                              );
                            }),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.selectedAddOn.value = 'Tidak';
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: controller.selectedAddOn.value ==
                                            'Tidak'
                                        ? PrimaryColor().blue
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: controller.selectedAddOn.value ==
                                              'Tidak'
                                          ? PrimaryColor().blue
                                          : Colors.grey,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Tidak',
                                    style: GoogleFonts.nunito(
                                      color: controller.selectedAddOn.value ==
                                              'Tidak'
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  controller.selectedAddOn.value = 'Rebus';
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: controller.selectedAddOn.value ==
                                            'Rebus'
                                        ? PrimaryColor().blue
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: controller.selectedAddOn.value ==
                                              'Rebus'
                                          ? PrimaryColor().blue
                                          : Colors.grey,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    controller.addOnName(addOn),
                                    style: GoogleFonts.nunito(
                                      color: controller.selectedAddOn.value ==
                                              'Rebus'
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: 300,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: PrimaryColor().grey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.jumlahPesanan.value--;
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: PrimaryColor().blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                size: 13,
                                FontAwesomeIcons.minus,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Obx(() => Text(
                                '${controller.jumlahPesanan.value}',
                                style: GoogleFonts.nunito(
                                  fontSize: 14,
                                  color: PrimaryColor().blue,
                                ),
                              )),
                          GestureDetector(
                            onTap: () {
                              controller.jumlahPesanan.value++;
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: PrimaryColor().blue,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Icon(
                                size: 13,
                                FontAwesomeIcons.plus,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  final stok = int.tryParse(
                          controller.filteredProduk[index]['jumlah']) ??
                      0;
                  final dibeli =
                      controller.filteredProduk[index]['listDibeli'].length;
                  final sisaStok = stok - dibeli;

                  final selectedAddOn = controller.selectedAddOn.value;
                  final addOnValue =
                      selectedAddOn == 'Rebus' ? addOn.toString() : '1';

                  if (controller.jumlahPesanan.value <= sisaStok) {
                    for (int i = 0; i < controller.jumlahPesanan.value; i++) {
                      controller.tambahKeKeranjang(index, null,
                          addOnValue: addOnValue);
                    }
                    controller.jumlahPesanan.value = 0;
                    Navigator.pop(context);
                  } else {
                    Get.snackbar(
                        "Stok Tidak Cukup", "Jumlah melebihi stok tersedia");
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: PrimaryColor().blue,
                      border: Border.all(width: 1, color: PrimaryColor().blue)),
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  GestureDetector kategori(
      kategori, foto, IconData icon, void Function(String) onKategoriSelected) {
    return GestureDetector(
      onTap: () {
        print(kategori);
        onKategoriSelected(kategori);
      },
      child: Obx(() {
        bool isSelected = controller.selectedCategory.value == kategori;
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(foto), fit: BoxFit.cover),
                  color: PrimaryColor().blue,
                  borderRadius: BorderRadius.circular(10)),
              height: 70,
            ),
            Container(
              padding: EdgeInsets.only(left: 17),
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: isSelected ? Colors.transparent : Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              height: 70,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        size: 13,
                        icon,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      kategori,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Column bill(produk, harga, addOn, jumlah, tipe) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                produk,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
            Text(
              harga,
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: PrimaryColor().blue),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        if (addOn != '1')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.addOnName(addOn),
                style: GoogleFonts.nunito(
                  fontSize: 10,
                ),
              ),
              Text(
                "+ ${NumberFormat('#,##0', 'id_ID').format(controller.addOnHarga(addOn))}",
                style: GoogleFonts.nunito(
                    fontSize: 10, color: PrimaryColor().blue),
              ),
            ],
          ),
        if (addOn == '1') SizedBox(height: 1),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jumlah',
              style: GoogleFonts.nunito(
                fontSize: 10,
              ),
            ),
            Text(
              jumlah,
              style: GoogleFonts.nunito(
                fontSize: 10,
              ),
            ),
          ],
        ),
        if (tipe != null)
          SizedBox(
            height: 5,
          ),
        if (tipe != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tipe',
                style: GoogleFonts.nunito(
                  fontSize: 10,
                ),
              ),
              Text(
                tipe,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        DividerW().ColumnSpaceDivider(),
      ],
    );
  }

  GestureDetector tombolQris(BuildContext context, RxBool isLoading,
      String harga, String qrisData, VoidCallback onTap) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: PrimaryColor().blue),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bayar QRIS',
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: PrimaryColor().blue),
            ),
            Icon(
              Icons.qr_code_scanner, // Menggunakan ikon QR lebih umum
              size: 14,
              color: PrimaryColor().blue,
            )
          ],
        ),
      ),
      onTap: () {
        KasirC c = Get.put(KasirC());
        if (c.banyakDibeli == 0 || c.banyakDibeli == '') {
          Get.snackbar(
            'Error',
            'Produk Tidak Boleh Kosong!',
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            icon: Icon(Icons.error, color: Colors.white),
          );
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Pembayaran QRIS',
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black)),
                    SizedBox(height: 5),
                    Text('Koperasi Karyawan Anugrah Artha Abadi',
                        style: GoogleFonts.nunito(
                            fontSize: 13, color: Colors.grey.shade600)),
                    SizedBox(height: 10),

                    // Generate QR Code QRIS yang bisa dipindai
                    QrImageView(
                      data: qrisData,
                      version: QrVersions.auto,
                      size: 200,
                      embeddedImage: AssetImage("assets/image/aas_logo.png"),
                    ),

                    SizedBox(height: 10),
                    Text(
                      'Scan QRIS',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Total Pembayaran : $harga',
                      style: GoogleFonts.nunito(
                          fontSize: 13, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 10),
                    Obx(() => Container(
                          width: 300,
                          child: ElevatedButton(
                            onPressed: isLoading.value ? null : onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PrimaryColor().blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading.value
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: SizedBox(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Selesaikan Pembayaran',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  GestureDetector tombolTunai(
    context,
    RxBool isLoading,
    harga,
    member,
    TextEditingController saldoController,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: PrimaryColor().blue),
          color: PrimaryColor().blue,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tunai',
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            Icon(
              FontAwesomeIcons.moneyBill,
              size: 14,
              color: Colors.white,
            )
          ],
        ),
      ),
      onTap: () {
        KasirC c = Get.put(KasirC());
        saldoController.text = harga;
        RxDouble nominalBayar =
            RxDouble(double.tryParse(saldoController.text) ?? 0);
        RxDouble kembalian =
            RxDouble(nominalBayar.value - double.parse(harga.toString()));
        saldoController.addListener(() {
          nominalBayar.value = double.tryParse(saldoController.text) ?? 0;
          kembalian.value = nominalBayar.value - double.parse(harga.toString());
        });

        if (c.banyakDibeli == 0 || c.banyakDibeli == '') {
          Get.snackbar(
            'Error',
            'Produk Tidak Boleh Kosong!',
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            icon: Icon(Icons.error, color: Colors.white),
          );
          return;
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 174, 255, 163),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right: 7),
                                child: Icon(
                                  FontAwesomeIcons.moneyBill1,
                                  color: Colors.green,
                                  size: 60,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Pembayaran Tunai',
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            Text(
                              'Pilih status pembayaran untuk menyelesaikan transaksi dengan Tunai ',
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Member : ' + member,
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey.shade600),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Total Harga : Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(harga.toString()))}",
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                            Obx(() => Text(
                                  'Nominal : Rp. ${NumberFormat('#,##0', 'id_ID').format(nominalBayar.value)}',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                )),
                            Obx(() => Text(
                                  'Kembalian : Rp. ${NumberFormat('#,##0', 'id_ID').format(kembalian.value)}',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kembalian.value < 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                )),
                            SizedBox(height: 20),
                            Container(
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade50,
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                  autofocus: true,
                                  keyboardType: TextInputType.number,
                                  controller: saldoController,
                                  cursorColor: PrimaryColor().blue,
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, left: 10),
                                      child: Text('Rp. ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    hintText: 'Total Pembayaran',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade400,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(() => Container(
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: isLoading.value ? null : onTap,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isLoading.value
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: SizedBox(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            'Selesaikan Pembayaran',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                )),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
