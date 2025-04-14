import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/AddPageC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/dashboardAdminC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/productP.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/widgets/admin/adminW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/notFoundW.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardAdminP extends StatelessWidget {
  DashboardAdminP({super.key});
  final AuthController logoutController = Get.put(AuthController());
  final AddPageController authController = Get.put(AddPageController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DashbaordAdminC c = Get.put(DashbaordAdminC());
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
      backgroundColor: DarkColor().blue,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: DarkColor().blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '19 JAN 2024',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w300,
                    fontSize: 21,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '100 Barang',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Terjual',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
            padding: EdgeInsets.only(left: 35, right: 35, top: 80, bottom: 30),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Container(
                width: double.infinity,
                height: 280,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.vertical(
                      top: Radius.circular(50)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Jan',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            letterSpacing: 1,
                                            color: PrimaryColor().aqua),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      color: ShadowColor().aqua,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(100),
                                          topRight: Radius.circular(100))),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Feb',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            letterSpacing: 1,
                                            color: PrimaryColor().aqua),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        '•',
                                        style: TextStyle(
                                            color: PrimaryColor().aqua,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Mar',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            letterSpacing: 1,
                                            color: PrimaryColor().aqua),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Apr',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            letterSpacing: 1,
                                            color: PrimaryColor().aqua),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        'May',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            letterSpacing: 1,
                                            color: PrimaryColor().aqua),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 69),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ShadowColor().aqua,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(25.0),
                                  height: 300,
                                  child: LineChart(
                                    LineChartData(
                                      // Pastikan ini adalah parameter dari LineChart
                                      gridData: FlGridData(show: true),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: true),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: true),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: true),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: [
                                            FlSpot(0, 1),
                                            FlSpot(1, 3),
                                            FlSpot(2, 1.5),
                                            FlSpot(3, 1.5),
                                            FlSpot(4, 4),
                                          ],
                                          isCurved: true,
                                          // colors: [Colors.blue],
                                          barWidth: 3,
                                          belowBarData:
                                              BarAreaData(show: false),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'PENJUALAN BULANAN 2024',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
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
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          AdminW().aktivitasTerbaru('Golda Coffee', '5000', '2',
                              'QRIS', '8 November 2023'),
                          AdminW().aktivitasTerbaru('Golda Coffee', '5000', '2',
                              'Cash', '8 November 2023'),
                          AdminW().aktivitasTerbaru('Golda Coffee', '5000', '2',
                              'E-Wallet', '8 November 2023'),
                        ],
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
                        Icon(
                          FontAwesomeIcons.angleRight,
                          color: PrimaryColor().blue,
                          size: 20,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AdminW().laporanStock([
                      {
                        "nama": 'Golda Coffee',
                        "stock": 2,
                        "image":
                            'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//101/MTA-2644895/golda_golda-coffee-dolce-latte--200-ml--pet-_full03.jpg'
                      },
                      {
                        "nama": 'Yakult',
                        "stock": 2,
                        "image":
                            'https://res.cloudinary.com/dk0z4ums3/image/upload/v1709014802/attached_image/yakult.jpg'
                      },
                      {
                        "nama": 'Indomie Goreng',
                        "stock": 2,
                        'image':
                            'https://images.tokopedia.net/img/cache/700/VqbcmM/2024/4/13/a55ae577-91f2-444c-851e-9d5c8a0c3673.jpg'
                      },
                    ]),
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
                      height: 10,
                    ),
                    Container(
                      height: 140,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: 50,
                                          color: PrimaryColor().blue,
                                          title: '50%',
                                          radius: 30,
                                          titleStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        PieChartSectionData(
                                          value: 50,
                                          color: PrimaryColor().black,
                                          radius: 30,
                                        ),
                                      ],
                                      centerSpaceRadius:
                                          20, // Space di tengah pie chart
                                      sectionsSpace: 1, // Space antar slice
                                    ),
                                  ),
                                ),
                                Text(
                                  'QRIS',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: 33,
                                          color: PrimaryColor().blue,
                                          title: '33%',
                                          radius: 30,
                                          titleStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        PieChartSectionData(
                                          value: 67,
                                          color: PrimaryColor().black,
                                          radius: 30,
                                        ),
                                      ],
                                      centerSpaceRadius:
                                          20, // Space di tengah pie chart
                                      sectionsSpace: 1, // Space antar slice
                                    ),
                                  ),
                                ),
                                Text(
                                  'Cash',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: 33,
                                          color: PrimaryColor().blue,
                                          title: '33%',
                                          radius: 30,
                                          titleStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        PieChartSectionData(
                                          value: 67,
                                          color: PrimaryColor().black,
                                          radius: 30,
                                        ),
                                      ],
                                      centerSpaceRadius:
                                          20, // Space di tengah pie chart
                                      sectionsSpace: 1, // Space antar slice
                                    ),
                                  ),
                                ),
                                Text(
                                  'E-Wallet',
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 19,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          NavbarDrawer(context, scaffoldKey),
        ],
      ),
      drawer: buildDrawer(context),
    );
  }
}
