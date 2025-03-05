import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class lockDeviceC extends GetxController {
  RxList<String> imageOnBoard = [
    'assets/image/lockDeviceP/ld1.png',
    'assets/image/lockDeviceP/ld2.png',
    'assets/image/lockDeviceP/ld3.png',
  ].obs;

  RxList<String> titleOnBoard = [
    'Cashflow Menjadi Teratur',
    'Pendataan Lebih Jelas',
    'Belanja kini semakin mudah dan efisien'
  ].obs;

  RxList<String> descOnBoard = [
    'Membantu mengatur cashflow supaya lebih teratur',
    'Data penjualan dan stock opname lebih jelas',
    'Proses berbelanja tidak lagi memakan banyak waktu dan tenaga'
  ].obs;

  RxInt indexOnBoard = 0.obs;
  RxList<String> inputPin =
      ['null', 'null', 'null', 'null', 'null', 'null'].obs;
  RxInt posisiInput = 0.obs;
  final String correctPin = "445377"; // PIN yang benar

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.onInit();
  }

  void addPin(String angka) {
    if (posisiInput.value < 6) {
      inputPin[posisiInput.value] = angka;
      posisiInput.value++;

      if (posisiInput.value == 6) {
        checkPin();
      }
    }
  }

  void removePin() {
    if (posisiInput.value > 0) {
      posisiInput.value--;
      inputPin[posisiInput.value] = 'null';
    }
  }

  void clearPin() {
    inputPin.value = ['null', 'null', 'null', 'null', 'null', 'null'];
    posisiInput.value = 0;
  }

  void checkPin() {
    String enteredPin = inputPin.join("");
    if (enteredPin == correctPin) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(color: PrimaryColor().blue),
        ),
        barrierDismissible: false,
      );
      Future.delayed(Duration(seconds: 2), () {
        Get.back();
        Get.offNamed(Routes.KASIRP);
      });
    } else {
      Get.snackbar(
        'Error',
        'Autentikasi gagal. Periksa kembali PIN yang Anda masukkan.',
        backgroundColor: DarkColor().red.withOpacity(0.5),
        icon: Icon(Icons.crisis_alert, color: Colors.black),
      );
      clearPin();
    }
  }
}
