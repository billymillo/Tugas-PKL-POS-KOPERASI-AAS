import 'package:bluetooth_thermal_printer_example/controllers/admin/OpNameC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/widgets/navAdminW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OpNamePage extends StatefulWidget {
  @override
  _OpNamePageState createState() => _OpNamePageState();
}

class _OpNamePageState extends State<OpNamePage> {
  final AuthController logoutController = Get.put(AuthController());
  final OpNameController controller = Get.put(OpNameController());
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
            Container(
              padding: const EdgeInsets.only(top: 90, left: 20, right: 20),
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var status = 4;
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
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
                                            color: Color.fromARGB(
                                                255, 163, 171, 255),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.all_inbox_rounded,
                                            color: PrimaryColor().blue,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      Text(
                                        "Tambah Opname",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Anda akan membuat data baru Opname. Lanjutkan?',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          Get.back();
                                          await controller
                                              .addOpname(status.toString());
                                          await controller.fetchOpName();
                                          controller.isLoading.value = false;
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
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
                                              'Buat Opname',
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
                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey.shade200,
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
                                                color: Colors.black54,
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 30),
                        SizedBox(width: 8),
                        Text(
                          'Tambah Opname',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    return Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: controller.opname.length,
                          itemBuilder: (context, index) {
                            final item = controller.opname[index];
                            Color textColor = item['status_opname'] == '4'
                                ? Colors.red
                                : Colors.green;
                            return Card(
                              margin: const EdgeInsets.only(top: 15),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () async {
                                  controller.isLoading.value = true;
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                  controller.isLoading.value = false;
                                  Get.toNamed(
                                    Routes.OPNAMEDET,
                                    arguments: {
                                      'id_opname': item['id']
                                    }, // bukan 'id_opname', tapi 'id'
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
                                                '${item['no_opname']}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                formatTanggal(item['tanggal']),
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
                                                '${controller.statusName(item['status_opname'].toString())}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${item['user_input']}',
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
                          }),
                    );
                  })
                ],
              ),
            ),
            NavbarDrawer(context, scaffoldKey),
            Obx(() {
              return controller.isLoading.value
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
      drawer: buildDrawer(context),
    );
  }

  String formatTanggal(String tanggal) {
    try {
      final parsedDate = DateTime.parse(tanggal);
      final formatter = DateFormat('d MMMM y, HH:mm', 'id_ID');
      return formatter.format(parsedDate);
    } catch (e) {
      return tanggal; // fallback jika gagal parsing
    }
  }
}
