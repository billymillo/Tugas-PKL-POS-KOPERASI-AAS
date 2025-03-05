import 'package:bluetooth_thermal_printer_example/controllers/kasir/lockDeviceC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/kasir/lockDeviceW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/notFoundW.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
                                    for (var i = 0; i < c.inputPin.length; i++)
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
                : NotFoundW().Error404(context),
          ),
        ],
      ),
    );
  }
}
