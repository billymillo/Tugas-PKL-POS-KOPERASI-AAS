import 'package:bluetooth_thermal_printer_example/controllers/admin/transaksiInMitraC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/admin/transaksiOutM.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransaksiOutMitraP extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TransaksiOutMController c = Get.put(TransaksiOutMController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF3F6FD),
      drawer: buildDrawer(context),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transaksi Out Mitra",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pilih Mitra",
                                          style: TextStyle(fontSize: 13)),
                                      const SizedBox(height: 6),
                                      Obx(() {
                                        return DropdownButtonFormField<String>(
                                          value: c.selectedMitra.value.isEmpty
                                              ? null
                                              : c.selectedMitra.value,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.grey.shade100,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 14),
                                          ),
                                          hint: Text('Pilih Mitra',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black54)),
                                          items: c.mitra.map((mitra) {
                                            return DropdownMenuItem<String>(
                                              value: mitra['id'].toString(),
                                              child: Text(mitra['nama'],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black54)),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            c.selectedMitra.value = value!;
                                            print('Mitra ID selected: $value');
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Rentang Tanggal",
                                          style: TextStyle(fontSize: 13)),
                                      const SizedBox(height: 6),
                                      Obx(() => InkWell(
                                            onTap: () async {
                                              DateTimeRange? picked =
                                                  await showDateRangePicker(
                                                context: context,
                                                firstDate: DateTime(2022),
                                                lastDate: DateTime.now(),
                                                initialDateRange: DateTimeRange(
                                                  start:
                                                      c.selectedStartDate.value,
                                                  end: c.selectedEndDate.value,
                                                ),
                                                builder: (context, child) =>
                                                    Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    colorScheme:
                                                        ColorScheme.light(
                                                      primary:
                                                          PrimaryColor().blue,
                                                      onPrimary: Colors.white,
                                                      onSurface: Colors.black,
                                                    ),
                                                  ),
                                                  child: child!,
                                                ),
                                              );
                                              if (picked != null) {
                                                c.selectedStartDate.value =
                                                    picked.start;
                                                c.selectedEndDate.value =
                                                    picked.end;
                                                c.dateLabel.value =
                                                    '${DateFormat('dd MMM', 'id_ID').format(picked.start)} - ${DateFormat('dd MMM yyyy', 'id_ID').format(picked.end)}';
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 14),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.transparent),
                                              ),
                                              child: Text(
                                                c.dateLabel.value,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  c.filterTransaksiOutDet();
                                  c.filterAllTransaksiOutDet();
                                  c.fetchTransaksiOutDet();
                                },
                                icon: const Icon(Icons.filter_alt,
                                    color: Colors.white),
                                label: const Text('Terapkan Filter',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  padding: const EdgeInsets.symmetric(
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
                    SizedBox(height: 10),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  final totalSaldo =
                                      c.transaksiOutDet.fold<int>(
                                    0,
                                    (sum, item) =>
                                        sum +
                                        (int.tryParse((double.tryParse(
                                                        item['saldo']
                                                            .toString()) ??
                                                    0)
                                                .toStringAsFixed(0)) ??
                                            0),
                                  );

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${c.MitraName(c.selectedMitra.value.toString())}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'Total Penjualan : ' +
                                            c.formatRupiah(totalSaldo),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${c.formatTanggal(c.selectedStartDate.value.toString())} - ${c.formatTanggal(c.selectedEndDate.value.toString())}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                Row(
                                  children: [
                                    Obx(() {
                                      final data = c.transaksiOutDet;
                                      if (data.isEmpty) {
                                        return SizedBox();
                                      }
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          c.pdfTransaksiOutDet();
                                        },
                                        child: Text('Download PDF',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      );
                                    }),
                                    SizedBox(width: 10),
                                    Obx(() {
                                      final data = c.transaksiOutDet;
                                      if (data.isEmpty) {
                                        return SizedBox();
                                      }
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: PrimaryColor().blue,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(25),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        163,
                                                                        171,
                                                                        255),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .people_alt_outlined,
                                                                color:
                                                                    PrimaryColor()
                                                                        .blue,
                                                                size: 50,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 25),
                                                          Text(
                                                            "Tarik Saldo Mitra",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            'Anda akan menarik saldo mitra pada tanggal',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          Text(
                                                            '${c.formatTanggal(c.selectedStartDate.value.toString())} - ${c.formatTanggal(c.selectedEndDate.value.toString())}',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Obx(() =>
                                                              ElevatedButton(
                                                                onPressed: c
                                                                        .isLoading
                                                                        .value
                                                                    ? null
                                                                    : () async {
                                                                        c.isLoading.value =
                                                                            true;
                                                                        await c
                                                                            .tarikSaldoMitra();
                                                                        c.selectedMitra.value =
                                                                            '';
                                                                        // c.selectedStartDate.value =
                                                                        //     DateTime.now();
                                                                        // c.selectedEndDate.value =
                                                                        //     DateTime.now();
                                                                        // c.dateLabel
                                                                        //     .value = DateFormat('dd MMM', 'id_ID')
                                                                        //         .format(c.selectedStartDate.value) +
                                                                        //     ' - ' +
                                                                        //     DateFormat('dd MMM yyyy', 'id_ID').format(c.selectedEndDate.value);
                                                                        await c
                                                                            .fetchTransaksiOutDet();
                                                                        c.filterTransaksiOutDet();
                                                                        c.filterAllTransaksiOutDet();
                                                                        c.isLoading.value =
                                                                            false;
                                                                        Get.back();
                                                                      },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .blue,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                ),
                                                                child: c.isLoading
                                                                        .value
                                                                    ? SizedBox(
                                                                        width:
                                                                            20,
                                                                        height:
                                                                            20,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              Colors.white,
                                                                          strokeWidth:
                                                                              2,
                                                                        ),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'Tarik Saldo',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                              )),
                                                          SizedBox(height: 5),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Get.back();
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'Batal',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black54,
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
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text('Tarik Saldo',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      );
                                    }),
                                    SizedBox(width: 10),
                                    Obx(() {
                                      final data = c.transaksiOutDet;
                                      if (data.isEmpty) {
                                        return SizedBox();
                                      }
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: PrimaryColor().red,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  padding: EdgeInsets.all(20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        10),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(25),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        163,
                                                                        163),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .people_alt_outlined,
                                                                color:
                                                                    PrimaryColor()
                                                                        .red,
                                                                size: 50,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 25),
                                                          Text(
                                                            "Pembatalan Penarikan Saldo",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 10),
                                                          Text(
                                                            'Anda akan mengembalikan saldo seperti sebelumnya. Lanjutkan?',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Obx(() =>
                                                              ElevatedButton(
                                                                onPressed: c
                                                                        .isLoading
                                                                        .value
                                                                    ? null
                                                                    : () async {
                                                                        c.isLoading.value =
                                                                            true;
                                                                        await c
                                                                            .undoTarikSaldo();
                                                                        c.selectedMitra.value =
                                                                            '';
                                                                        await c
                                                                            .fetchTransaksiOutDet();
                                                                        c.filterTransaksiOutDet();
                                                                        c.filterAllTransaksiOutDet();
                                                                        c.isLoading.value =
                                                                            false;
                                                                        Get.back();
                                                                      },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                ),
                                                                child: c.isLoading
                                                                        .value
                                                                    ? SizedBox(
                                                                        width:
                                                                            20,
                                                                        height:
                                                                            20,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          color:
                                                                              Colors.white,
                                                                          strokeWidth:
                                                                              2,
                                                                        ),
                                                                      )
                                                                    : Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                              width: 8),
                                                                          Text(
                                                                            'Ya, Lanjutkan',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                              )),
                                                          SizedBox(height: 5),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              Get.back();
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade200,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  'Batal',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black54,
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
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text('Batalkan Penarikan',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              color: Colors.white,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 1
                                          : 1.3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Obx(() => DataTable(
                                        headingRowColor:
                                            MaterialStateProperty.all(
                                                Color(0xFFF9FAFB)),
                                        headingTextStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF4B5563),
                                          fontSize: 14,
                                        ),
                                        dataTextStyle: TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 14,
                                        ),
                                        columnSpacing: 24,
                                        horizontalMargin: 16,
                                        dividerThickness: 1,
                                        headingRowHeight: 48,
                                        columns: const [
                                          DataColumn(label: Text('No')),
                                          DataColumn(
                                              label: Text('Nama Barang',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Jumlah',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Harga Satuan',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Harga Jual',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Total Harga Dasar',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Total Harga Jual',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Laba',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Saldo',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                          DataColumn(
                                              label: Text('Tanggal',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ],
                                        rows: List.generate(
                                            c.transaksiOutDet.length, (index) {
                                          final item = c.transaksiOutDet[index];
                                          final jumlah = item['jumlah'] ?? 0;
                                          final hargaSatuan =
                                              item['harga_satuan'] ?? 0;
                                          final hargaJual =
                                              item['harga_jual'] ?? 0;
                                          final totalDasar =
                                              item['total_harga_dasar'] ?? 0;
                                          final totalJual =
                                              item['total_harga'] ?? 0;
                                          final laba = item['laba'] ?? 0;
                                          final saldo = item['saldo'] ?? 0;
                                          final tanggal =
                                              item['input_date'] ?? 0;

                                          return DataRow(
                                            color: index % 2 == 0
                                                ? null
                                                : MaterialStateProperty.all(
                                                    Color(0xFFF6F9FC)),
                                            cells: [
                                              DataCell(SizedBox(
                                                width: 20,
                                                child: Text('${index + 1}',
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              )),
                                              DataCell(Text(
                                                  c.ProdukName(item['id_produk']
                                                      .toString()),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text('$jumlah',
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text(
                                                  c.formatRupiah(hargaSatuan),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text(
                                                  c.formatRupiah(hargaJual),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text(
                                                  c.formatRupiah(totalDasar),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text(
                                                  c.formatRupiah(totalJual),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text(
                                                  c.formatRupiah(laba),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text(
                                                  c.formatRupiah(saldo),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                              DataCell(Text(
                                                  c.formatTanggal(tanggal),
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                            ],
                                          );
                                        }),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            NavbarDrawer(context, scaffoldKey),
          ],
        ),
      ),
    );
  }
}
