import 'package:bluetooth_thermal_printer_example/pages/admin/TipeP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/addProductP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/dashboardAdminP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/detailProdukP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/editProductP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/kategoriP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/memberP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/metodePembP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/mitraP.dart';
import 'package:bluetooth_thermal_printer_example/pages/admin/productP.dart';
import 'package:bluetooth_thermal_printer_example/pages/kasir/kasirP.dart';
import 'package:bluetooth_thermal_printer_example/pages/kasir/lockDeviceP.dart';
import 'package:bluetooth_thermal_printer_example/pages/kasir/transaksiP.dart';
import 'package:bluetooth_thermal_printer_example/pages/loginP.dart';
import 'package:bluetooth_thermal_printer_example/pages/validationP.dart';
import 'package:get/get.dart';
part 'appRoutes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.VALIDATIONP;

  static final routes = [
    GetPage(
      name: _Paths.VALIDATIONP,
      page: () => ValidationP(),
    ),
    GetPage(
      name: _Paths.KASIRP,
      page: () => KasirP(),
    ),
    GetPage(
      name: _Paths.LOCKDEVICEP,
      page: () => LockDeviceP(),
    ),
    GetPage(
      name: _Paths.LOGINP,
      page: () => LoginP(),
    ),
    GetPage(
      name: _Paths.DASHBOARDADMINP,
      page: () => DashboardAdminP(),
    ),
    GetPage(
      name: _Paths.ADDPRODUCTP,
      page: () => AddProductP(),
    ),
    GetPage(
      name: _Paths.PRODUCTP,
      page: () => ProductP(),
    ),
    GetPage(
      name: _Paths.DETAILPRODUKP,
      page: () => DetailProdukP(),
    ),
    GetPage(
      name: _Paths.EDITPRODUCTP,
      page: () => EditProductP(),
    ),
    GetPage(
      name: _Paths.KATEGORIP,
      page: () => KategoriP(),
    ),
    GetPage(
      name: _Paths.MITRAP,
      page: () => MitraP(),
    ),
    GetPage(
      name: _Paths.TIPEP,
      page: () => TipeP(),
    ),
    GetPage(
      name: _Paths.MEMBERP,
      page: () => MemberP(),
    ),
    GetPage(
      name: _Paths.METODEP,
      page: () => MetodeP(),
    ),
    GetPage(
      name: _Paths.TRANSAKSIP,
      page: () => TransaksiP(),
    ),
  ];
}
