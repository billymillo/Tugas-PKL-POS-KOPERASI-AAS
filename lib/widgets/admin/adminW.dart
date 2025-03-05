import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          itemCount: 3,
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
                          image: NetworkImage(produk[count]['image'])),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produk[count]['nama'],
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          produk[count]['stock'].toString() + ' pcs',
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
        )
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       namaProduk,
        //       style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'Tanggal Masuk',
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //         Text(
        //           tanggalMasuk,
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'Jumlah Masuk',
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //         Text(
        //           jumlahMasuk,
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'Jumlah Keluar',
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //         Text(
        //           jumlahKeluar,
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           'Sisa Stock',
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //         Text(
        //           sisaStock,
        //           style: TextStyle(fontWeight: FontWeight.w200, fontSize: 17),
        //         ),
        //       ],
        //     ),
        //   ],
        // )
        );
  }

  Container aktivitasTerbaru(namaProduk, harga, qty, metode, tanggalPembelian) {
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
                        color: metode == 'QRIS'
                            ? PrimaryColor().red
                            : metode == 'Cash'
                                ? PrimaryColor().green
                                : PrimaryColor().blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      metode == 'QRIS'
                          ? FontAwesomeIcons.qrcode
                          : metode == 'Cash'
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
                      'Golda Coffee',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Aldilan - 2 hari yang lalu'),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '7 pcs',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp.7000',
                  style: TextStyle(color: PrimaryColor().green),
                ),
              ],
            )
          ],
        ));
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
