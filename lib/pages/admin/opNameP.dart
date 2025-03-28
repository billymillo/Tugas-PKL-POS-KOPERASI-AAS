import 'package:bluetooth_thermal_printer_example/controllers/admin/opnameC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OpNamePage extends StatefulWidget {
  @override
  _OpNamePageState createState() => _OpNamePageState();
}

class _OpNamePageState extends State<OpNamePage> {
  final AuthController logoutController = Get.put(AuthController());
  final OpnameController c = Get.put(OpnameController());
  final TextEditingController searchController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: RefreshIndicator(
                onRefresh: () async {
                  await c.refresh();
                },
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!c.isLoading.value &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        !c.isLastPage.value) {
                      c.loadMoreProducts();
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(16),
                        sliver: Obx(() {
                          if (c.isLoading.value && c.opname.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (c.opname.isEmpty) {
                            return SliverFillRemaining(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.inventory_2_outlined,
                                        size: 64, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      "Tidak Ada Produk Tersedia",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: getCrossAxisCount(context),
                              childAspectRatio: 1.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var item = c.opname[index];
                                return buildProductCard(item, context);
                              },
                              childCount: c.opname.length,
                            ),
                          );
                        }),
                      ),
                      SliverToBoxAdapter(
                        child: Obx(() {
                          if (c.isLoading.value) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  'Koperasi Anugrah Artha Abadi',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey, size: 24),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            c.searchProduct(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari Produk...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          c.searchProduct('');
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            NavbarDrawer(context, scaffoldKey),
          ],
        ),
      ),
      drawer: buildDrawer(context),
    );
  }

  Widget buildProductCard(Map<String, dynamic> item, BuildContext context) {
    bool isStockMismatch = item['stok'] != (item['stok_asli'] ?? '0');

    return Stack(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: PrimaryColor().blue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width:
                      MediaQuery.of(context).size.width * getWidthCard(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      "http://10.10.20.240/POS_CI/uploads/${item['gambar_barang']}",
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.height * 1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        item['nama_barang'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        item['kategori_name'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp ${NumberFormat('#,##0', 'id_ID').format(double.parse(item['harga_jual'].toString()))}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColor().blue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: PrimaryColor().blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Stok: ${item['stok']}',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: PrimaryColor().blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Fisik : ${item['stok_asli'] ?? '0'}',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        isStockMismatch ? "Stok Tidak Sesuai" : "Stok Sesuai",
                        style: TextStyle(
                          fontSize: 12,
                          color: isStockMismatch ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        formatDate(item['input_date']),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            showProductDetailDialog(context, item);
          },
        ),
        if (isStockMismatch)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  void showProductDetailDialog(
      BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 32, right: 32, top: 16, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Stok Opname Detail',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "http://10.10.20.240/POS_CI/uploads/${item['gambar_barang']}",
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 5,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          buildInfoRow("Nama Produk", item['nama_barang']),
                          buildInfoRow("Harga Satuan",
                              "Rp${NumberFormat('#,##0', 'id_ID').format(double.parse(item['harga_satuan'].toString()))}"),
                          buildInfoRow("Harga Jual",
                              "Rp${NumberFormat('#,##0', 'id_ID').format(double.parse(item['harga_jual'].toString()))}"),
                          buildInfoRow(
                              "Stok", item['stok'].toString() + ' pcs'),
                          buildInfoRow("Stok Asli",
                              item['stok_asli'].toString() + ' pcs'),
                          buildInfoRow("Laba",
                              "Rp${NumberFormat('#,##0', 'id_ID').format(double.parse(item['harga_jual'].toString()) - double.parse(item['harga_satuan'].toString()))}"),
                          buildInfoRow("Catatan", item['catatan'] ?? 'Kosong'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showEditDialog(
                                  context,
                                  item['id'],
                                  item['stok'] ?? '0',
                                  item['stok_asli'] ?? '0',
                                  item['catatan'] ?? '');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("Ubah Data Opname",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          Text(":", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void showEditDialog(BuildContext context, String id, String stok,
      String stokAsli, String catatan) {
    final TextEditingController stokController =
        TextEditingController(text: stok);
    final TextEditingController stokAsliController =
        TextEditingController(text: stokAsli);
    final TextEditingController catatanController =
        TextEditingController(text: catatan);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                        "Edit Stok Opname",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  buildInputLabel('Stok Barang', ''),
                  buildTextField(
                    controller: stokController,
                    hintText: 'Qty : 5',
                    prefixIcon: CupertinoIcons.cube_box_fill,
                    type: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  buildInputLabel('Stok Asli Barang', ''),
                  buildTextField(
                    controller: stokAsliController,
                    hintText: 'Qty : 5',
                    prefixIcon: CupertinoIcons.cube_box,
                    type: TextInputType.number,
                  ),
                  SizedBox(height: 15),
                  buildInputLabel('Catatan Barang', ''),
                  buildTextField(
                    controller: catatanController,
                    hintText: '5 Produk rusak',
                    prefixIcon: Icons.notes_outlined,
                    type: TextInputType.text,
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Batal',
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 12),
                      Obx(() => ElevatedButton(
                            onPressed: c.isLoading.value
                                ? null
                                : () async {
                                    c.isLoading.value =
                                        true; // Set loading ke true
                                    try {
                                      await c.editOpname(
                                          id,
                                          stokController.text,
                                          stokAsliController.text,
                                          catatanController.text);
                                      await c.fetchOpname();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      Get.snackbar("Error", e.toString());
                                    } finally {
                                      c.isLoading.value = false;
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PrimaryColor().blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: c.isLoading.value
                                ? SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Icon(CupertinoIcons.pencil,
                                          size: 18, color: Colors.white),
                                      SizedBox(width: 8),
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
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required TextInputType type,
    // controller
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

  int getCrossAxisCount(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 900) return 3; // Tablet landscape
    if (width > 600) return 2; // Tablet portrait
    return 2; // Phone
  }

  double getWidthCard(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandscape ? 0.16 : 0.2;
  }

  Color getStockColor(String stok, String stokAsli) {
    if (stok == stokAsli) return Colors.green;
    return Colors.red;
  }

  String getText(String stok, String stokAsli) {
    if (stok == stokAsli) return 'Stok Sesuai';
    return "Stok Tidak Sesuai";
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }

  // Your existing buildDrawer method remains the same
}
