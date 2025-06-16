import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/AddPageC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/dashboardAdminC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/widgets/admin/adminW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DashboardAdminP extends StatelessWidget {
  DashboardAdminP({super.key});
  final AuthController logoutController = Get.put(AuthController());
  final AddPageController authController = Get.put(AddPageController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DashboardController c = Get.put(DashboardController());
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      backgroundColor: DarkColor().blue,
      body: Column(
        children: [
          NavbarDrawer(context, scaffoldKey),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await c.fetchTransaksiOut();
                await c.fetchTransaksiOutDet();
                await c.fetchProduk();
                await c.fetchTransaksiInDet();
                await c.fetchTransaksiIn();
                c.updateChartData();
              },
              child: ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          AdminW().buildInfoBox(
                            title: 'Total Penjualan',
                            value: Obx(() => Text(
                                  '${c.totalProduk.value} Item',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          const SizedBox(width: 20),
                          AdminW().buildInfoBox(
                            title: 'Saldo Koperasi',
                            value: Obx(() => Text(
                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(c.totalSaldo.value.toString()) ?? 0)}',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          const SizedBox(width: 20),
                          AdminW().buildInfoBox(
                            title: 'Laba Bersih',
                            value: Obx(() => Text(
                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(c.totalLaba.value)}',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.vertical(
                          top: Radius.circular(25)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Stack(
                              children: [
                                Obx(() => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [2025, 2026, 2027].map((year) {
                                        final isSelected =
                                            c.selectedYear.value == year;
                                        return GestureDetector(
                                          onTap: () => c.selectYear(year),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 20),
                                            decoration: isSelected
                                                ? BoxDecoration(
                                                    color: ShadowColor().aqua,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  )
                                                : null,
                                            child: Text(
                                              '$year',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                letterSpacing: 1,
                                                color: PrimaryColor().aqua,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Stack(
                              children: [
                                Obx(() => SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          'Jan',
                                          'Feb',
                                          'Mar',
                                          'Apr',
                                          'Mei',
                                          'Jun',
                                          'Jul',
                                          'Agu',
                                          'Sep',
                                          'Okt',
                                          'Nov',
                                          'Des'
                                        ].map((month) {
                                          final isSelected =
                                              c.selectedMonth.value == month;
                                          return GestureDetector(
                                            onTap: () => c.selectMonth(month),
                                            child: Container(
                                              margin: const EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                      4), // biar agak renggang
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                              decoration: isSelected
                                                  ? BoxDecoration(
                                                      color: ShadowColor().aqua,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                100),
                                                        topLeft:
                                                            Radius.circular(
                                                                100),
                                                      ),
                                                    )
                                                  : null,
                                              child: Text(
                                                '$month',
                                                style: GoogleFonts.roboto(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  letterSpacing: 1,
                                                  color: PrimaryColor().aqua,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )),
                                Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 69),
                                      decoration: BoxDecoration(
                                        color: ShadowColor().aqua,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: EdgeInsets.all(25.0),
                                      height: 390,
                                      child: Obx(() {
                                        final spots = c.produkChartSpots;
                                        if (spots.isEmpty) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.bar_chart,
                                                    size: 64,
                                                    color: PrimaryColor().blue),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Tidak ada data penjualan.",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  "Silakan pilih bulan atau tahun lain.",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Penjualan Produk',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: PrimaryColor().blue,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          1.5
                                                      : null,
                                                  height: 300,
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Obx(() {
                                                    final spots =
                                                        c.produkChartSpots;
                                                    final labels =
                                                        c.produkChartLabels;
                                                    if (spots.isEmpty) {
                                                      return const Center(
                                                          child: Text(
                                                              "Tidak ada data penjualan."));
                                                    }
                                                    return SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            1.5,
                                                        child: LineChart(
                                                          LineChartData(
                                                            lineTouchData:
                                                                LineTouchData(
                                                              handleBuiltInTouches:
                                                                  true,
                                                              touchTooltipData:
                                                                  LineTouchTooltipData(
                                                                tooltipRoundedRadius:
                                                                    8,
                                                                getTooltipItems:
                                                                    (touchedSpots) {
                                                                  return touchedSpots
                                                                      .map(
                                                                          (touchedSpot) {
                                                                    final value =
                                                                        touchedSpot
                                                                            .y;
                                                                    final formatted = NumberFormat.decimalPattern(
                                                                            'id_ID')
                                                                        .format(
                                                                            value.toInt());
                                                                    return LineTooltipItem(
                                                                      formatted,
                                                                      const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    );
                                                                  }).toList();
                                                                },
                                                              ),
                                                            ),
                                                            gridData:
                                                                FlGridData(
                                                                    show: true),
                                                            titlesData:
                                                                FlTitlesData(
                                                              leftTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      true,
                                                                  reservedSize:
                                                                      50,
                                                                  interval: 10,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Text(
                                                                        NumberFormat.decimalPattern('id_ID')
                                                                            .format(value.toInt()),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              rightTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      true,
                                                                  reservedSize:
                                                                      50,
                                                                  interval: 10,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Text(
                                                                        NumberFormat.decimalPattern('id_ID')
                                                                            .format(value.toInt()),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              bottomTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      true,
                                                                  interval: 1,
                                                                  reservedSize:
                                                                      30,
                                                                  getTitlesWidget:
                                                                      (value,
                                                                          meta) {
                                                                    int index =
                                                                        value
                                                                            .toInt();

                                                                    if (index <
                                                                            0 ||
                                                                        index >=
                                                                            labels.length) {
                                                                      return const SizedBox
                                                                          .shrink();
                                                                    }
                                                                    final label =
                                                                        labels[
                                                                            index];
                                                                    return Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        '$label ${c.selectedMonth.value}',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                10),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            borderData:
                                                                FlBorderData(
                                                                    show: true),
                                                            lineBarsData: [
                                                              LineChartBarData(
                                                                spots: spots,
                                                                isCurved: true,
                                                                color:
                                                                    PrimaryColor()
                                                                        .blue,
                                                                barWidth: 3,
                                                                dotData: FlDotData(
                                                                    show:
                                                                        false),
                                                                belowBarData:
                                                                    BarAreaData(
                                                                  show: true,
                                                                  color: PrimaryColor()
                                                                      .blue
                                                                      .withOpacity(
                                                                          0.2),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Obx(
                                      () => Text(
                                        'PENJUALAN BULANAN ${c.selectedYear.value}',
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Penjualan Terbaru",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width *
                                (MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 1
                                    : 1.2),
                            child: Obx(() {
                              final sortedList = c.transaksiOutDet.toList()
                                ..sort((a, b) => DateTime.parse(b['input_date'])
                                    .compareTo(
                                        DateTime.parse(a['input_date'])));
                              final latestThree = sortedList.take(3).toList();
                              return Column(
                                children: latestThree.map((item) {
                                  return AdminW().aktivitasTerbaru(
                                    c.ProdukName(item['id_produk']),
                                    'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['total_harga'].toString()) ?? 0)}',
                                    item['jumlah']?.toString() ?? '0',
                                    c.NoTransaksi(item['id_transaksi_out']),
                                    formatTanggal(item['input_date']),
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Laporan Stock",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                fontSize: 23,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed(Routes.PRODUCTP),
                              child: Icon(
                                FontAwesomeIcons.angleRight,
                                color: Colors.black,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(() {
                          final produkList = c.produk;

                          if (produkList.isEmpty) {
                            return Center(child: Text('Belum ada data produk'));
                          }
                          return AdminW().laporanStock(produkList);
                        }),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Metode Pembayaran",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w600,
                                fontSize: 23,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.angleRight,
                              size: 20,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 240,
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() {
                                  double total = c.totalQRIS.value.toDouble() +
                                      c.totalCash.value.toDouble();
                                  double qrisPercent = total == 0
                                      ? 0
                                      : (c.totalQRIS.value / total) * 100;
                                  double cashPercent = total == 0
                                      ? 0
                                      : (c.totalCash.value / total) * 100;
                                  double saldoPercent = total == 0
                                      ? 0
                                      : (c.totalSaldoMetode.value / total) *
                                          100;
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                value: c.totalQRIS.value
                                                    .toDouble(),
                                                color: PrimaryColor().blue,
                                                title:
                                                    '${qrisPercent.toStringAsFixed(1)}%',
                                                radius: 45,
                                                titleStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              PieChartSectionData(
                                                value: c.totalCash.value
                                                    .toDouble(),
                                                color: PrimaryColor().black,
                                                title:
                                                    '${cashPercent.toStringAsFixed(1)}%',
                                                radius: 45,
                                                titleStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              PieChartSectionData(
                                                value: c.totalSaldoMetode.value
                                                    .toDouble(),
                                                color: PrimaryColor().red,
                                                title:
                                                    '${saldoPercent.toStringAsFixed(1)}%',
                                                radius: 45,
                                                titleStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                            centerSpaceRadius: 20,
                                            sectionsSpace: 1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Tunai = ${c.totalCash.value} Transaksi',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: PrimaryColor().black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'QRIS = ${c.totalQRIS.value} Transaksi',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: PrimaryColor().blue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Saldo = ${c.totalSaldoMetode.value} Transaksi',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: PrimaryColor().red,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              Expanded(
                                child: Obx(() {
                                  double total = c.member.value.toDouble() +
                                      c.nonMember.value.toDouble();
                                  double memberPercent = total == 0
                                      ? 0
                                      : (c.member.value / total) * 100;
                                  double nonMemberPercent = total == 0
                                      ? 0
                                      : (c.nonMember.value / total) * 100;

                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: PieChart(
                                          PieChartData(
                                            sections: [
                                              PieChartSectionData(
                                                value:
                                                    c.member.value.toDouble(),
                                                color: PrimaryColor().blue,
                                                title:
                                                    '${memberPercent.toStringAsFixed(1)}%',
                                                radius: 45,
                                                titleStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              PieChartSectionData(
                                                value: c.nonMember.value
                                                    .toDouble(),
                                                color: PrimaryColor().black,
                                                title:
                                                    '${nonMemberPercent.toStringAsFixed(1)}%',
                                                radius: 45,
                                                titleStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                            centerSpaceRadius: 20,
                                            sectionsSpace: 1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Non Member = ${c.nonMember.value} Orang',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: PrimaryColor().black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Member = ${c.member.value} Orang',
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: PrimaryColor().blue,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: buildDrawer(context),
    );
  }
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
