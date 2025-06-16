import 'package:bluetooth_thermal_printer_example/controllers/admin/OpNameDetC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/widgets/admin/adminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OpNameDet extends StatelessWidget {
  final OpNameDetController controller = Get.put(OpNameDetController());
  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Opname Detail',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchOpName();
          controller.fetchProduk();
        },
        child: Container(
          padding: EdgeInsets.all(16),
          color: Color(0xFFF3F4F6),
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: MediaQuery.of(context).orientation == Orientation.landscape
                  ? MediaQuery.of(context).size.width
                  : null,
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final idOpname =
                            Get.arguments?['id_opname']?.toString() ?? '';
                        final opnameItem = controller.opname.firstWhere(
                          (item) => item['id'].toString() == idOpname,
                          orElse: () => {},
                        );
                        final statusOpname = int.tryParse(
                                opnameItem['status_opname']?.toString() ??
                                    '0') ??
                            0;

                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: Colors.white,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              child: Container(
                                width: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? MediaQuery.of(context).size.width
                                    : null,
                                child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(
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
                                  columns: [
                                    DataColumn(label: Text('No')),
                                    DataColumn(
                                        label: Text('Produk',
                                            overflow: TextOverflow.ellipsis)),
                                    DataColumn(
                                        label: Text('Stok',
                                            overflow: TextOverflow.ellipsis)),
                                    DataColumn(
                                        label: Text('Stok Asli',
                                            overflow: TextOverflow.ellipsis)),
                                    DataColumn(
                                        label: Text('Harga Satuan',
                                            overflow: TextOverflow.ellipsis)),
                                    DataColumn(
                                        label: Text('Harga Jual',
                                            overflow: TextOverflow.ellipsis)),
                                    if (statusOpname != 3)
                                      DataColumn(
                                          label: Text('Aksi',
                                              overflow: TextOverflow.ellipsis)),
                                  ],
                                  rows: controller.paginatedProduk
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final index = entry.key;
                                    final realIndex = entry.key +
                                        controller.currentPage.value *
                                            controller.itemsPerPage;
                                    final produkItem = entry.value;
                                    final opnameItem =
                                        controller.opnameDet.firstWhere(
                                      (item) =>
                                          item['id_produk'].toString() ==
                                              produkItem['id'].toString() &&
                                          item['id_opname'].toString() ==
                                              idOpname,
                                      orElse: () => {},
                                    );

                                    final product = {
                                      'stok': opnameItem['stok'] ??
                                          produkItem['stok'],
                                      'stok_asli': opnameItem['stok_asli'] ??
                                          produkItem['stok_asli'],
                                      'harga_satuan':
                                          opnameItem['harga_satuan'] ??
                                              produkItem['harga_satuan'],
                                      'harga_jual': opnameItem['harga_jual'] ??
                                          produkItem['harga_jual'],
                                      'stok_input': produkItem['stok_input'],
                                      'stok_asli_input':
                                          produkItem['stok_asli_input'],
                                      'isEdit': produkItem['isEdit'],
                                      'checked': produkItem['checked'],
                                      'hasBeenSaved': opnameItem.isNotEmpty,
                                    };

                                    final isEdit = product['isEdit'] ?? false;
                                    final isChecked =
                                        product['checked'] ?? false;

                                    return DataRow(
                                      color: index % 2 == 0
                                          ? null
                                          : MaterialStateProperty.all(
                                              Color(0xFFF6F9FC)),
                                      cells: [
                                        DataCell(SizedBox(
                                          width: 30,
                                          child: Text(
                                            '${realIndex + 1}', // Ini akan menampilkan nomor urut
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        )),
                                        DataCell(SizedBox(
                                          width: 150,
                                          child: Text(
                                            produkItem['nama_barang'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        )),
                                        DataCell(product['hasBeenSaved'] == true
                                            ? SizedBox(
                                                width: 70,
                                                child: Text(
                                                    product['stok'].toString() +
                                                        ' pcs'),
                                              )
                                            : buildTextField(
                                                product['stok']?.toString() ??
                                                    '',
                                                (val) =>
                                                    produkItem['stok_input'] =
                                                        int.tryParse(val) ?? 0,
                                              )),
                                        DataCell(
                                          product['hasBeenSaved'] == true
                                              ? Text(product['stok_asli']
                                                      .toString() +
                                                  ' pcs')
                                              : buildTextField(
                                                  product['stok_asli_input']
                                                          ?.toString() ??
                                                      '',
                                                  (val) => produkItem[
                                                          'stok_asli_input'] =
                                                      int.tryParse(val) ?? 0,
                                                ),
                                        ),
                                        DataCell(Text(currencyFormat.format(
                                            int.tryParse(product['harga_satuan']
                                                    .toString()) ??
                                                0))),
                                        DataCell(Text(currencyFormat.format(
                                            int.tryParse(product['harga_jual']
                                                    .toString()) ??
                                                0))),
                                        if (statusOpname != 3)
                                          DataCell(product['hasBeenSaved'] ==
                                                  false
                                              ? ElevatedButton(
                                                  onPressed: () async {
                                                    if (product[
                                                            'hasBeenSaved'] ==
                                                        true) {
                                                      controller
                                                          .toggleEdit(index);
                                                      return;
                                                    }

                                                    if (!isEdit) {
                                                      final stok = int.tryParse(
                                                              produkItem['stok_input']
                                                                      ?.toString() ??
                                                                  '') ??
                                                          produkItem['stok'];
                                                      final stokAsli =
                                                          int.tryParse(produkItem[
                                                                          'stok_asli_input']
                                                                      ?.toString() ??
                                                                  '') ??
                                                              produkItem[
                                                                  'stok_asli'];

                                                      final catatan = '';

                                                      await controller
                                                          .addDetOpname(
                                                        produkItem['id']
                                                            .toString(),
                                                        idOpname,
                                                        stok.toString(),
                                                        stokAsli.toString(),
                                                        produkItem[
                                                                'harga_satuan']
                                                            .toString(),
                                                        produkItem['harga_jual']
                                                            .toString(),
                                                        catatan,
                                                      );

                                                      await controller
                                                          .fetchDetOpName();
                                                      await controller
                                                          .fetchProduk();
                                                    }
                                                    await controller.editOpname(
                                                        idOpname, '5');

                                                    controller
                                                        .toggleEdit(index);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        PrimaryColor().blue,
                                                    foregroundColor:
                                                        Colors.white,
                                                    textStyle: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    minimumSize: Size(0, 32),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  child: Text('Simpan'),
                                                )
                                              : Row(
                                                  children: [
                                                    Text('Selesai',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.green)),
                                                    IconButton(
                                                      onPressed: () {
                                                        showEditOpnameDialog(
                                                            context,
                                                            opnameItem);
                                                      },
                                                      icon: Icon(
                                                          Icons.edit_calendar),
                                                      color:
                                                          PrimaryColor().blue,
                                                      iconSize: 20,
                                                    )
                                                  ],
                                                )),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        color: Colors.white,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                (MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 1.3
                                    : 2.4),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () {
                                    final idOpname = Get.arguments?['id_opname']
                                            ?.toString() ??
                                        '';
                                    final opnameItem =
                                        controller.opname.firstWhere(
                                      (item) =>
                                          item['id'].toString() == idOpname,
                                      orElse: () => {},
                                    );
                                    final statusOpname = int.tryParse(
                                            opnameItem['status_opname']
                                                    ?.toString() ??
                                                '0') ??
                                        0;

                                    if (statusOpname == 3) {
                                      return SizedBox();
                                    }
                                    return Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            final idOpname =
                                                Get.arguments != null
                                                    ? Get.arguments['id_opname']
                                                            ?.toString() ??
                                                        ''
                                                    : '';
                                            AdminW().deleteDialogAlternative(
                                                context,
                                                Icons.all_inbox_rounded,
                                                'Selesaikan Opname?',
                                                'Anda akan Menyimpan seluruh item pada Opname. Lanjutkan?',
                                                'Simpan',
                                                Color.fromARGB(
                                                    255, 255, 169, 163),
                                                Colors.red, () async {
                                              await controller
                                                  .saveAllUnsavedItems(
                                                      idOpname);
                                              await controller.editOpname(
                                                  idOpname, '5');
                                              if (!controller
                                                  .isAllItemSaved(idOpname)) {
                                                Get.snackbar(
                                                  'Gagal',
                                                  'Beberapa item gagal disimpan. Silakan cek ulang.',
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.5),
                                                  icon: Icon(Icons.crisis_alert,
                                                      color: Colors.white),
                                                  colorText: Colors.white,
                                                );
                                                return;
                                              }
                                              await controller.fetchOpName();
                                              Get.back();
                                              Get.toNamed(Routes.OPNAMEP);
                                              Get.snackbar(
                                                'Success',
                                                'Berhasil Menyimpan Seluruh Opname',
                                                backgroundColor: Colors.green
                                                    .withOpacity(0.5),
                                                icon: Icon(Icons.check_circle,
                                                    color: Colors.white),
                                              );
                                            });
                                          },
                                          child: Text('Simpan Seluruh Opname'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                PrimaryColor().green,
                                            foregroundColor: Colors.white,
                                            textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                            minimumSize: Size(0, 32),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final idOpname =
                                                Get.arguments != null
                                                    ? Get.arguments['id_opname']
                                                            ?.toString() ??
                                                        ''
                                                    : '';
                                            AdminW().deleteDialog(
                                              context,
                                              'Hapus Opname',
                                              'Apakah anda yakin ingin menghapus opname ini ?',
                                              () async {
                                                await controller
                                                    .deleteOpname(idOpname);
                                                await controller.fetchOpName();
                                                Get.back();
                                                Get.toNamed(Routes.OPNAMEP);
                                              },
                                            );
                                          },
                                          child: Text('Hapus Opname'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                            minimumSize: Size(0, 32),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final idOpname =
                                                Get.arguments != null
                                                    ? Get.arguments['id_opname']
                                                            ?.toString() ??
                                                        ''
                                                    : '';
                                            AdminW().deleteDialogAlternative(
                                              context,
                                              Icons.check_circle,
                                              'Close Opname',
                                              'Apakah anda yakin ingin menutup opname ini ?',
                                              'Setuju',
                                              Color.fromARGB(
                                                  255, 162, 249, 174),
                                              Colors.green,
                                              () async {
                                                if (!controller
                                                    .isAllItemSaved(idOpname)) {
                                                  Get.snackbar(
                                                    'Gagal',
                                                    'Seluruh item harus tersimpan sebelum Opname di tutup',
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.5),
                                                    icon: Icon(
                                                        Icons.crisis_alert,
                                                        color: Colors.white),
                                                    colorText: Colors.white,
                                                  );
                                                  return;
                                                }
                                                await controller.editOpname(
                                                    idOpname, '3');
                                                await controller.fetchOpName();
                                                Get.back();
                                                Get.toNamed(Routes.OPNAMEP);
                                              },
                                            );
                                          },
                                          child: Text('Close Opname'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: PrimaryColor().red,
                                            foregroundColor: Colors.white,
                                            textStyle: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                            minimumSize: Size(0, 32),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            elevation: 0,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(width: 50),
                                Obx(() {
                                  final start = controller.startPage.value;
                                  final end = (start + 5)
                                      .clamp(0, controller.totalPages);

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: controller.previousPage,
                                        child:
                                            buildPaginationNumber('<<', false),
                                      ),
                                      ...List.generate(end - start, (index) {
                                        final pageIndex = start + index;
                                        return GestureDetector(
                                          onTap: () =>
                                              controller.goToPage(pageIndex),
                                          child: buildPaginationNumber(
                                            (pageIndex + 1).toString(),
                                            controller.currentPage.value ==
                                                pageIndex,
                                          ),
                                        );
                                      }),
                                      GestureDetector(
                                        onTap: controller.nextPage,
                                        child:
                                            buildPaginationNumber('>>', false),
                                      ),
                                    ],
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
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPaginationNumber(String label, bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? PrimaryColor().blue : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: PrimaryColor().blue),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : PrimaryColor().blue,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildTextField(String value, Function(String) onChanged) {
    final controller = TextEditingController(text: value);
    return SizedBox(
      width: 100,
      height: 36,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        onChanged: (val) {
          onChanged(val);
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
      ),
    );
  }

  void showEditOpnameDialog(BuildContext context, Map<String, dynamic> item) {
    final TextEditingController stokController =
        TextEditingController(text: item['stok']);
    final TextEditingController stokAsliController =
        TextEditingController(text: item['stok_asli'].toString());
    final TextEditingController hargaSatuanController =
        TextEditingController(text: item['harga_satuan'].toString());
    final TextEditingController hargaJualController =
        TextEditingController(text: item['harga_jual'].toString());
    final TextEditingController catatanController =
        TextEditingController(text: item['catatan'] ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          "Edit Opname",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    buildInputLabel('Stok'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: stokController,
                        cursorColor: PrimaryColor().blue,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.all_inbox_outlined,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          hintText: 'Stok',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    buildInputLabel('Stok Asli'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: stokAsliController,
                        cursorColor: PrimaryColor().blue,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.all_inbox_outlined,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          hintText: '15 pcs',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    buildInputLabel('Harga Satuan'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: hargaSatuanController,
                        cursorColor: PrimaryColor().blue,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.moneyBillWave,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          hintText: 'Rp 1.000',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    buildInputLabel('Harga Jual'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: hargaJualController,
                        cursorColor: PrimaryColor().blue,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.moneyBillWave,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          hintText: 'Rp 1.500',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    buildInputLabel('Catatan'),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        controller: catatanController,
                        cursorColor: PrimaryColor().blue,
                        minLines: 4, // Tinggi minimal 4 baris
                        maxLines: null, // Bisa terus bertambah sesuai isi
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '3 Barang Rusak...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Lanjut ke proses update
                            await controller.editDetOpname(
                              item['id'].toString(),
                              stokController.text,
                              stokAsliController.text,
                              hargaSatuanController.text,
                              hargaJualController.text,
                              catatanController.text,
                            );
                            Navigator.of(context).pop();
                            await controller.fetchDetOpName();
                            await controller.fetchProduk();
                          },
                          child: Row(
                            children: [
                              Text(
                                'Simpan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PrimaryColor().blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Batal',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget buildInputLabel(String label) {
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
      ],
    ),
  );
}

Widget buildTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData prefixIcon,
  required TextInputType type,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade50,
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: TextField(
      keyboardType: type,
      controller: controller,
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

double getResponsiveWidth(BuildContext context) {
  var orientation = MediaQuery.of(context).orientation;

  if (orientation == Orientation.portrait) {
    return MediaQuery.of(context).size.width * 0.8;
  } else {
    return MediaQuery.of(context).size.width * 0.55;
  }
}
