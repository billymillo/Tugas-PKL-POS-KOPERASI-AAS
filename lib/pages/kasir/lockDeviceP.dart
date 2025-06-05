import 'package:bluetooth_thermal_printer_example/controllers/kasir/lockDeviceC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:bluetooth_thermal_printer_example/widgets/kasir/lockDeviceW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/notFoundW.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LockDeviceP extends StatelessWidget {
  const LockDeviceP({super.key});
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });

    lockDeviceC c = Get.put(lockDeviceC());
    return Scaffold(
      backgroundColor: PrimaryColor().grey,
      body: Stack(
        children: [
          SingleChildScrollView(
              child: MediaQuery.of(context).size.width > 1000
                  ? Row(
                      children: [
                        Expanded(
                            child: Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    onPageChanged: (index, reason) {
                                      c.indexOnBoard.value = index;
                                    },
                                  ),
                                  items: [
                                    for (var i = 0;
                                        i < c.titleOnBoard.length;
                                        i++)
                                      LockDeviceW().OnBoard(c.imageOnBoard[i],
                                          c.titleOnBoard[i], c.descOnBoard[i])
                                  ],
                                ),
                              ),
                              Obx(() => Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: AnimatedSmoothIndicator(
                                        activeIndex: c.indexOnBoard.value,
                                        count: c.titleOnBoard.length,
                                        effect: WormEffect(
                                            dotWidth: 10, dotHeight: 10),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 130),
                          color: PrimaryColor().grey,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/image/aas_logo.png",
                                width: 100,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Masukkan PIN',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'PIN diperlukan untuk masuk ke dalam sistem kasir',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Obx(() => Wrap(
                                    spacing: 7,
                                    children: [
                                      for (var i = 0;
                                          i < c.inputPin.length;
                                          i++)
                                        LockDeviceW().PinInput(c.inputPin[
                                            i]), // Sekarang ini akan update otomatis!
                                    ],
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 15,
                                  runSpacing: 15,
                                  children: [
                                    LockDeviceW().PinNumber('1', null, () {
                                      c.addPin('1');
                                    }),
                                    LockDeviceW().PinNumber('2', null, () {
                                      c.addPin('2');
                                    }),
                                    LockDeviceW().PinNumber('3', null, () {
                                      c.addPin('3');
                                    }),
                                    LockDeviceW().PinNumber('4', null, () {
                                      c.addPin('4');
                                    }),
                                    LockDeviceW().PinNumber('5', null, () {
                                      c.addPin('5');
                                    }),
                                    LockDeviceW().PinNumber('6', null, () {
                                      c.addPin('6');
                                    }),
                                    LockDeviceW().PinNumber('7', null, () {
                                      c.addPin('7');
                                    }),
                                    LockDeviceW().PinNumber('8', null, () {
                                      c.addPin('8');
                                    }),
                                    LockDeviceW().PinNumber('9', null, () {
                                      c.addPin('9');
                                    }),
                                    LockDeviceW().PinNumber(
                                        null, FontAwesomeIcons.circleXmark, () {
                                      c.clearPin();
                                    }),
                                    LockDeviceW().PinNumber('0', null, () {
                                      c.addPin('0');
                                    }),
                                    LockDeviceW().PinNumber(
                                        null, FontAwesomeIcons.deleteLeft, () {
                                      c.removePin();
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    )
                  : Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 1,
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning_amber_rounded,
                                  size: 80, color: Colors.orange),
                              SizedBox(height: 24),
                              Text(
                                "Maaf, device Anda tidak cocok dengan lebar layar yang dituju.",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Aplikasi ini direkomendasikan untuk tablet atau tampilan potrait.",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 32),
                              GestureDetector(
                                child: Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 10),
                                                  child: Container(
                                                    padding: EdgeInsets.all(25),
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 255, 169, 163),
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
                                                SizedBox(height: 20),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder:
                                                          (BuildContext context) {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      },
                                                    );
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    await prefs
                                                        .remove('is_login');
                                                    await prefs
                                                        .remove('user_name');
                                                    Get.offAllNamed(
                                                        Routes.LOGINP);
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
                                                        'Logout',
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
                                                SizedBox(height: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
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
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                  )),
        ],
      ),
    );
  }
}
