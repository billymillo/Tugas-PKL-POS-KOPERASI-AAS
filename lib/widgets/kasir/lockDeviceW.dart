import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LockDeviceW {
  Container OnBoard(foto, title, desc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(foto),
            width: 300,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            desc,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Container PinInput(String hasil) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: hasil == 'null' ? PrimaryColor().blue : PrimaryColor().blue,
        ),
        color: hasil == 'null' ? Colors.white : PrimaryColor().blue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          hasil == 'null'
              ? FontAwesomeIcons.circle
              : FontAwesomeIcons.solidCircleDot,
          size: 15,
          color: hasil == 'null' ? PrimaryColor().blue : Colors.white,
        ),
      ),
    );
  }

  GestureDetector PinNumber(
      String? angka, IconData? icon, VoidCallback inputNumber) {
    RxBool isPressed = false.obs;

    return GestureDetector(
      onTapDown: (_) => isPressed.value = true,
      onTapUp: (_) {
        isPressed.value = false;
        inputNumber();
      },
      onTapCancel: () => isPressed.value = false,
      child: Obx(() => Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Colors.black38,
              ),
              color: isPressed.value
                  ? PrimaryColor().blue
                  : (icon == null ? Colors.white : PrimaryColor().blue),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: icon == null
                  ? Text(
                      angka!,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  : Icon(
                      icon,
                      size: 15,
                      color: Colors.white,
                    ),
            ),
          )),
    );
  }
}
