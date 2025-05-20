import 'package:bluetooth_thermal_printer_example/controllers/kasir/transaksiC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransaksiP extends StatelessWidget {
  final TransaksiC controller = Get.put(TransaksiC());
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchControllerKasbon = TextEditingController();
  final currencyFormat = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Riwayat Transaksi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Lunas',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Kasbon',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 3,
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              if (controller.isLoading.value &&
                  controller.transaksiLunas.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) => controller.searchTransaksi(query),
                      decoration: InputDecoration(
                        hintText: "Cari transaksi...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          controller.loadMoreTransaksiLunas();
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await controller.refresh();
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.transaksiLunas.length,
                          itemBuilder: (context, index) {
                            if (index == controller.transaksiLunas.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "Koperasi Anugrah Artha Abadi",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final transaksi = controller.transaksiLunas[index];
                            Color textColor =
                                transaksi['status_transaksi'] == '2'
                                    ? Colors.red
                                    : Colors.green;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  var transaksiDetail = controller.detailTr
                                      .where((item) =>
                                          item['id_transaksi_out'].toString() ==
                                          transaksi['id'].toString())
                                      .toList();
                                  if (transaksiDetail.isEmpty) {
                                    Get.snackbar(
                                      "Gagal",
                                      "Transaksi tidak memiliki detail",
                                      colorText: Colors.white,
                                      backgroundColor: Colors.red,
                                      icon: Icon(Icons.error,
                                          color: Colors.white),
                                    );
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        elevation: 8,
                                        backgroundColor: Colors.white,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 20, 20, 12),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Detail Transaksi (${controller.MetodeName(transaksi['id_metode_pembayaran'])})',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            'Nomor Transaksi: ${transaksi['no_transaksi_out']}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .shade700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      icon: Icon(Icons.close,
                                                          color: Colors
                                                              .grey.shade700),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 16, 20, 16),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor
                                                              .withOpacity(0.2),
                                                      radius: 24,
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 24,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            controller.MemberName(
                                                                    transaksi[
                                                                            'id_member']
                                                                        .toString()) +
                                                                ' (${transaksi['no_transaksi_out']})',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .calendar_today,
                                                                size: 14,
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                formatDate(
                                                                    transaksi[
                                                                        'input_date']),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Divider(height: 1),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Items (${transaksi['jumlah_produk']})',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    // Product list
                                                    ...transaksiDetail
                                                        .map((item) {
                                                      final matchedAddons = controller
                                                          .addOnTr
                                                          .where((addon) =>
                                                              addon['id_transaksi_out']
                                                                      .toString() ==
                                                                  item['id_transaksi_out']
                                                                      .toString() &&
                                                              addon['id_det_transaksi_out']
                                                                      .toString() ==
                                                                  item['id']
                                                                      .toString())
                                                          .toList();

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 4),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 42,
                                                              height: 42,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  '${item['jumlah']}x',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Produk: ' +
                                                                        controller.ProdukName(
                                                                            item['id_produk']),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    'SKU: #${item['id_produk']}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                    ),
                                                                  ),
                                                                  matchedAddons
                                                                          .isNotEmpty
                                                                      ? Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(width: 20),
                                                                            ...matchedAddons.map((addon) {
                                                                              final hargaPerAddon = controller.addOnHarga(addon['id_add_on'].toString());
                                                                              final jumlah = int.tryParse(item['jumlah'].toString()) ?? 1;
                                                                              final totalHarga = hargaPerAddon * jumlah;
                                                                              return Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    '(+) ${controller.addOnName(addon['id_add_on'].toString())} : ',
                                                                                    style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      color: Colors.grey.shade600,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(width: 10),
                                                                                  Text(
                                                                                    "Rp ${NumberFormat('#,##0', 'id_ID').format(totalHarga)}",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      color: Colors.grey.shade600,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            }),
                                                                          ],
                                                                        )
                                                                      : (item['harga_add_on'] !=
                                                                              "0"
                                                                          ? Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "(+) Add On : ",
                                                                                  style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    color: Colors.grey.shade600,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 10),
                                                                                Text(
                                                                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(item['harga_add_on']))}',
                                                                                  style: TextStyle(
                                                                                    fontSize: 13,
                                                                                    color: Colors.grey.shade600,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : SizedBox
                                                                              .shrink()),
                                                                ],
                                                              ),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(item['harga_jual']))}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 4),
                                                                Text(
                                                                  '${NumberFormat('#,##0', 'id_ID').format(int.parse(item['jumlah']))} pcs',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height: 4),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ],
                                                ),
                                              ),
                                              // Payment summary
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade50,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16),
                                                    bottomRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Diskon',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(transaksi['diskon']))}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Transaksi',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(transaksi['total_transaksi']) + int.parse(controller.totalKasbon(transaksi['id'])))}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Bayar',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(transaksi['total_transaksi']))}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Kasbon',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(controller.totalKasbon(transaksi['id'])))}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: textColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    const Divider(),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Total',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(transaksi['total_transaksi']))}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 12),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Close',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.MemberName(
                                                        transaksi['id_member']
                                                            .toString()) +
                                                    ' (${transaksi['no_transaksi_out']})',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${controller.MetodeName(transaksi['id_metode_pembayaran'].toString())} : ' +
                                                    formatDate(transaksi[
                                                        'input_date']),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                currencyFormat.format(int.parse(
                                                    transaksi[
                                                        'total_transaksi'])),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${transaksi['jumlah_produk']} item',
                                                style: GoogleFonts.nunito(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.kasbon.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                controller: searchControllerKasbon,
                                onChanged: (query) =>
                                    controller.searchKasbon(query),
                                decoration: InputDecoration(
                                  hintText: "Cari Kasbon...",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              var selectedKasbons =
                                  controller.getSelectedKasbons();
                              if (selectedKasbons.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Pilih Kasbon terlebih dahulu.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                child: Container(
                                                  padding: EdgeInsets.all(25),
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 255, 169, 163),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.payments,
                                                    color: Colors.red,
                                                    size: 50,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 25),
                                              Text(
                                                "Pembayaran Kasbon",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'Anda akan melunasi ${selectedKasbons.length} kasbon. Lanjutkan?',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Get.back();
                                                  controller
                                                      .pembayaranMultipleKasbon(
                                                          selectedKasbons);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Lunaskan Kasbon',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Get.back();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.grey.shade200,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Batal',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              elevation: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Agar ukuran sesuai dengan kontennya
                              children: [
                                Icon(Icons.payment,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Lunaskan Pembayaran',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Center(child: Text("Data kasbon kosong")),
                  ],
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: searchControllerKasbon,
                              onChanged: (query) =>
                                  controller.searchKasbon(query),
                              decoration: InputDecoration(
                                hintText: "Cari Kasbon...",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            var selectedKasbons =
                                controller.getSelectedKasbons();
                            if (selectedKasbons.isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Pilih Kasbon terlebih dahulu.",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              child: Container(
                                                padding: EdgeInsets.all(25),
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 255, 169, 163),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.payments,
                                                  color: Colors.red,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 25),
                                            Text(
                                              "Pembayaran Kasbon",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Anda akan melunasi ${selectedKasbons.length} kasbon. Lanjutkan?',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Get.back();
                                                controller
                                                    .pembayaranMultipleKasbon(
                                                        selectedKasbons);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Lunaskan Kasbon',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            ElevatedButton(
                                              onPressed: () async {
                                                Get.back();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey.shade200,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Batal',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 12),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Agar ukuran sesuai dengan kontennya
                            children: [
                              Icon(Icons.payment,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Lunaskan Pembayaran',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.refresh();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.kasbon.length,
                        itemBuilder: (context, index) {
                          final kasbon = controller.kasbon[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                final kasbonDetail = controller.kasbonDet
                                    .where((item) =>
                                        item['id_kasbon'].toString() ==
                                        kasbon['id'].toString())
                                    .toList();
                                if (kasbonDetail.isEmpty) {
                                  Get.snackbar(
                                    "Gagal",
                                    "Kasbon tidak memiliki detail",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.red,
                                    icon:
                                        Icon(Icons.error, color: Colors.white),
                                  );
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 8,
                                      backgroundColor: Colors.white,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // Header with transaksi number and close button
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        20, 20, 20, 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Detail Kasbon (${controller.MetodeName(kasbonDetail[0]['id_metode_pembayaran'])})',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: DarkColor()
                                                                  .red,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            'Nomor Transaksi: ${kasbonDetail[0]['no_transaksi_out']}',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.grey
                                                                  .shade700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      icon: Icon(Icons.close,
                                                          color: Colors
                                                              .grey.shade700),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 0, 20, 16),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'Nama Member: ',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        controller.MemberName(
                                                            kasbon['id_member']
                                                                .toString()),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(height: 1),
                                              ...(kasbonDetail.isEmpty
                                                  ? [
                                                      Center(
                                                        child: Text(
                                                          "Kasbon tidak memiliki detail produk",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      )
                                                    ]
                                                  : kasbonDetail[0]
                                                          ['detail_transaksi']
                                                      .map((item) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            // Gambar / Icon untuk jumlah produk
                                                            Container(
                                                              width: 42,
                                                              height: 42,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade100,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  '${item['jumlah'] ?? "0"}x', // Pastikan tidak null
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            // Informasi produk
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'Produk: ' +
                                                                        controller.ProdukName(item['id_produk'] ??
                                                                            ""),
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    'SKU: #${item['id_produk'] ?? "-"}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // Harga dan jumlah
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  'Rp ${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['harga_jual'] ?? "0") ?? 0)}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                                Text(
                                                                  '${NumberFormat('#,##0', 'id_ID').format(int.tryParse(item['jumlah'] ?? "0") ?? 0)} pcs',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList()),
                                              Divider(height: 1),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade50,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16),
                                                    bottomRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Transaksi',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(kasbonDetail[0]['total_transaksi'].toString()) + int.parse(kasbonDetail[0]['total_kasbon'].toString()))}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Total Bayar Transaksi',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade700,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(kasbonDetail[0]['total_transaksi'].toString()))}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    const Divider(),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          'Total Kasbon ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rp ${NumberFormat('#,##0', 'id_ID').format(int.parse(kasbonDetail[0]['total_kasbon'].toString()))}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                DarkColor().red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Tanggal Transaksi : ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatDate(kasbon[
                                                              'input_date']),
                                                          style: TextStyle(
                                                            fontSize: 16,
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
                                                          'Tanggal Pelunasan : ',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          formatDate(kasbon[
                                                              'tgl_pelunasan']),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 25),
                                                    const SizedBox(height: 10),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 12),
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade200,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Tutup',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Obx(() => Transform.scale(
                                              scale: 1.2,
                                              child: SizedBox(
                                                height: 15,
                                                child: Checkbox(
                                                  activeColor: Colors.green,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: controller.checkboxList
                                                              .isNotEmpty &&
                                                          index <
                                                              controller
                                                                  .checkboxList
                                                                  .length
                                                      ? controller
                                                          .checkboxList[index]
                                                      : false,
                                                  onChanged: (bool? value) {
                                                    controller.toggleCheckbox(
                                                        index, value);
                                                  },
                                                ),
                                              ),
                                            )),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.MemberName(
                                                  kasbon['id_member']
                                                      .toString()),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Tanggal Transaksi : ' +
                                                  formatDate(
                                                      kasbon['input_date']) +
                                                  ' | Tanggal Pembayaran : ' +
                                                  formatDate(
                                                      kasbon['tgl_pelunasan']),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(int.parse(kasbon['total_kasbon']))}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Tidak Lunas',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }
}
