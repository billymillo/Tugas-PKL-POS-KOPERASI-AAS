import 'package:bluetooth_thermal_printer_example/controllers/validationC.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ValidationP extends StatelessWidget {
  const ValidationP({super.key});

  @override
  Widget build(BuildContext context) {
    ValidationC c = Get.put(ValidationC());
    return Container(
      color: Colors.white,
      child: Column(
        children: [
            Lottie.asset("assets/lottie/store.json"),
        ],
      ),
    );
  }
}
