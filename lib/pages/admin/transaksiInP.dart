import 'package:bluetooth_thermal_printer_example/controllers/admin/transaksiInC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class TransaksiInP extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TransaksiInController c = Get.put(TransaksiInController());
  final TextEditingController stokController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 100, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: PrimaryColor().blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              'Transaksi Masuk Produk',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    c.jumlahPcsController
                                        .addListener(c.updateStokTotal);
                                    c.hargaPackController
                                        .addListener(c.updateStokTotal);
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
                                                    "Tambah Transaksi",
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
                                                      'Produk', " *"),
                                                  GestureDetector(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  PrimaryColor()
                                                                      .blue),
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 16,
                                                              horizontal: 20),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Obx(() =>
                                                              c.selectedProduct
                                                                          .value ==
                                                                      null
                                                                  ? Text(
                                                                      'Pilih Produk',
                                                                      style: GoogleFonts.nunito(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              PrimaryColor().blue),
                                                                    )
                                                                  : Text(
                                                                      '${c.ProdukName(c.selectedProduct.value.toString())}' +
                                                                          ' (${c.ProdukStok(c.selectedProduct.value.toString())} pcs)',
                                                                      style: GoogleFonts.nunito(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              PrimaryColor().blue),
                                                                    )),
                                                          Icon(
                                                            Icons.fastfood,
                                                            size: 25,
                                                            color:
                                                                PrimaryColor()
                                                                    .blue,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Dialog(
                                                              elevation: 2,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.5,
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                  ),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      TextField(
                                                                        controller:
                                                                            c.searchController,
                                                                        onChanged: (value) => c.searchProduct(
                                                                            value,
                                                                            c.produk),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                13),
                                                                        cursorColor:
                                                                            Colors.black12,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          prefixIcon:
                                                                              Icon(
                                                                            FontAwesomeIcons.magnifyingGlass,
                                                                            size:
                                                                                15,
                                                                            color:
                                                                                DarkColor().grey,
                                                                          ),
                                                                          suffixIcon: Obx(() => c.searchQuery.value.isNotEmpty
                                                                              ? IconButton(
                                                                                  icon: Icon(Icons.close, color: Colors.grey),
                                                                                  onPressed: () {
                                                                                    c.clearSearch();
                                                                                  },
                                                                                )
                                                                              : SizedBox()),
                                                                          contentPadding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 5,
                                                                              horizontal: 20),
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10.0)),
                                                                            borderSide:
                                                                                BorderSide(color: ShadowColor().blue),
                                                                          ),
                                                                          disabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10.0)),
                                                                            borderSide:
                                                                                BorderSide(color: ShadowColor().blue, width: 0.2),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10.0)),
                                                                            borderSide:
                                                                                BorderSide(color: ShadowColor().blue, width: 0.2),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: PrimaryColor().blue, width: 0.5),
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          fillColor:
                                                                              PrimaryColor().grey,
                                                                          filled:
                                                                              true,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                      Obx(() {
                                                                        if (c
                                                                            .isLoading
                                                                            .value) {
                                                                          return Center(
                                                                              child: CircularProgressIndicator());
                                                                        }
                                                                        if (c
                                                                            .filteredProduct
                                                                            .isEmpty) {
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(20),
                                                                            child:
                                                                                Text("Tidak ada produk ditemukan"),
                                                                          );
                                                                        }
                                                                        return Container(
                                                                          height:
                                                                              300,
                                                                          child:
                                                                              ListView.builder(
                                                                            itemCount:
                                                                                c.filteredProduct.length,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              final produk = c.filteredProduct[index];
                                                                              return Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.white,
                                                                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                      side: BorderSide(color: Colors.blueAccent),
                                                                                    ),
                                                                                    elevation: 1, // Efek bayangan
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    c.selectedProduct.value = produk['id'].toString();
                                                                                    Get.back();
                                                                                  },
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        produk['nama_barang'],
                                                                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                                                                                      ),
                                                                                      Text(
                                                                                        "${produk['stok']} pcs",
                                                                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        );
                                                                      }),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                  ),
                                                  SizedBox(height: 10),
                                                  buildInputLabel(
                                                      'Tambah Stok', " *"),
                                                  buildTextField(
                                                    inputFormat:
                                                        LengthLimitingTextInputFormatter(
                                                            50),
                                                    c: stokController,
                                                    hintText: 'Qty: ',
                                                    prefixIcon:
                                                        CupertinoIcons.cube_box,
                                                    type: TextInputType.number,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    child: Obx(
                                                      () =>
                                                          c.checkbox.value ==
                                                                  true
                                                              ? Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      1,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Container(
                                                                            width: MediaQuery.of(context).orientation == Orientation.portrait
                                                                                ? MediaQuery.of(context).size.width * 0.38
                                                                                : MediaQuery.of(context).size.width * 0.44,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                buildInputLabel('Harga Pack Produk', " "),
                                                                                buildTextField(
                                                                                  inputFormat: LengthLimitingTextInputFormatter(50),
                                                                                  c: c.hargaPackController,
                                                                                  hintText: 'Rp 60.000 ',
                                                                                  prefixIcon: FontAwesomeIcons.moneyBillWave,
                                                                                  type: TextInputType.number,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Spacer(),
                                                                          Container(
                                                                            width: MediaQuery.of(context).orientation == Orientation.portrait
                                                                                ? MediaQuery.of(context).size.width * 0.38
                                                                                : MediaQuery.of(context).size.width * 0.44,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                buildInputLabel('Jumlah Pcs Per-pack', " "),
                                                                                buildTextField(
                                                                                  inputFormat: LengthLimitingTextInputFormatter(50),
                                                                                  c: c.jumlahPcsController,
                                                                                  hintText: 'Qty : 42',
                                                                                  prefixIcon: Icons.inventory_2_outlined,
                                                                                  type: TextInputType.number,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                      Container(
                                                                        width:
                                                                            MediaQuery.of(context).size.width *
                                                                                1,
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            buildInputLabel('Harga Jual',
                                                                                " "),
                                                                            buildTextField(
                                                                              inputFormat: LengthLimitingTextInputFormatter(50),
                                                                              c: c.jualController,
                                                                              hintText: 'Rp 3.000 ',
                                                                              prefixIcon: FontAwesomeIcons.moneyBillWave,
                                                                              type: TextInputType.number,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              10),
                                                                      Obx(() =>
                                                                          Text(
                                                                            'Harga Satuan : Rp ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.hargaDasar.value.toString()))}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.grey.shade700,
                                                                            ),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Text(''),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Obx(() => Transform.scale(
                                                            scale: 0.9,
                                                            child: SizedBox(
                                                              height: 50,
                                                              child: Checkbox(
                                                                activeColor:
                                                                    PrimaryColor()
                                                                        .blue,
                                                                visualDensity:
                                                                    VisualDensity
                                                                        .compact,
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                value: c
                                                                    .checkbox
                                                                    .value,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  c.toggleCheckbox(
                                                                      value);
                                                                },
                                                              ),
                                                            ),
                                                          )),
                                                      Text(
                                                        'Harga produk mengalami perubahan?',
                                                        style:
                                                            GoogleFonts.nunito(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      c.selectedProduct.value =
                                                          null;
                                                    },
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
                                                      onPressed: () async {
                                                        int stok = int.tryParse(
                                                                stokController
                                                                    .text) ??
                                                            0;
                                                        int produkSatuan =
                                                            int.tryParse(c
                                                                    .hargaController
                                                                    .text
                                                                    .toString()) ??
                                                                0;
                                                        int totalHarga =
                                                            stok * produkSatuan;
                                                        if (c.selectedProduct
                                                                .value ==
                                                            null) {
                                                          Get.snackbar(
                                                            'Error',
                                                            'Produk Tidak Boleh Kosong, Pilih Produk Terlebih Dahulu!',
                                                            backgroundColor:
                                                                Colors.red
                                                                    .withOpacity(
                                                                        0.8),
                                                            colorText:
                                                                Colors.white,
                                                            icon: Icon(
                                                                Icons.error,
                                                                color: Colors
                                                                    .white),
                                                          );
                                                          return;
                                                        }
                                                        Get.back();
                                                        if (c.checkbox.value ==
                                                            false) {
                                                          await c.tambahStok(
                                                              c.selectedProduct
                                                                  .value
                                                                  .toString(),
                                                              stokController
                                                                  .text);
                                                        } else if (c.checkbox
                                                                .value ==
                                                            true) {
                                                          print('hargaDasar : ' +
                                                              c.hargaDasar
                                                                  .toString());
                                                          await c.editProduk(
                                                            c.selectedProduct
                                                                .value
                                                                .toString(),
                                                            c.hargaDasar.value
                                                                .toString(),
                                                            c.hargaPackController
                                                                .text,
                                                            c.jualController
                                                                .text,
                                                            c.jumlahPcsController
                                                                .text,
                                                          );
                                                          await c.tambahStok(
                                                              c.selectedProduct
                                                                  .value
                                                                  .toString(),
                                                              stokController
                                                                  .text);
                                                        }
                                                        await c.addTransaksiIn(
                                                            stokController.text,
                                                            totalHarga
                                                                .toString());
                                                        await c.addDetTransaksiIn(
                                                            c.selectedProduct
                                                                .value
                                                                .toString(),
                                                            stokController.text,
                                                            c.hargaController
                                                                .text,
                                                            c.jualController
                                                                .text
                                                                .toString());
                                                        await c
                                                            .fetchTransaksiDet();
                                                        await c
                                                            .fetchTransaksiIn();
                                                        await c.fetchProduk();
                                                        stokController.clear();
                                                        c.selectedProduct
                                                            .value = null;
                                                        c.toggleCheckbox(false);
                                                        c.clearSearch();
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
                                                      child: c.isLoading.value
                                                          ? SizedBox(
                                                              width: 15,
                                                              height: 15,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                                strokeWidth: 2,
                                                              ),
                                                            )
                                                          : Row(
                                                              children: [
                                                                Icon(
                                                                  CupertinoIcons
                                                                      .add,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'Tambah',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Tambahkan Stok Baru',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.assignment_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Riwayat Transaksi Masuk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (c.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (c.transaksiDet.isEmpty) {
                        return Center(child: Text("Tidak ada transaksi"));
                      }
                      return ListView.separated(
                        itemCount: c.transaksiDet.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          var transaksi = c.transaksiDet[index];
                          return buildCardTransaksi(
                              c.ProdukName(transaksi['id_produk']),
                              c.NoTransaksi(transaksi['id_transaksi_in']),
                              formatDate(transaksi['input_date']),
                              transaksi['jumlah'].toString(),
                              'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(int.parse(transaksi['total_harga']))}',
                              'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(int.parse(transaksi['harga_satuan']))}',
                              'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(int.parse(transaksi['harga_jual']))}');
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            NavbarDrawer(context, scaffoldKey),
          ],
        ),
      ),
      drawer: buildDrawer(context),
    );
  }
}

Widget buildCardTransaksi(
  String name,
  String noTransaksi,
  String tanggal,
  String jumlah,
  String total,
  String satuan,
  String jual,
) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fastfood_rounded,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name + ' ($jumlah pcs)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        noTransaksi,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  total,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Transaksi',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        tanggal,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harga Satuan',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        satuan,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Harga Jual',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        jual,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Berhasil',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
  required TextEditingController c,
  required String hintText,
  required IconData prefixIcon,
  required TextInputType type,
  required inputFormat,
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
      controller: c,
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

String formatDate(String dateString) {
  final date = DateTime.parse(dateString);
  final formatter = DateFormat('dd MMM yyyy');
  return formatter.format(date);
}
