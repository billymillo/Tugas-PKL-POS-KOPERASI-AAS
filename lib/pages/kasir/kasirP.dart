import 'dart:ffi';

import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/kasir/kasirC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/dividerW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/kasir/kasirW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/notFoundW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class KasirP extends StatefulWidget {
  @override
  _KasirPState createState() => _KasirPState();
}

class _KasirPState extends State<KasirP> {
  final AuthController logoutController = Get.put(AuthController());
  TextEditingController searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setLandscape();
  }

  Future<void> _setLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _normal() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _normal();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    KasirC c = Get.put(KasirC());
    return Scaffold(
        backgroundColor: PrimaryColor().grey,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 77),
              child: RefreshIndicator(
                onRefresh: () async {
                  await c.refreshPage();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 15, bottom: 15),
                                  padding: EdgeInsets.all(20),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          'Kategori',
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Obx(() {
                                        if (c.isLoading.value) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (c.kategori.isEmpty) {
                                          return Center(
                                              child:
                                                  Text("Tidak ada kategori"));
                                        }
                                        return Column(
                                          children: [
                                            KasirW().kategori(
                                                'All',
                                                'https://st2.depositphotos.com/1005573/6741/i/450/depositphotos_67417543-stock-photo-snack-food.jpg',
                                                Icons.all_inbox, (kategori) {
                                              c.selectedCategory.value = 'All';
                                              c.addAllItems();
                                            }),
                                            KasirW().kategori(
                                                'Mitra',
                                                'https://instapay.id/blog/wp-content/uploads/2022/10/mitra-usaha-1.jpeg',
                                                CupertinoIcons.person_2_alt,
                                                (kategori) {
                                              c.selectedCategory.value =
                                                  'Mitra';
                                              c.kategoriProdukTipe();
                                            }),
                                            SizedBox(height: 15),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.45,
                                              child: GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 1,
                                                  childAspectRatio: 2.2,
                                                  crossAxisSpacing: 1,
                                                  mainAxisSpacing: 1,
                                                ),
                                                itemCount: c.kategori.length,
                                                itemBuilder: (context, index) {
                                                  var item = c.kategori[index];
                                                  return Container(
                                                    child: KasirW().kategori(
                                                      item['kategori'],
                                                      "http://10.10.20.240/POS_CI/kategori/${item['gambar_kategori']}",
                                                      Icons.fastfood,
                                                      (kategori) {
                                                        print(
                                                            "Kategori dipilih: $kategori");
                                                        c.selectedCategory
                                                            .value = kategori;
                                                        c.kategoriProduk(
                                                            kategori);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                )),
                            Obx(
                              () {
                                return Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(() => Container(
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                                c.selectedCategory.value,
                                                style: GoogleFonts.nunito(
                                                  color: PrimaryColor().blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
                                          )),
                                      Container(
                                        child: Wrap(
                                          alignment: WrapAlignment.start,
                                          spacing: 10,
                                          runSpacing: 10,
                                          children: [
                                            if (c.filteredProduk.isEmpty)
                                              for (var i = 0;
                                                  i < c.filteredProduk.length;
                                                  i++)
                                                KasirW().product(
                                                  c.filteredProduk[i]['nama']
                                                      .toString(),
                                                  c.filteredProduk[i]['mitra']
                                                      .toString(),
                                                  "${NumberFormat('#,##0', 'id_ID').format(double.parse(c.filteredProduk[i]['harga'].toString()))}",
                                                  "Stok : " +
                                                      c.filteredProduk[i]
                                                          ['jumlah'],
                                                  c.filteredProduk[i]['foto']
                                                      .toString(),
                                                  c.filteredProduk[i]
                                                      ['kategori'],
                                                  c.filteredProduk[i]
                                                      ['listDibeli'],
                                                  () {
                                                    c.tambahKeKeranjang(
                                                        i, null);
                                                  },
                                                  () {
                                                    c.kurangKeKeranjang(
                                                        i, null);
                                                  },
                                                  context,
                                                ),
                                            for (var i = 0;
                                                i < c.filteredProduk.length;
                                                i++)
                                              KasirW().product(
                                                c.filteredProduk[i]['nama']
                                                    .toString(),
                                                c.filteredProduk[i]['mitra']
                                                    .toString(),
                                                "${NumberFormat('#,##0', 'id_ID').format(double.parse(c.filteredProduk[i]['harga'].toString()))}",
                                                "Stok : " +
                                                    c.filteredProduk[i]
                                                        ['jumlah'],
                                                c.filteredProduk[i]['foto']
                                                    .toString(),
                                                c.filteredProduk[i]['kategori'],
                                                c.filteredProduk[i]
                                                    ['listDibeli'],
                                                () {
                                                  c.tambahKeKeranjang(i, null);
                                                },
                                                () {
                                                  c.kurangKeKeranjang(i, null);
                                                },
                                                context,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Obx(
                              () => Expanded(
                                  child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                margin: EdgeInsets.only(left: 15, bottom: 15),
                                padding: EdgeInsets.all(20),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bill',
                                      style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    DividerW().ColumnSpaceDivider(),
                                    if (c.banyakDibeli.value == 0)
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        width: double.infinity,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 50),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.receipt,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Belum ada pembelian',
                                              style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[400],
                                                fontSize: 11,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    else
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.4,
                                        child: Expanded(
                                          child: Obx(() {
                                            Set<String> displayedProducts = {};
                                            List<Widget> billItems = [];
                                            for (var i = 0;
                                                i < c.listProduk.length;
                                                i++) {
                                              if (c.listProduk[i]['listDibeli']
                                                  .isNotEmpty) {
                                                int jumlahDibeli = c
                                                    .listProduk[i]['listDibeli']
                                                    .length;
                                                for (var x = 0;
                                                    x <
                                                        c
                                                            .listProduk[i]
                                                                ['listDibeli']
                                                            .length;
                                                    x++) {
                                                  String productKey =
                                                      '${c.listProduk[i]['nama']}-${c.listProduk[i]['listDibeli'][x]['tipe']}';
                                                  if (!displayedProducts
                                                      .contains(productKey)) {
                                                    displayedProducts
                                                        .add(productKey);
                                                    billItems.add(
                                                      KasirW().bill(
                                                        c.listProduk[i]['nama'],
                                                        "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.listProduk[i]['listDibeli'][x]['harga'].toString()))}/pcs",
                                                        '$jumlahDibeli',
                                                        c.listProduk[i]
                                                                ['listDibeli']
                                                            [x]['tipe'],
                                                      ),
                                                    );
                                                  }
                                                }
                                              }
                                            }
                                            return ListView.builder(
                                              itemCount: billItems.length,
                                              itemBuilder: (context, index) {
                                                return billItems[index];
                                              },
                                            );
                                          }),
                                        ),
                                      ),
                                    SizedBox(height: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(() => Text(
                                              "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.totalHarga.toString()))}",
                                              style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            )),
                                        Container(
                                          child: Obx(() => c
                                                      .selectedMember.value ==
                                                  null
                                              ? Text(
                                                  '',
                                                  style: GoogleFonts.nunito(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                  ),
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                c.selectedMember
                                                                        .value =
                                                                    null;
                                                              },
                                                              child: Icon(
                                                                  FontAwesomeIcons
                                                                      .xmark,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 15),
                                                            ),
                                                            SizedBox(width: 3),
                                                            Text(
                                                              'Member :',
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          '${c.MemberName}',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Poin Saat Ini :',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          c.checkbox.value
                                                              ? '0 Poin'
                                                              : '${c.MemberPoin} Poin',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '',
                                                        ),
                                                        Text(
                                                          '+ ${c.poinDapat}',
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 12,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'Gunakan Poin ?',
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            Transform.scale(
                                                              scale: 0.7,
                                                              child: Checkbox(
                                                                activeColor:
                                                                    PrimaryColor()
                                                                        .blue,
                                                                value: c
                                                                    .checkbox
                                                                    .value,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  setState(() {
                                                                    c.checkbox
                                                                            .value =
                                                                        value ??
                                                                            false; // Update checkbox status
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          c.checkbox.value
                                                              ? "- Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.MemberPoin.toString()))}"
                                                              : "",
                                                          style: GoogleFonts
                                                              .nunito(
                                                            fontSize: 10,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                        ),
                                        SizedBox(height: 5),
                                        GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: PrimaryColor().blue),
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 11, horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Member',
                                                  style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                      color:
                                                          PrimaryColor().blue),
                                                ),
                                                Icon(
                                                  CupertinoIcons.person_2_alt,
                                                  size: 14,
                                                  color: PrimaryColor().blue,
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: SingleChildScrollView(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            controller: c
                                                                .searchController,
                                                            onChanged: (value) =>
                                                                c.searchMember(
                                                                    value,
                                                                    c.member),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13),
                                                            cursorColor:
                                                                Colors.black12,
                                                            decoration:
                                                                InputDecoration(
                                                              prefixIcon: Icon(
                                                                FontAwesomeIcons
                                                                    .magnifyingGlass,
                                                                size: 15,
                                                                color:
                                                                    DarkColor()
                                                                        .grey,
                                                              ),
                                                              suffixIcon: Obx(() => c
                                                                      .searchQuery
                                                                      .value
                                                                      .isNotEmpty
                                                                  ? IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .close,
                                                                          color:
                                                                              Colors.grey),
                                                                      onPressed:
                                                                          () {
                                                                        c.clearSearch();
                                                                      },
                                                                    )
                                                                  : SizedBox()),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5,
                                                                      horizontal:
                                                                          20),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color: ShadowColor()
                                                                        .blue),
                                                              ),
                                                              disabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color:
                                                                        ShadowColor()
                                                                            .blue,
                                                                    width: 0.2),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10.0)),
                                                                borderSide: BorderSide(
                                                                    color:
                                                                        ShadowColor()
                                                                            .blue,
                                                                    width: 0.2),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color:
                                                                        PrimaryColor()
                                                                            .blue,
                                                                    width: 0.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              fillColor:
                                                                  PrimaryColor()
                                                                      .grey,
                                                              filled: true,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Obx(() {
                                                            if (c.isLoading
                                                                .value) {
                                                              return Center(
                                                                  child:
                                                                      CircularProgressIndicator());
                                                            }
                                                            if (c
                                                                .filteredMembers
                                                                .isEmpty) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                child: Text(
                                                                    "Tidak ada member ditemukan"),
                                                              );
                                                            }
                                                            return Container(
                                                              height:
                                                                  300, // Batas tinggi list agar tidak terlalu panjang
                                                              child: ListView
                                                                  .builder(
                                                                itemCount: c
                                                                    .filteredMembers
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  final member =
                                                                      c.filteredMembers[
                                                                          index];
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                12,
                                                                            horizontal:
                                                                                16),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(8),
                                                                          side:
                                                                              BorderSide(color: Colors.blueAccent),
                                                                        ),
                                                                        elevation:
                                                                            1, // Efek bayangan
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        c.selectedMember
                                                                            .value = member[
                                                                                'id']
                                                                            .toString();
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            member['nama'],
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          Text(
                                                                            "${member['no_tlp']}",
                                                                            style:
                                                                                TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                                              },
                                            );
                                          },
                                        ),
                                        SizedBox(height: 5),
                                        GestureDetector(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: PrimaryColor().blue),
                                                color: PrimaryColor().blue,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 11, horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Tunai',
                                                  style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11,
                                                      color: Colors.white),
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
                                            c.fetchStatus();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.white,
                                                    ),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.34,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20)),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height: 20),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              30),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            174,
                                                                            255,
                                                                            163),
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .moneyBill1,
                                                                      color: Colors
                                                                          .green,
                                                                      size: 60,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 15),
                                                                Text(
                                                                  'Status Transaksi',
                                                                  style: GoogleFonts.nunito(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize:
                                                                          27,
                                                                      color: Colors
                                                                          .green
                                                                          .shade700),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Pilih status pembayaran untuk menyelesaikan transaksi dengan total harga ' +
                                                                      "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.totalHarga.toString()))}",
                                                                  style: GoogleFonts.nunito(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                    height: 5),
                                                                Text(
                                                                  'Member : ' +
                                                                      c.MemberName,
                                                                  style: GoogleFonts.nunito(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600),
                                                                ),
                                                                SizedBox(
                                                                    height: 20),
                                                                Obx(() {
                                                                  return Column(
                                                                    children: c
                                                                        .status
                                                                        .map(
                                                                            (status) {
                                                                      Color buttonColor = (status['status'] ==
                                                                              "Lunas")
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red;
                                                                      return ListTile(
                                                                        title:
                                                                            Button(
                                                                          status[
                                                                              'status'],
                                                                          buttonColor,
                                                                          () async {
                                                                            if (c.banyakDibeli == 0 ||
                                                                                c.banyakDibeli == '') {
                                                                              Get.snackbar(
                                                                                'Error',
                                                                                'Produk Tidak Boleh Kosong!',
                                                                                backgroundColor: Colors.red.withOpacity(0.8),
                                                                                colorText: Colors.white,
                                                                                icon: Icon(Icons.error, color: Colors.white),
                                                                              );
                                                                              return;
                                                                            }
                                                                            c.metodePembayaran.value =
                                                                                1;
                                                                            try {
                                                                              await c.addTransaksiOut(
                                                                                c.selectedMember.string,
                                                                                c.banyakDibeli.toString(),
                                                                                c.metodePembayaran.string,
                                                                                c.totalHarga.toString(),
                                                                                c.calculateDiskon.toString(),
                                                                                status['id'],
                                                                                c.calculateDiskon.toString(),
                                                                                c.poinUpdate.toString(),
                                                                                fromButton: true,
                                                                              );

                                                                              if (status['status'] == "Tidak Lunas") {
                                                                                await c.kasbonMember(c.selectedMember.string, c.totalHarga.toString(), status['id']);
                                                                              }
                                                                              await c.tambahPoin(c.selectedMember.string, c.poinUpdate.toString());

                                                                              c.selectedMember.value = null;
                                                                              c.banyakDibeli.value = 0;
                                                                            } catch (e) {
                                                                              Get.snackbar(
                                                                                'Error',
                                                                                'Terjadi Kesalahan',
                                                                                backgroundColor: Colors.red.withOpacity(0.8),
                                                                                colorText: Colors.white,
                                                                                icon: Icon(Icons.error, color: Colors.white),
                                                                              );
                                                                            }
                                                                            await c.fetchProduk();
                                                                            await c.fetchMember();

                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  );
                                                                })
                                                              ],
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        SizedBox(height: 5),
                                        KasirW().tombolQris(
                                          context,
                                          "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.totalHarga.toString()))}",
                                          () async {
                                            if (c.banyakDibeli == 0 ||
                                                c.banyakDibeli == '') {
                                              Get.snackbar(
                                                'Error',
                                                'Produk Tidak Boleh Kosong!',
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.8),
                                                colorText: Colors.white,
                                                icon: Icon(Icons.error,
                                                    color: Colors.white),
                                              );
                                              return;
                                            }
                                            c.metodePembayaran.value = 2;
                                            c.statusTr.value = 1;
                                            try {
                                              await c.addTransaksiOut(
                                                c.selectedMember.string,
                                                c.banyakDibeli.toString(),
                                                c.metodePembayaran.string,
                                                c.totalHarga.toString(),
                                                c.calculateDiskon.toString(),
                                                c.statusTr.toString(),
                                                c.calculateDiskon.toString(),
                                                c.poinUpdate.toString(),
                                                fromButton: true,
                                              );
                                              await c.tambahPoin(
                                                  c.selectedMember.string,
                                                  c.poinUpdate.toString());
                                              c.selectedMember.value = null;
                                              c.banyakDibeli.value = 0;
                                            } catch (e) {
                                              Get.snackbar(
                                                'Error',
                                                'Terjadi Kesalahan',
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.8),
                                                colorText: Colors.white,
                                                icon: Icon(Icons.error,
                                                    color: Colors.white),
                                              );
                                            }
                                            await c.fetchProduk();
                                            Navigator.pop(context);
                                          },
                                          () async {
                                            if (c.banyakDibeli == 0 ||
                                                c.banyakDibeli == '') {
                                              Get.snackbar(
                                                'Error',
                                                'Produk Tidak Boleh Kosong!',
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.8),
                                                colorText: Colors.white,
                                                icon: Icon(Icons.error,
                                                    color: Colors.white),
                                              );
                                              return;
                                            }
                                            c.metodePembayaran.value = 2;
                                            c.statusTr.value = 2;
                                            try {
                                              await c.addTransaksiOut(
                                                c.selectedMember.string,
                                                c.banyakDibeli.toString(),
                                                c.metodePembayaran.string,
                                                c.totalHarga.toString(),
                                                c.calculateDiskon.toString(),
                                                c.statusTr.toString(),
                                                c.calculateDiskon.toString(),
                                                c.poinUpdate.toString(),
                                                fromButton: true,
                                              );
                                              await c.tambahPoin(
                                                  c.selectedMember.string,
                                                  c.poinUpdate.toString());
                                              c.selectedMember.value = null;
                                              c.banyakDibeli.value = 0;
                                            } catch (e) {
                                              Get.snackbar(
                                                'Error',
                                                'Terjadi Kesalahan',
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.8),
                                                colorText: Colors.white,
                                                icon: Icon(Icons.error,
                                                    color: Colors.white),
                                              );
                                            }
                                            await c.fetchProduk();
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 17),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                        child: Row(
                      children: [
                        Image.asset(
                          "assets/image/aas_logo.png",
                          width: 50,
                        ),
                      ],
                    )),
                    flex: 1,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      onChanged: (value) {
                        c.searchProduk(value);
                      },
                      style: const TextStyle(fontSize: 13),
                      cursorColor: Colors.black12,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 15,
                          color: DarkColor().grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: ShadowColor().blue),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: ShadowColor().blue, width: 0.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: ShadowColor().blue, width: 0.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: PrimaryColor().blue, width: 0.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: PrimaryColor().grey,
                        filled: true,
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        KasirW().logout(context),
                        SizedBox(width: 30),
                        Icon(
                          FontAwesomeIcons.circleDollarToSlot,
                          color: PrimaryColor().blue,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.dialog(
                              AlertDialog(
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                      Text('This is a dialog'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            FontAwesomeIcons.receipt,
                            color: PrimaryColor().blue,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Icon(
                          FontAwesomeIcons.gear,
                          color: PrimaryColor().blue,
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget Button(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
