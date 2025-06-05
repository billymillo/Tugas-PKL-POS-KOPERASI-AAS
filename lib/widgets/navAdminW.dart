import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/validationC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

Widget buildDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/image/aas_logo.png",
                width: 100,
              ),
            ],
          ),
        ),
        drawerItem(
          icon: Icons.storefront,
          title: "Beranda",
          routeName: Routes.DASHBOARDADMINP,
        ),
        Container(
          child: ExpansionTile(
            leading: Icon(Icons.inventory_2_outlined, color: DarkColor().grey),
            title: Text("Barang", style: TextStyle(color: DarkColor().grey)),
            iconColor: DarkColor().grey,
            childrenPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 0),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              drawerItem(
                icon: Icons.fastfood_outlined,
                title: "List",
                routeName: Routes.PRODUCTP,
              ),
              drawerItem(
                icon: Icons.add_to_photos_outlined,
                title: "Add On",
                routeName: Routes.ADDONP,
              ),
            ],
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
          ),
        ),
        Container(
          child: ExpansionTile(
            leading:
                Icon(Icons.my_library_add_outlined, color: DarkColor().grey),
            title: Text("Library", style: TextStyle(color: DarkColor().grey)),
            iconColor: DarkColor().grey,
            childrenPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 0),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              drawerItem(
                icon: Icons.category_outlined,
                title: "Kategori",
                routeName: Routes.KATEGORIP,
              ),
              drawerItem(
                icon: FontAwesomeIcons.peopleArrows,
                title: "Mitra",
                routeName: Routes.MITRAP,
              ),
              drawerItem(
                icon: Icons.people_outlined,
                title: "Tipe",
                routeName: Routes.TIPEP,
              ),
            ],
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
          ),
        ),
        drawerItem(
          icon: Icons.person_outline_sharp,
          title: "Stok Opname",
          routeName: Routes.OPNAMEP,
        ),
        Container(
          child: ExpansionTile(
            leading: Icon(FontAwesomeIcons.moneyBillTransfer,
                color: DarkColor().grey),
            title: Text("Transaksi", style: TextStyle(color: DarkColor().grey)),
            iconColor: DarkColor().grey,
            childrenPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 0),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              drawerItem(
                icon: Icons.turn_left_outlined,
                title: "Transaksi In",
                routeName: Routes.TRANSAKSIINP,
              ),
              drawerItem(
                icon: Icons.turn_right_outlined,
                title: "Transaksi In Mitra",
                routeName: Routes.TRANSAKSIINMITRAP,
              ),
              drawerItem(
                icon: Icons.fork_right_rounded,
                title: "Transaksi Out Mitra",
                routeName: Routes.TRANSAKSIOUTMITRAP,
              ),
            ],
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
          ),
        ),
        drawerItem(
          icon: Icons.insert_chart_outlined_sharp,
          title: "Reporting",
          routeName: Routes.REPORTINGP,
        ),
        drawerItem(
          icon: CupertinoIcons.person_alt,
          title: "Member",
          routeName: Routes.MEMBERP,
        ),
        drawerItem(
          icon: FontAwesomeIcons.gear,
          title: "Settings",
          routeName: Routes.METODEP,
        ),
      ],
    ),
  );
}

Widget NavbarDrawer(
    BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  final AuthController logoutController = Get.put(AuthController());
  return Container(
    height: 70,
    decoration: BoxDecoration(
      color: DarkColor().blue,
    ),
    padding: EdgeInsets.symmetric(
      horizontal: 30,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          color: DarkColor().grey,
        ),
        Row(
          children: [
            GestureDetector(
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: DarkColor().grey,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: SingleChildScrollView(
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
                                        color:
                                            Color.fromARGB(255, 255, 169, 163),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.logout_outlined,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Apakah anda yakin untuk melakukan Logout?",
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
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      );
                                      await logoutController.logout();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 8),
                                        Text(
                                          'Logout',
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
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(width: 25),
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  "https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg"),
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ],
    ),
    width: double.infinity,
  );
}

Widget drawerItem(
    {required IconData icon,
    required String title,
    required String routeName}) {
  bool isActive = Get.currentRoute == routeName;
  return Container(
    decoration: BoxDecoration(
      color: isActive
          ? Colors.blue.shade900
          : Colors.transparent, // Background biru jika aktif
      borderRadius: BorderRadius.circular(10), // Membuat border radius
    ),
    child: ListTile(
      leading: Icon(icon,
          color: isActive
              ? Colors.white
              : DarkColor().grey), // Ikon putih jika aktif
      title: Text(
        title,
        style: TextStyle(
            color: isActive
                ? Colors.white
                : DarkColor().grey), // Teks putih jika aktif
      ),
      onTap: () {
        Get.toNamed(routeName);
      },
    ),
  );
}
