import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminW {
  Padding metodePembayaran(metode, jumlah, transaksi, persen) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metode + ' - Rp' + jumlah,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                transaksi + ' Transaksi',
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
              )
            ],
          ),
          Text(
            persen + '%',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: PrimaryColor().blue),
          )
        ],
      ),
    );
  }

  Container laporanStock(produk) {
    return Container(
        height: 210,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          physics: ScrollPhysics(), // <-- Also change physics
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, count) {
            return Container(
                width: 155,
                margin: EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35.0),
                      child: Image(
                          width: 150,
                          height: 140,
                          image: NetworkImage(
                              "http://10.10.20.50/POS_CI/uploads/${produk[count]['gambar_barang']}")),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produk[count]['nama_barang'],
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          produk[count]['stok'].toString() + ' pcs',
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            color: PrimaryColor().blue,
                          ),
                        )
                      ],
                    ),
                  ],
                ));
          },
        ));
  }

  Container aktivitasTerbaru(namaProduk, harga, qty, noTr, tanggal) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: PrimaryColor().grey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: noTr == 'QRIS'
                            ? PrimaryColor().red
                            : noTr == 'Cash'
                                ? PrimaryColor().green
                                : PrimaryColor().blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      noTr == 'QRIS'
                          ? FontAwesomeIcons.qrcode
                          : noTr == 'Cash'
                              ? FontAwesomeIcons.moneyBill
                              : FontAwesomeIcons.wallet,
                      color: Colors.white,
                      size: 30,
                    )),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaProduk,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('$noTr ' + '($tanggal)'),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$qty pcs',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  harga,
                  style: TextStyle(color: PrimaryColor().green),
                ),
              ],
            )
          ],
        ));
  }

  void deleteDialog(BuildContext context, String title,
      String message, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 169, 163),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        onDelete();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          Text(
                            'Hapus',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Tutup dialog tanpa aksi
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
                          SizedBox(width: 8),
                          Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
  }
  void showAddOnSelectionDialog(BuildContext context, dynamic controller) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih Add On',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.addOn.map<Widget>((item) {
                    final id = item['id'];
                    final name = item['add_on'] ?? '';
                    final isSelected = controller.selectedAddOn.any((e) => e['id'] == id);

                    return GestureDetector(
                      onTap: () {
                        controller.selectAddOn(item); // toggle select/deselect
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? PrimaryColor().blue : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: PrimaryColor().blue,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : PrimaryColor().blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Ambil id dari yang dipilih
                    final selectedIds = controller.selectedAddOn.map((e) => e['id']).toList();
                    print('Selected AddOn IDs: $selectedIds');

                    // Tambahkan logic lanjutannya di sini
                    Navigator.pop(context); // Tutup dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrimaryColor().blue,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      );
    },
  );
}

  void AddOnDialog(BuildContext context, controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pilih Add On'),
          content: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            return Wrap(
              spacing: 8,
              children: controller.addOn.map<Widget>((item) {
                final addOnName = item['add_on'] ?? ' ';
                final isSelected =
                    controller.selectedAddOn.any((e) => e['id'] == item['id']);
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isSelected ? PrimaryColor().blue : Colors.white,
                    foregroundColor:
                        isSelected ? Colors.white : PrimaryColor().blue,
                    side: BorderSide(color: PrimaryColor().blue),
                  ),
                  onPressed: () {
                    controller.selectAddOn(item);
                  },
                  child: Text(
                    addOnName,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : PrimaryColor()
                              .blue, // Warna teks berdasarkan status terpilih
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        );
      },
    );
  }
}

class ClipPathDahboardAdminClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 120, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
