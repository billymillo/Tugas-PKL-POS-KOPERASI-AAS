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
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 77,
                  ),
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
                              margin: EdgeInsets.only(right: 15, bottom: 15),
                              padding: EdgeInsets.all(20),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
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
                                          child: CircularProgressIndicator());
                                    }
                                    if (c.kategori.isEmpty) {
                                      return Center(
                                          child: Text("Tidak ada kategori"));
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
                                          c.selectedCategory.value = 'Mitra';
                                          c.kategoriProdukTipe();
                                        }),
                                        SizedBox(height: 15),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.48,
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
                                                    c.selectedCategory.value =
                                                        kategori;
                                                    c.kategoriProduk(kategori);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(c.selectedCategory.value,
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
                                              c.filteredProduk[i]['foto']
                                                  .toString(),
                                              c.filteredProduk[i]['kategori'],
                                              c.filteredProduk[i]['listDibeli'],
                                              () {
                                                c.tambahKeKeranjang(i, null);
                                              },
                                              () {
                                                c.kurangKeKeranjang(i, null);
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
                                            c.filteredProduk[i]['foto']
                                                .toString(),
                                            c.filteredProduk[i]['kategori'],
                                            c.filteredProduk[i]['listDibeli'],
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
                            height: MediaQuery.of(context).size.height * 0.85,
                            margin: EdgeInsets.only(left: 15, bottom: 15),
                            padding: EdgeInsets.all(20),
                            color: Colors.white,
                            child: SingleChildScrollView(
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
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Icon(
                                                FontAwesomeIcons.receipt,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Belum ada pembelian',
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[400],
                                                fontSize: 11),
                                          )
                                        ],
                                      ),
                                    )
                                  else
                                    Obx(() {
                                      Set<String> displayedProducts = {};
                                      List<Widget> billItems = [];
                                      for (var i = 0;
                                          i < c.listProduk.length;
                                          i++) {
                                        if (c.listProduk[i]['listDibeli']
                                                .toString() !=
                                            '[]') {
                                          int jumlahDibeli = c
                                              .listProduk[i]['listDibeli']
                                              .length;
                                          for (var x = 0;
                                              x <
                                                  c.listProduk[i]['listDibeli']
                                                      .length;
                                              x++) {
                                            String productKey =
                                                '${c.listProduk[i]['nama']}-${c.listProduk[i]['listDibeli'][x]['tipe']}';
                                            if (!displayedProducts
                                                .contains(productKey)) {
                                              displayedProducts.add(productKey);
                                              billItems.add(KasirW().bill(
                                                c.listProduk[i]['nama'],
                                                "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.listProduk[i]['listDibeli'][x]['harga'].toString()))}" + "/pcs",
                                                '$jumlahDibeli',
                                                c.listProduk[i]['listDibeli'][x]
                                                    ['tipe'],
                                              ));
                                            }
                                          }
                                        }
                                      }
                                      return Column(
                                        children: billItems,
                                      );
                                    }),
                                  SizedBox(height: 5),
                                  Obx(() => Text(
                                        "Rp. ${NumberFormat('#,##0', 'id_ID').format(double.parse(c.totalHarga.toString()))}",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      )),
                                  Container(
                                    height: 40,
                                    child: Obx(() => c.selectedMember.value ==
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
                                                  Text(
                                                    'Member :',
                                                    style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${c.MemberName}',
                                                    style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
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
                                                    'Poin :',
                                                    style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${c.MemberPoin}',
                                                    style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                  ),
                                  SizedBox(height: 5),
                                  KasirW().buildDropdown(
                                    selectedValue: c.selectedMember,
                                    label: 'Pilih Member',
                                    items: c.member,
                                    onChanged: (newValue) {
                                      c.selectedMember.value = newValue;
                                    },
                                    key: 'nama',
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {},
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Bayar Tunai',
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.bold,
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
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Bayar QRIS',
                                            style: GoogleFonts.nunito(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                color: PrimaryColor().blue),
                                          ),
                                          Icon(
                                            FontAwesomeIcons.qrcode,
                                            size: 14,
                                            color: PrimaryColor().blue,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
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
}
