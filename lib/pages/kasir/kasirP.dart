import 'dart:ffi';

import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/kasir/kasirC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
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
  TextEditingController saldoController = TextEditingController();

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
                                                      "http://10.10.20.50/POS_CI/kategori/${item['gambar_kategori']}",
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
                                                  c.filteredProduk[i]['addOn'],
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
                                                  i,
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
                                                c.filteredProduk[i]['addOn'],
                                                c.filteredProduk[i]
                                                    ['listDibeli'],
                                                () {
                                                  c.tambahKeKeranjang(i, null);
                                                },
                                                () {
                                                  c.kurangKeKeranjang(i, null);
                                                },
                                                context,
                                                i,
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
                                    MediaQuery.of(context).size.height * 1.1,
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
                                                0.25,
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
                                        child: Obx(() {
                                          Set<String> displayedProducts = {};
                                          List<Widget> billItems = [];
                                          for (var i = 0;
                                              i < c.listProduk.length;
                                              i++) {
                                            if (c.listProduk[i]['listDibeli']
                                                .isNotEmpty) {
                                              for (var x = 0;
                                                  x <
                                                      c
                                                          .listProduk[i]
                                                              ['listDibeli']
                                                          .length;
                                                  x++) {
                                                List<String> addOnList =
                                                    List<String>.from(c
                                                                    .listProduk[
                                                                i]['listDibeli']
                                                            [x]['addOn'] ??
                                                        []);
                                                addOnList.sort();
                                                String addOnKey =
                                                    addOnList.join(',');
                                                String productKey =
                                                    '${c.listProduk[i]['nama']} - ${c.listProduk[i]['listDibeli'][x]['tipe']} - $addOnKey';
                                                if (!displayedProducts
                                                    .contains(productKey)) {
                                                  displayedProducts
                                                      .add(productKey);
                                                  int jumlahDibeli = c
                                                      .listProduk[i]
                                                          ['listDibeli']
                                                      .where((e) {
                                                    List<String> addOnCompare =
                                                        List<String>.from(
                                                            e['addOn'] ?? []);
                                                    addOnCompare.sort();
                                                    return addOnCompare
                                                                .join(',') ==
                                                            addOnKey &&
                                                        e['tipe'] ==
                                                            c.listProduk[i][
                                                                    'listDibeli']
                                                                [x]['tipe'];
                                                  }).length;

                                                  billItems.add(
                                                    KasirW().bill(
                                                        c.listProduk[i]['nama'],
                                                        "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.listProduk[i]['listDibeli'][x]['harga'].toString()))}/pcs",
                                                        c.listProduk[i]
                                                                ['listDibeli']
                                                            [x]['addOn'],
                                                        '$jumlahDibeli',
                                                        c.listProduk[i]
                                                                ['listDibeli']
                                                            [x]['tipe'], () {
                                                      c.hapusKeranjang(
                                                        nama: c.listProduk[i]
                                                            ['nama'],
                                                        addOn: List<
                                                            String>.from(c
                                                                    .listProduk[
                                                                i]['listDibeli']
                                                            [x]['addOn']),
                                                      );
                                                    }),
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
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${c.MemberName}',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                              child: SizedBox(
                                                                height: 15,
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
                                                                    setState(
                                                                        () {
                                                                      c.checkbox
                                                                              .value =
                                                                          value ??
                                                                              false;
                                                                    });
                                                                  },
                                                                ),
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
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Gunakan Saldo ?',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                        Transform.scale(
                                                          scale: 0.7,
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
                                                                .checkboxSaldo
                                                                .value,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                c.checkboxSaldo
                                                                        .value =
                                                                    value ??
                                                                        false;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Obx(() {
                                                      return c.checkboxSaldo
                                                              .value
                                                          ? Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        c.saldoController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    style: GoogleFonts.nunito(
                                                                        fontSize:
                                                                            12),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          "Gunakan Saldo",
                                                                      labelStyle:
                                                                          TextStyle(
                                                                              fontSize: 12),
                                                                      isDense:
                                                                          true,
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10,
                                                                          horizontal:
                                                                              12),
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                ElevatedButton(
                                                                  onPressed: () =>
                                                                      c.simpanSaldo(),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16,
                                                                        vertical:
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    "Simpan",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox();
                                                    }),
                                                    const SizedBox(height: 5),
                                                    Obx(() =>
                                                        c.checkboxSaldo.value
                                                            ? Text(
                                                                "Saldo Member: Rp. ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(c.MemberSaldo) ?? 0)}",
                                                                style:
                                                                    GoogleFonts
                                                                        .nunito(
                                                                  fontSize: 12,
                                                                  color:
                                                                      PrimaryColor()
                                                                          .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            : SizedBox()),
                                                  ],
                                                )),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [],
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
                                        KasirW().tombolTunai(
                                            context,
                                            c.isLoading,
                                            c.totalHarga.toInt().toString(),
                                            c.MemberName,
                                            saldoController, () async {
                                          double totalHarga =
                                              c.totalHarga.toDouble();
                                          double inputHarga = double.tryParse(
                                                  saldoController.text) ??
                                              0.0;

                                          if (inputHarga >= totalHarga) {
                                            c.statusId.value = 1;
                                          } else {
                                            c.statusId.value = 2;
                                          }

                                          if (c.statusId.value == 2 &&
                                              c.banyakDibeli != 0 &&
                                              c.selectedMember.value == null) {
                                            Get.snackbar(
                                              'Error',
                                              'Non Member tidak bisa melakukan Kasbon',
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.8),
                                              colorText: Colors.white,
                                              icon: Icon(Icons.error,
                                                  color: Colors.white),
                                            );
                                            return;
                                          }
                                          c.metodePembayaran.value = 1;
                                          try {
                                            await c.addTransaksiOut(
                                              c.selectedMember.string,
                                              c.banyakDibeli.toString(),
                                              c.metodePembayaran.string,
                                              inputHarga.toString(),
                                              c.calculateDiskon.toString(),
                                              c.statusId.string,
                                              c.calculateDiskon.toString(),
                                              c.poinUpdate.toString(),
                                              fromButton: true,
                                            );
                                            c.kategoriProduk('');

                                            final produkDenganPembelian =
                                                c.filteredProduk.where((p) =>
                                                    p['listDibeli'] != null &&
                                                    p['listDibeli'].isNotEmpty);
                                            for (var produk
                                                in produkDenganPembelian) {
                                              await c.addAllDetailTransaksiOut(
                                                  produk['listDibeli']);
                                            }

                                            if (c.checkboxSaldo.value == true) {
                                              int saldoInput = int.tryParse(c
                                                      .saldoInput
                                                      .toString()) ??
                                                  0;
                                              int saldoMember =
                                                  int.tryParse(c.MemberSaldo) ??
                                                      0;
                                              int kurangSaldo =
                                                  saldoMember - saldoInput;
                                              await c.kurangSaldo(
                                                  c.selectedMember.string,
                                                  kurangSaldo.toString());
                                            }
                                            await c.tambahPoin(
                                                c.selectedMember.string,
                                                c.poinUpdate.toString());

                                            if (c.statusId.value == 2 &&
                                                c.selectedMember.value !=
                                                    null) {
                                              double totalKasbon =
                                                  c.totalHarga - inputHarga;
                                              await c.kasbonMember(
                                                c.selectedMember.string,
                                                totalKasbon.toInt().toString(),
                                                c.statusId.string,
                                              );
                                            }
                                            c.fetchTransaksiStruk();
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
                                          Future.delayed(
                                            Duration(milliseconds: 200),
                                            () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child:
                                                        SingleChildScrollView(
                                                      // Tambahkan scroll
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(20),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20)),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            30),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          163,
                                                                          218,
                                                                          255),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    child: Icon(
                                                                      FontAwesomeIcons
                                                                          .receipt,
                                                                      color: Colors
                                                                          .blue,
                                                                      size: 60,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          15),
                                                                  Text(
                                                                    'Cetak Struk',
                                                                    style: GoogleFonts.nunito(
                                                                        fontWeight: FontWeight.w800,
                                                                        fontSize: 22, // Lebih responsif
                                                                        color: Colors.blue),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right: 20,
                                                                      bottom:
                                                                          20),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Transaksi Anda telah berhasil !. Apakah Anda ingin mencetak struk sebagai bukti transaksi Anda?',
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
                                                                      height:
                                                                          20),
                                                                  Container(
                                                                    width: 300,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        bool
                                                                            connected =
                                                                            await c.checkPrinterStatus();

                                                                        if (connected) {
                                                                          await c.printReceipt(
                                                                              "Hello World",
                                                                              "Tunai");
                                                                          await c
                                                                              .disconnectPrinter();
                                                                        } else {
                                                                          print(
                                                                              "Printer belum terhubung, mencari perangkat...");
                                                                          await c
                                                                              .scanForDevices();

                                                                          connected =
                                                                              await c.checkPrinterStatus();
                                                                          if (connected) {
                                                                            await c.printReceipt("Hello World",
                                                                                "Tunai");
                                                                            await c.disconnectPrinter();
                                                                          } else {
                                                                            print("Printer tidak ditemukan atau gagal terhubung.");
                                                                          }
                                                                          if (c.statusId.value == 2 &&
                                                                              c.selectedMember.value != null) {
                                                                            await c.detKasbon(c.idTransaksiOut.toString());
                                                                          }
                                                                          await c
                                                                              .fetchProduk();
                                                                          await c
                                                                              .fetchMember();
                                                                          c.selectedMember.value =
                                                                              null;
                                                                          c.banyakDibeli.value =
                                                                              0;
                                                                          setState(
                                                                              () {
                                                                            c.checkboxSaldo.value =
                                                                                false;
                                                                          });
                                                                          c.saldoInput.value =
                                                                              0;
                                                                          setState(
                                                                              () {
                                                                            c.checkbox.value =
                                                                                false;
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            PrimaryColor().blue,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'Cetak Struk',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          5),
                                                                  Container(
                                                                    width: 300,
                                                                    child:
                                                                        ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (c.statusId.value ==
                                                                                2 &&
                                                                            c.selectedMember.value !=
                                                                                null) {
                                                                          await c.detKasbon(c
                                                                              .idTransaksiOut
                                                                              .toString());
                                                                        }
                                                                        await c
                                                                            .fetchProduk();
                                                                        await c
                                                                            .fetchMember();
                                                                        c.selectedMember.value =
                                                                            null;
                                                                        c.banyakDibeli
                                                                            .value = 0;
                                                                        setState(
                                                                            () {
                                                                          c.checkboxSaldo.value =
                                                                              false;
                                                                        });
                                                                        c.saldoInput
                                                                            .value = 0;
                                                                        setState(
                                                                            () {
                                                                          c.checkbox.value =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            PrimaryColor().grey,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'Tidak',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
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
                                        }),
                                        SizedBox(height: 5),
                                        KasirW().tombolQris(
                                          context,
                                          c.isLoading,
                                          "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.totalHarga.toString()))}",
                                          "00020101021126660014ID.LINKAJA.WWW011893600911000000000802152103124400000080303UMI51440014ID.CO.QRIS.WWW0215ID20210652077750303UMI5204839853033605802ID5922YAY BAKTI KAMAJAYA IND6006SLEMAN61055528162070703A016304FA4D",
                                          () async {
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

                                              c.kategoriProduk('');

                                              final produkDenganPembelian =
                                                  c.filteredProduk.where((p) =>
                                                      p['listDibeli'] != null &&
                                                      p['listDibeli']
                                                          .isNotEmpty);

                                              for (var produk
                                                  in produkDenganPembelian) {
                                                await c
                                                    .addAllDetailTransaksiOut(
                                                        produk['listDibeli']);
                                              }

                                              if (c.checkboxSaldo.value ==
                                                  true) {
                                                int saldoInput = int.tryParse(c
                                                        .saldoInput
                                                        .toString()) ??
                                                    0;
                                                int saldoMember = int.tryParse(
                                                        c.MemberSaldo) ??
                                                    0;
                                                int kurangSaldo =
                                                    saldoMember - saldoInput;
                                                await c.kurangSaldo(
                                                    c.selectedMember.string,
                                                    kurangSaldo.toString());
                                                ;
                                              }
                                              await c.tambahPoin(
                                                  c.selectedMember.string,
                                                  c.poinUpdate.toString());
                                              c.fetchTransaksiStruk();
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
                                            Future.delayed(
                                              Duration(milliseconds: 200),
                                              () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child:
                                                          SingleChildScrollView(
                                                        // Tambahkan scroll
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.white,
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20)),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              30),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            163,
                                                                            218,
                                                                            255),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        FontAwesomeIcons
                                                                            .receipt,
                                                                        color: Colors
                                                                            .blue,
                                                                        size:
                                                                            60,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            15),
                                                                    Text(
                                                                      'Cetak Struk',
                                                                      style: GoogleFonts.nunito(
                                                                          fontWeight: FontWeight.w800,
                                                                          fontSize: 22, // Lebih responsif
                                                                          color: Colors.blue),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            20),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Transaksi Anda telah berhasil !. Apakah Anda ingin mencetak struk sebagai bukti transaksi Anda?',
                                                                      style: GoogleFonts.nunito(
                                                                          fontWeight: FontWeight
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
                                                                        height:
                                                                            20),
                                                                    Container(
                                                                      width:
                                                                          300,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          bool
                                                                              connected =
                                                                              await c.checkPrinterStatus();

                                                                          if (connected) {
                                                                            await c.printReceipt("Hello World",
                                                                                "Qris");
                                                                            await c.disconnectPrinter();
                                                                          } else {
                                                                            print("Printer belum terhubung, mencari perangkat...");
                                                                            await c.scanForDevices();

                                                                            connected =
                                                                                await c.checkPrinterStatus();
                                                                            if (connected) {
                                                                              await c.printReceipt("Hello World", "Qris");
                                                                              await c.disconnectPrinter();
                                                                            } else {
                                                                              print("Printer tidak ditemukan atau gagal terhubung.");
                                                                            }
                                                                            await c.fetchProduk();
                                                                            await c.fetchMember();
                                                                            c.selectedMember.value =
                                                                                null;
                                                                            c.banyakDibeli.value =
                                                                                0;
                                                                            setState(() {
                                                                              c.checkboxSaldo.value = false;
                                                                            });
                                                                            c.saldoInput.value =
                                                                                0;
                                                                            setState(() {
                                                                              c.checkbox.value = false;
                                                                            });
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              PrimaryColor().blue,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              'Cetak Struk',
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
                                                                    SizedBox(
                                                                        height:
                                                                            5),
                                                                    Container(
                                                                      width:
                                                                          300,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await c
                                                                              .fetchProduk();
                                                                          await c
                                                                              .fetchMember();
                                                                          c.selectedMember.value =
                                                                              null;
                                                                          c.banyakDibeli.value =
                                                                              0;
                                                                          setState(
                                                                              () {
                                                                            c.checkboxSaldo.value =
                                                                                false;
                                                                          });
                                                                          c.saldoInput.value =
                                                                              0;
                                                                          setState(
                                                                              () {
                                                                            c.checkbox.value =
                                                                                false;
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              PrimaryColor().grey,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(width: 8),
                                                                            Text(
                                                                              'Tidak',
                                                                              style: TextStyle(
                                                                                color: Colors.black,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )
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
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.TRANSAKSIP);
                          },
                          child: Icon(
                            FontAwesomeIcons.circleDollarToSlot,
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
