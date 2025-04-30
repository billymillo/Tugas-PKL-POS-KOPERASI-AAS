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
                          image: NetworkImage("http://10.10.20.172/POS_CI/uploads/${produk[count]['gambar_barang']}")),
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
