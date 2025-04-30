import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/AddPageC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/reportingC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class ReportingP extends StatelessWidget {
  ReportingP({super.key});
  final AuthController logoutController = Get.put(AuthController());
  final ReportingController controller = Get.put(ReportingController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 40),
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => Text(
                                    controller.dateLabel.value,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  )),
                              Obx(() => DropdownButton<String>(
                                    value: [
                                      'Perhari',
                                      'Kustom Tanggal',
                                    ].contains(controller.selectedValue.value)
                                        ? controller.selectedValue.value
                                        : null,
                                    hint: Text('Waktu Reporting'),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                    onChanged: (String? newValue) {
                                      controller.selectedValue.value =
                                          newValue ?? '';
                                      pickDate(
                                          context); // Panggil fungsi untuk pilih tanggal
                                    },
                                    items: ['Perhari', 'Kustom Tanggal']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  )),
                            ],
                          ),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                controller.selectedIndexes.value = [
                                  false,
                                  false,
                                  false,
                                  false
                                ];
                                controller.isFiltered.value = true;
                                controller.filterData();
                                controller.filterTransaksiOutDet();
                                controller.filterTransaksiInDet();
                              },
                              icon: Icon(Icons.search, color: Colors.white),
                              label: Text('Filter',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: PrimaryColor().blue,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: ShadowColor().aqua,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Laporan Penjualan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        SizedBox(height: 5),
                        Divider(
                          thickness: 2,
                          color: PrimaryColor().blue,
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                CardReport(
                                  'Produk Terjual',
                                  '${controller.totalProduk} Item',
                                  Icons.currency_exchange_outlined,
                                  isSelected: controller.selectedIndexes[0],
                                  onTap: () {
                                    if (!controller.isFiltered.value) {
                                      Get.snackbar(
                                        'Gagal',
                                        'Silahkan pilih tanggal terlebih dahulu',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.8),
                                        colorText: Colors.white,
                                        icon: Icon(Icons.error,
                                            color: Colors.white),
                                      );
                                      return;
                                    }
                                    controller.toggleCard(0);
                                  },
                                ),
                                SizedBox(width: 15),
                                CardReport(
                                  'Total Transaksi',
                                  '${controller.totalTransaksi} Transaksi',
                                  Icons.currency_exchange_outlined,
                                  isSelected: controller.selectedIndexes[1],
                                  onTap: () {
                                    if (!controller.isFiltered.value) {
                                      Get.snackbar(
                                        'Gagal',
                                        'Silahkan pilih tanggal terlebih dahulu',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.8),
                                        colorText: Colors.white,
                                        icon: Icon(Icons.error,
                                            color: Colors.white),
                                      );
                                      return;
                                    }
                                    controller.toggleCard(1);
                                  },
                                ),
                                SizedBox(width: 15),
                                CardReport(
                                  'Pendapatan',
                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(controller.pendapatan.toString()) ?? 0)}',
                                  Icons.currency_exchange_outlined,
                                  isSelected: controller.selectedIndexes[2],
                                  onTap: () {
                                    if (!controller.isFiltered.value) {
                                      Get.snackbar(
                                        'Gagal',
                                        'Silahkan pilih tanggal terlebih dahulu',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.8),
                                        colorText: Colors.white,
                                        icon: Icon(Icons.error,
                                            color: Colors.white),
                                      );
                                      return;
                                    }
                                    controller.toggleCard(2);
                                  },
                                ),
                                SizedBox(width: 15),
                                CardReport(
                                  'Pengeluaran',
                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(controller.pengeluaran.toString()) ?? 0)}',
                                  Icons.currency_exchange_outlined,
                                  isSelected: controller.selectedIndexes[3],
                                  onTap: () {
                                    if (!controller.isFiltered.value) {
                                      Get.snackbar(
                                        'Gagal',
                                        'Silahkan pilih tanggal terlebih dahulu',
                                        backgroundColor:
                                            Colors.red.withOpacity(0.8),
                                        colorText: Colors.white,
                                        icon: Icon(Icons.error,
                                            color: Colors.white),
                                      );
                                      return;
                                    }
                                    controller.toggleCard(3);
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            color: ShadowColor().aqua,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Obx(() {
                                final selected = controller.selectedIndexes;
                                final List<Widget> chartWidgets = [];
                                if (selected[0]) {
                                  chartWidgets.add(buildChart(
                                    text: 'Data Produk Terjual',
                                    spots: controller.produkChartSpots,
                                    labels: controller.produkChartLabels,
                                    color: DarkColor().red,
                                    context: context,
                                    interval: 10,
                                  ));
                                }

                                if (selected[1]) {
                                  chartWidgets.add(buildChart(
                                    text: 'Data Transaksi',
                                    spots: controller.transaksiChartSpots,
                                    labels: controller.transaksiChartLabels,
                                    color: PrimaryColor().blue,
                                    context: context,
                                    interval: 5,
                                  ));
                                }

                                if (selected[2]) {
                                  chartWidgets.add(buildChart(
                                    text: 'Data Pendapatan',
                                    spots: controller.pendapatanChartSpots,
                                    labels: controller.pendapatanChartLabels,
                                    color: PrimaryColor().green,
                                    context: context,
                                    interval: 50000,
                                  ));
                                }

                                if (selected[3]) {
                                  chartWidgets.add(buildChart(
                                    text: 'Data Pendapatan',
                                    spots: controller.pengeluaranChartSpots,
                                    labels: controller.pengeluaranChartLabels,
                                    color: DarkColor().yellow,
                                    context: context,
                                    interval: 10000,
                                  ));
                                }

                                if (chartWidgets.isEmpty) {
                                  return Center(child: Text(" "));
                                }

                                return Column(
                                  children: chartWidgets,
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: ShadowColor().aqua,
                            width: MediaQuery.of(context).size.width * 1,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Obx(() {
                                final data = controller.transaksiOutDet;
                                if (data.isEmpty) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                }

                                final Map<String, List<Map<String, dynamic>>>
                                    groupedData = {};
                                for (var item in data) {
                                  final String date =
                                      item['input_date'].substring(0, 10);

                                  if (groupedData.containsKey(date)) {
                                    groupedData[date]!.add(item);
                                  } else {
                                    groupedData[date] = [item];
                                  }
                                }

                                return Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: DataTable(
                                    columnSpacing: 24,
                                    horizontalMargin: 16,
                                    dividerThickness: 1,
                                    headingRowColor: MaterialStateProperty.all(
                                      Color(0xFFEEF2F7),
                                    ),
                                    headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFF374151),
                                    ),
                                    dataTextStyle: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF111827),
                                    ),
                                    columns: const [
                                      DataColumn(label: Text('Tanggal')),
                                      DataColumn(label: Text('Jumlah Produk')),
                                      DataColumn(
                                          label: Text('Total Harga Dasar')),
                                      DataColumn(label: Text('Total Harga')),
                                      DataColumn(label: Text('Keuntungan')),
                                    ],
                                    rows: groupedData.entries.map((entry) {
                                      final date = entry.key;
                                      final items = entry.value;

                                      int totalJumlah = items.fold(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (int.tryParse(item['jumlah']
                                                      .toString()) ??
                                                  0));
                                      int totalHargaDasar = items.fold(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (int.tryParse(
                                                      item['total_harga_dasar']
                                                          .toString()) ??
                                                  0));
                                      int totalHarga = items.fold(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (int.tryParse(item['total_harga']
                                                      .toString()) ??
                                                  0));
                                      int totalLaba = items.fold(
                                          0,
                                          (sum, item) =>
                                              sum +
                                              (int.tryParse(item['laba']
                                                      .toString()) ??
                                                  0));

                                      return DataRow(
                                        color: MaterialStateProperty.all(
                                          Colors.white,
                                        ),
                                        cells: [
                                          DataCell(Text(date)),
                                          DataCell(Text('$totalJumlah Pcs')),
                                          DataCell(Text(
                                              'Rp ${NumberFormat('#,##0', 'id_ID').format(totalHargaDasar)}')),
                                          DataCell(Text(
                                              'Rp ${NumberFormat('#,##0', 'id_ID').format(totalHarga)}')),
                                          DataCell(Text(
                                              'Rp ${NumberFormat('#,##0', 'id_ID').format(totalLaba)}')),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Obx(() {
                          final data = controller.transaksiOutDet;
                          if (data.isEmpty) {
                            return SizedBox(); // Kalau kosong, tombol tidak ditampilkan
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PrimaryColor().blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // radius sudut tombol
                              ),
                            ),
                            onPressed: () {
                              controller.pdfTransaksiOut();
                            },
                            child: Text('Download PDF',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          );
                        })
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        final allItems = List<Map<String, dynamic>>.from(
                            controller.transaksiOutDet);
                        allItems.sort((a, b) =>
                            (int.tryParse(b['jumlah'].toString()) ?? 0)
                                .compareTo(
                                    int.tryParse(a['jumlah'].toString()) ?? 0));
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 1,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Semua Barang Terjual',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 25,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: allItems.length,
                                        itemBuilder: (context, index) {
                                          final item = allItems[index];
                                          return Card(
                                            elevation: 0,
                                            margin: EdgeInsets.only(bottom: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Colors.grey.shade200),
                                            ),
                                            color: Colors.white,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    // "http://10.0.2.2/POS_CI/uploads/${controller.GambarBarang(item['id_produk'])}",
                                                    "http://192.168.1.8/POS_CI/uploads/${controller.GambarBarang(item['id_produk'])}",
                                                    width: 50, // atur lebar
                                                    height: 50, // atur tinggi
                                                    fit: BoxFit
                                                        .cover, // atau BoxFit.contain, sesuai kebutuhan
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Center(
                                                          child: Icon(
                                                              Icons.error));
                                                    },
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          controller.ProdukName(
                                                              item[
                                                                  'id_produk']),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          '${item['jumlah']} Item terjual',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey.shade700,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'Pendapatan Produk : Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['total_harga'].toString()) ?? 0)}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Total Laba : Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['laba'].toString()) ?? 0)}',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Obx(() {
                          final topItems = List<Map<String, dynamic>>.from(
                              controller.transaksiOutDet);
                          topItems.sort((a, b) =>
                              (int.tryParse(b['jumlah'].toString()) ?? 0)
                                  .compareTo(
                                      int.tryParse(a['jumlah'].toString()) ??
                                          0));
                          final topThree = topItems.take(3).toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Barang Yang Terjual',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 20),
                                ],
                              ),
                              SizedBox(height: 20),
                              ...topThree.map((item) {
                                return Card(
                                  elevation: 0,
                                  margin: EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                          "http://10.10.20.172/POS_CI/uploads/${controller.GambarBarang(item['id_produk'])}",
                                          // "http://192.168.1.8/POS_CI/uploads/${controller.GambarBarang(item['id_produk'])}",
                                          width: 50, // atur lebar
                                          height: 50, // atur tinggi
                                          fit: BoxFit
                                              .cover, // atau BoxFit.contain, sesuai kebutuhan
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Icon(Icons.error));
                                          },
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.ProdukName(
                                                    item['id_produk']),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${item['jumlah']} Item terjual',
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Pendapatan Produk : Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['total_harga'].toString()) ?? 0)}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Total Laba : Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['laba'].toString()) ?? 0)}',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      final allItems = List<Map<String, dynamic>>.from(
                          controller.transaksiInDet);
                      allItems.sort((a, b) =>
                          (int.tryParse(b['jumlah'].toString()) ?? 0).compareTo(
                              int.tryParse(a['jumlah'].toString()) ?? 0));
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 1,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Semua Pengeluaran',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: allItems.length,
                                      itemBuilder: (context, index) {
                                        final item = allItems[index];
                                        return Card(
                                          elevation: 0,
                                          margin: EdgeInsets.only(bottom: 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: BorderSide(
                                                color: Colors.grey.shade200),
                                          ),
                                          color: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.ProdukName(
                                                          item['id_produk']) +
                                                      " (" +
                                                      controller.NoTransaksi(item[
                                                          'id_transaksi_in']) +
                                                      ")",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15,
                                                    color:
                                                        Colors.indigo.shade900,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text('Jumlah')),
                                                    Text(':'),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                        child: Text(
                                                            '${item['jumlah']} Pcs')),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            'Harga Perpcs')),
                                                    Text(':'),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                        child: Text(
                                                            'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['harga_satuan'].toString()) ?? 0)}')),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            'Total Harga')),
                                                    Text(':'),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                        child: Text(
                                                            'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['total_harga'].toString()) ?? 0)}')),
                                                  ],
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text('Waktu')),
                                                    Text(':'),
                                                    SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        formatTanggal(
                                                            item['input_date']),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Pengeluaran',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Card(
                              elevation: 0,
                              child: Obx(() {
                                final recentItems =
                                    controller.transaksiInDet.take(3).toList();
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: recentItems.map((item) {
                                    return Card(
                                      elevation: 0,
                                      margin: EdgeInsets.only(bottom: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                            color: Colors.grey.shade200),
                                      ),
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.ProdukName(
                                                      item['id_produk']) +
                                                  " (" +
                                                  controller.NoTransaksi(
                                                      item['id_transaksi_in']) +
                                                  ")",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                                color: Colors.indigo.shade900,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(child: Text('Jumlah')),
                                                Text(':'),
                                                SizedBox(width: 8),
                                                Expanded(
                                                    child: Text(
                                                        '${item['jumlah']} Pcs')),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child:
                                                        Text('Harga Perpcs')),
                                                Text(':'),
                                                SizedBox(width: 8),
                                                Expanded(
                                                    child: Text(
                                                        'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['harga_satuan'].toString()) ?? 0)}')),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text('Total Harga')),
                                                Text(':'),
                                                SizedBox(width: 8),
                                                Expanded(
                                                    child: Text(
                                                        'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['total_harga'].toString()) ?? 0)}')),
                                              ],
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Expanded(child: Text('Waktu')),
                                                Text(':'),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    formatTanggal(
                                                        item['input_date']),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ),
                            SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: Color(0xFFF9FAFB),
                                width: MediaQuery.of(context).size.width * 1,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Obx(() {
                                    final data = controller.transaksiInDet;
                                    if (data.isEmpty) {
                                      return SizedBox(
                                        height: 10,
                                      );
                                    }
                                    return Container(
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      child: DataTable(
                                        columnSpacing: 24,
                                        horizontalMargin: 16,
                                        dividerThickness: 1,
                                        headingRowColor:
                                            MaterialStateProperty.all(
                                          Color(0xFFEEF2F7),
                                        ),
                                        headingTextStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF374151),
                                        ),
                                        dataTextStyle: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF111827),
                                        ),
                                        columns: const [
                                          DataColumn(label: Text('No')),
                                          DataColumn(label: Text('Tanggal')),
                                          DataColumn(
                                              label: Text('No. Transaksi')),
                                          DataColumn(label: Text('Produk')),
                                          DataColumn(
                                              label: Text('Jumlah Produk')),
                                          DataColumn(
                                              label: Text('Total Harga')),
                                        ],
                                        rows:
                                            List.generate(data.length, (index) {
                                          final item = data[index];
                                          final isEven = index % 2 == 0;

                                          return DataRow(
                                            color: MaterialStateProperty.all(
                                              isEven
                                                  ? Colors.white
                                                  : Color(0xFFF1F5F9),
                                            ),
                                            cells: [
                                              DataCell(Text('${index + 1}')),
                                              DataCell(Text(formatTanggal(
                                                  item['input_date']))),
                                              DataCell(Text(
                                                  controller.NoTransaksi(item[
                                                      'id_transaksi_in']))),
                                              DataCell(Text(
                                                  controller.ProdukName(
                                                      item['id_produk']))),
                                              DataCell(Text(
                                                  '${item['jumlah']} Pcs')),
                                              DataCell(Text(
                                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['total_harga'].toString()) ?? 0)}')),
                                            ],
                                          );
                                        }),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(() {
                              final data = controller.transaksiInDet;
                              if (data.isEmpty) {
                                return SizedBox(); // Kalau kosong, tombol tidak ditampilkan
                              }
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: PrimaryColor().blue,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // radius sudut tombol
                                  ),
                                ),
                                onPressed: () {
                                  controller.pdfTransaksiIn();
                                },
                                child: Text('Download PDF',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          NavbarDrawer(context, scaffoldKey),
          Obx(() {
            return controller.isLoading.value
                ? Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      drawer: buildDrawer(context),
    );
  }

  void pickDate(BuildContext context) async {
    if (controller.selectedValue.value == 'Perhari') {
      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: PrimaryColor().blue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
                surface: Colors.white,
              ),
              dialogBackgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        controller.selectedStartDate.value = picked;
        controller.selectedEndDate.value = picked;
        controller.dateLabel.value =
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(picked);
        controller.filterTransaksiOutDet();
      }
    } else {
      DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022),
        lastDate: DateTime.now(),
        initialDateRange: DateTimeRange(
          start: controller.selectedStartDate.value,
          end: controller.selectedEndDate.value,
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: PrimaryColor().blue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
                surface: Colors.white,
              ),
              dialogBackgroundColor: Colors.white,
              textTheme: TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        controller.selectedStartDate.value = picked.start;
        controller.selectedEndDate.value = picked.end;
        controller.dateLabel.value =
            '${DateFormat('dd MMM', 'id_ID').format(picked.start)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(picked.end)}';
        controller.filterTransaksiOutDet();
      }
    }
  }
}

