import 'package:bluetooth_thermal_printer_example/controllers/admin/transaksiInMitraC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransaksiInMitraP extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TransaksiInMitraController cM = Get.put(TransaksiInMitraController());
  final TextEditingController stokControllerM = TextEditingController();

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
                      color: DarkColor().red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'Transaksi Masuk Mitra',
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
                                                      CupertinoIcons
                                                          .add_circled,
                                                      color:
                                                          PrimaryColor().blue,
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
                                                                    .circular(
                                                                        5)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 16,
                                                                horizontal: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Obx(
                                                              () => cM.selectedProductM
                                                                          .value ==
                                                                      null
                                                                  ? Flexible(
                                                                      child:
                                                                          Text(
                                                                        'Pilih Produk',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              PrimaryColor().blue,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    )
                                                                  : Flexible(
                                                                      child:
                                                                          Text(
                                                                        '${cM.ProdukNameM(cM.selectedProductM.value.toString())}'
                                                                        ' (${cM.NamaMitra(cM.selectedProductM.value.toString())}) : '
                                                                        '${cM.ProdukStokM(cM.selectedProductM.value.toString())} pcs',
                                                                        style: GoogleFonts
                                                                            .nunito(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              PrimaryColor().blue,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                    ),
                                                            ),
                                                            Icon(
                                                              Icons.handshake,
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
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Dialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(context)
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
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        TextField(
                                                                          controller:
                                                                              cM.searchMController,
                                                                          onChanged: (value) => cM.searchProduct(
                                                                              value,
                                                                              cM.produkM),
                                                                          style:
                                                                              const TextStyle(fontSize: 13),
                                                                          cursorColor:
                                                                              Colors.black12,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            prefixIcon:
                                                                                Icon(
                                                                              FontAwesomeIcons.magnifyingGlass,
                                                                              size: 15,
                                                                              color: DarkColor().grey,
                                                                            ),
                                                                            suffixIcon: Obx(() => cM.searchQueryM.value.isNotEmpty
                                                                                ? IconButton(
                                                                                    icon: Icon(Icons.close, color: Colors.grey),
                                                                                    onPressed: () {
                                                                                      cM.clearSearch();
                                                                                    },
                                                                                  )
                                                                                : SizedBox()),
                                                                            contentPadding:
                                                                                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                              borderSide: BorderSide(color: ShadowColor().blue),
                                                                            ),
                                                                            disabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                              borderSide: BorderSide(color: ShadowColor().blue, width: 0.2),
                                                                            ),
                                                                            enabledBorder:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                              borderSide: BorderSide(color: ShadowColor().blue, width: 0.2),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(color: PrimaryColor().blue, width: 0.5),
                                                                              borderRadius: BorderRadius.circular(10.0),
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
                                                                          if (cM
                                                                              .isLoadingM
                                                                              .value) {
                                                                            return Center(child: CircularProgressIndicator());
                                                                          }
                                                                          if (cM
                                                                              .filteredProductM
                                                                              .isEmpty) {
                                                                            return Padding(
                                                                              padding: const EdgeInsets.all(20),
                                                                              child: Text("Tidak ada produk ditemukan"),
                                                                            );
                                                                          }
                                                                          return Container(
                                                                            height:
                                                                                300,
                                                                            child:
                                                                                ListView.builder(
                                                                              itemCount: cM.filteredProductM.length,
                                                                              itemBuilder: (context, index) {
                                                                                final produk = cM.filteredProductM[index];
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
                                                                                      cM.selectedProductM.value = produk['id'].toString();
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: Text(
                                                                                            produk['nama_barang'].toString(),
                                                                                            style: TextStyle(
                                                                                              fontSize: 14,
                                                                                              fontWeight: FontWeight.bold,
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(width: 8), // beri jarak agar tidak terlalu mepet
                                                                                        Text(
                                                                                          "${produk['stok']} pcs",
                                                                                          style: TextStyle(
                                                                                            fontSize: 12,
                                                                                            color: Colors.grey.shade600,
                                                                                          ),
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
                                                      cM: stokControllerM,
                                                      hintText: 'Qty: ',
                                                      prefixIcon: CupertinoIcons
                                                          .cube_box,
                                                      type:
                                                          TextInputType.number,
                                                    ),
                                                    SizedBox(height: 10),
                                                    Container(
                                                      child: Obx(
                                                        () => cM.checkboxM
                                                                    .value ==
                                                                true
                                                            ? Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    1,
                                                                child: Wrap(
                                                                  spacing: 16,
                                                                  runSpacing:
                                                                      16,
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          buildInputLabel(
                                                                              'Harga Satuan',
                                                                              " "),
                                                                          buildTextField(
                                                                            inputFormat:
                                                                                LengthLimitingTextInputFormatter(50),
                                                                            cM: cM.satuanMController,
                                                                            hintText:
                                                                                'Rp 3.000 ',
                                                                            prefixIcon:
                                                                                FontAwesomeIcons.moneyBillWave,
                                                                            type:
                                                                                TextInputType.number,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          buildInputLabel(
                                                                              'Harga Jual',
                                                                              " "),
                                                                          buildTextField(
                                                                            inputFormat:
                                                                                LengthLimitingTextInputFormatter(50),
                                                                            cM: cM.jualMController,
                                                                            hintText:
                                                                                'Rp 4000',
                                                                            prefixIcon:
                                                                                FontAwesomeIcons.moneyBillWave,
                                                                            type:
                                                                                TextInputType.number,
                                                                          ),
                                                                          SizedBox(
                                                                              height: 10),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : Text(''),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Obx(() =>
                                                            Transform.scale(
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
                                                                  value: cM
                                                                      .checkboxM
                                                                      .value,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    cM.toggleCheckbox(
                                                                        value);
                                                                  },
                                                                ),
                                                              ),
                                                            )),
                                                        Flexible(
                                                          child: Text(
                                                            'Harga produk mengalami perubahan?',
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black),
                                                          ),
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
                                                        cM.selectedProductM
                                                            .value = null;
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
                                                          print(
                                                              'pilih product: ${cM.selectedProductM}');
                                                          print(
                                                              'nama product: ${cM.NamaBarang}');
                                                          print(
                                                              'barcode product: ${cM.BarcodeBarang}');
                                                          print(
                                                              'gambar product: ${cM.GambarBarang}');
                                                          print(
                                                              'id kategori product: ${cM.KategoriBarang}');
                                                          print(
                                                              'id tipe product: ${cM.TipeBarang}');
                                                          print(
                                                              'id mitra product: ${cM.MitraBarang}');
                                                          print(
                                                              'id harga pack product: ${cM.HargaPack}');
                                                          print(
                                                              'id jumlah pcs product: ${cM.JumlahPcs}');
                                                          print(
                                                              'id stok product: ${cM.StokBarang}');
                                                          int stok = int.tryParse(
                                                                  stokControllerM
                                                                      .text) ??
                                                              0;
                                                          int produkSatuan =
                                                              int.tryParse(cM
                                                                      .satuanMController
                                                                      .text
                                                                      .toString()) ??
                                                                  0;
                                                          int totalHarga =
                                                              stok *
                                                                  produkSatuan;
                                                          if (cM.selectedProductM
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
                                                          if (stokControllerM
                                                                      .text ==
                                                                  '' ||
                                                              stok == '0') {
                                                            Get.snackbar(
                                                              'Error',
                                                              'Stok Tidak Boleh Kosong, Input Stok Terlebih Dahulu!',
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
                                                          await cM
                                                              .addTransaksiInMitra(
                                                            cM.ProdukMitra
                                                                .toString(),
                                                            stokControllerM
                                                                .text,
                                                            totalHarga
                                                                .toString(),
                                                            '1',
                                                          );
                                                          await cM.addDetTransaksiMitra(
                                                              cM.selectedProductM
                                                                  .value
                                                                  .toString(),
                                                              stokControllerM
                                                                  .text,
                                                              cM.satuanMController
                                                                  .text,
                                                              cM.jualMController
                                                                  .text
                                                                  .toString());
                                                          if (cM.checkboxM
                                                                  .value ==
                                                              true) {
                                                            await cM.editProduk(
                                                              cM.selectedProductM
                                                                  .value
                                                                  .toString(),
                                                              cM.NamaBarang,
                                                              cM.BarcodeBarang,
                                                              cM.GambarBarang,
                                                              cM.KategoriBarang,
                                                              cM.TipeBarang,
                                                              cM.MitraBarang,
                                                              cM.HargaPack,
                                                              cM.JumlahPcs,
                                                              cM.satuanMController
                                                                  .text,
                                                              cM.jualMController
                                                                  .text,
                                                              stokControllerM
                                                                  .text,
                                                            );

                                                            return;
                                                          }
                                                          await cM
                                                              .fetchTransaksiDetMitra();
                                                          stokControllerM
                                                              .clear();
                                                          await cM
                                                              .fetchTransaksiInMitra();
                                                          await cM
                                                              .fetchProduk();
                                                          stokControllerM
                                                              .clear();
                                                          cM.toggleCheckbox(
                                                              false);
                                                          cM.clearSearch();
                                                          cM.selectedProductM
                                                              .value = null;
                                                          cM.toggleCheckbox(
                                                              false);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              PrimaryColor()
                                                                  .blue,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        child: cM.isLoadingM
                                                                .value
                                                            ? SizedBox(
                                                                width: 15,
                                                                height: 15,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white,
                                                                  strokeWidth:
                                                                      2,
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
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text('Tambahkan Stok Mitra Baru'),
                              ),
                            ],
                          ),
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

                  // History section
                  Text(
                    'Riwayat Transaksi Mitra',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Obx(() {
                      if (cM.isLoadingM.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (cM.transaksiDetM.isEmpty) {
                        return Center(child: Text("Tidak ada transaksi"));
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal, // scroll ke samping
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context)
                                .size
                                .width, // pastikan full width
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical, // scroll ke bawah
                            child: Column(
                              children: List.generate(cM.transaksiDetM.length,
                                  (index) {
                                var transaksiMitra = cM.transaksiDetM[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: buildCardTransaksi(
                                      cM.ProdukNameM(
                                          transaksiMitra['id_produk']),
                                      cM.NoTransaksiM(transaksiMitra[
                                          'id_transaksi_in_mitra']),
                                      formatDate(transaksiMitra['input_date']),
                                      transaksiMitra['jumlah'].toString(),
                                      'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(int.parse(transaksiMitra['total_harga']))}',
                                      'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(int.parse(transaksiMitra['harga_satuan']))}',
                                      'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(int.parse(transaksiMitra['harga_jual']))}',
                                      cM.ProdukNameMitra(
                                          transaksiMitra['id_produk']),
                                      context),
                                );
                              }),
                            ),
                          ),
                        ),
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
    String mitra,
    context) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 1.2,
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
                      color: Colors.red.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.handshake,
                      color: Colors.red.shade800,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          name + ' ($mitra)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          noTransaksi,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      total,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      '$jumlah pcs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
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
  required TextEditingController cM,
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
      controller: cM,
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