Widget CardReport(
  String text1,
  String text2,
  IconData icon, {
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Container(
    width: 180,
    child: InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Atas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        text2,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.blue,
                      size: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      ),
    ),
  );
}

String formatTanggal(String tanggal) {
  try {
    final parsedDate = DateTime.parse(tanggal);
    final formatter = DateFormat('d MMMM y, HH:mm', 'id_ID');
    return formatter.format(parsedDate);
  } catch (e) {
    return tanggal; // fallback jika gagal parsing
  }
}

Widget buildChart({
  required String text,
  required List<FlSpot> spots,
  required List<String> labels,
  required Color color,
  required BuildContext context,
  required double interval,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: color),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 300,
          margin: EdgeInsets.only(top: 10),
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      final value = touchedSpot.y;
                      final formatted = NumberFormat.decimalPattern('id_ID')
                          .format(value.toInt());
                      return LineTooltipItem(
                        formatted,
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 70,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          NumberFormat.decimalPattern('id_ID')
                              .format(value.toInt()),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 70,
                    interval: interval,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          NumberFormat.decimalPattern('id_ID')
                              .format(value.toInt()),
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 30,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < 0 || index >= labels.length) {
                        return const SizedBox.shrink();
                      }
                      final rawDate = labels[index];
                      final parsedDate = DateTime.tryParse(rawDate);
                      final label = parsedDate != null
                          ? DateFormat('d MMM', 'id_ID').format(parsedDate)
                          : 'N/A';
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          label,
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: color.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
