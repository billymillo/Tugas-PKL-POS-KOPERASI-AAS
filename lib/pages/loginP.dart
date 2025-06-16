import 'package:bluetooth_thermal_printer_example/controllers/authC.dart';
import 'package:bluetooth_thermal_printer_example/controllers/loginC.dart';
import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/widgets/loginW.dart';
import 'package:bluetooth_thermal_printer_example/widgets/notFoundW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class LoginP extends StatelessWidget {
  LoginP({super.key});
  final AuthController authController = Get.put(AuthController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    loginC c = Get.put(loginC());
    final screenHeight = MediaQuery.of(context).size.height;

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
                          color: PrimaryColor().blue,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          alignment: Alignment.bottomRight,
                                          image: AssetImage(
                                              'assets/image/loginP/bg.png'),
                                          fit: BoxFit.cover),
                                    ),
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Center(
                                      child: Text(
                                    'Koperasi Anugrah Artha Abadi',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w200),
                                  ))),
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 100),
                          color: PrimaryColor().grey,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/image/aas_logo.png",
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 12),
                                    labelStyle: TextStyle(fontSize: 12),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: PrimaryColor().blue,
                                          width: 0.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    labelText: 'Username',
                                    hintText: 'Username'),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                    hintStyle: TextStyle(fontSize: 12),
                                    labelStyle: TextStyle(fontSize: 12),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: PrimaryColor().blue,
                                          width: 0.0),
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    labelText: 'Password',
                                    hintText: 'Password'),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              GestureDetector(
                                onTap: () {
                                  authController.login(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: PrimaryColor().blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Obx(() =>
                                      authController.isLoading.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white))
                                          : Text(
                                              'Masuk',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            )),
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    )
                  : MediaQuery.of(context).size.width >
                          MediaQuery.of(context).size.height
                      ? Row(
                          children: [
                            Expanded(
                                child: Container(
                              color: PrimaryColor().blue,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              alignment: Alignment.bottomRight,
                                              image: AssetImage(
                                                  'assets/image/loginP/bg.png'),
                                              fit: BoxFit.cover),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Center(
                                          child: Text(
                                        'Koperasi Anugrah Artha Abadi',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w200),
                                      ))),
                                ],
                              ),
                            )),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 100),
                              color: PrimaryColor().grey,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/aas_logo.png",
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 12),
                                        labelStyle: TextStyle(fontSize: 12),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: PrimaryColor().blue,
                                              width: 0.0),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        labelText: 'Username',
                                        hintText: 'Username'),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 12),
                                        labelStyle: TextStyle(fontSize: 12),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: PrimaryColor().blue,
                                              width: 0.0),
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        labelText: 'Password',
                                        hintText: 'Password'),
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      authController.login(
                                        usernameController.text,
                                        passwordController.text,
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 13),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: PrimaryColor().blue,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Obx(() => authController
                                              .isLoading.value
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                  color: Colors.white))
                                          : Text(
                                              'Masuk',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            )),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          ],
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                color: PrimaryColor().blue,
                                width: MediaQuery.of(context).size.width,
                                height: screenHeight < 700
                                    ? screenHeight * 0.45
                                    : screenHeight * 0.4,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/image/loginP/bg.png'),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: PrimaryColor().blue,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              bottom: 100,
                                              left: 50,
                                              right: 50,
                                              top: 100),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Silakan Login Terlebih Dahulu',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                'Pastikan mengisi data dengan benar',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                              SizedBox(height: 30),
                                              TextField(
                                                controller: usernameController,
                                                style: TextStyle(fontSize: 11),
                                                decoration: InputDecoration(
                                                  hintStyle:
                                                      TextStyle(fontSize: 11),
                                                  labelStyle:
                                                      TextStyle(fontSize: 11),
                                                  prefixIcon: Icon(
                                                    FontAwesomeIcons.user,
                                                    color: PrimaryColor().blue,
                                                    size: 15,
                                                  ),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 15,
                                                          vertical: 15),
                                                  labelText: 'Username',
                                                  hintText: 'Username',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              TextField(
                                                controller: passwordController,
                                                obscureText: true,
                                                style: TextStyle(fontSize: 11),
                                                decoration: InputDecoration(
                                                  hintStyle:
                                                      TextStyle(fontSize: 11),
                                                  labelStyle:
                                                      TextStyle(fontSize: 11),
                                                  prefixIcon: Icon(
                                                    FontAwesomeIcons.lock,
                                                    color: PrimaryColor().blue,
                                                    size: 15,
                                                  ),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 15,
                                                          vertical: 15),
                                                  labelText: 'Password',
                                                  hintText: 'Password',
                                                ),
                                              ),
                                              SizedBox(height: 40),
                                              GestureDetector(
                                                onTap: () {
                                                  authController.login(
                                                    usernameController.text,
                                                    passwordController.text,
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          PrimaryColor().blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Obx(() => authController
                                                          .isLoading.value
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                  color: Colors
                                                                      .white))
                                                      : Text(
                                                          'Masuk',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                ),
                                              ),
                                              SizedBox(height: 50),
                                              Center(
                                                child: Text(
                                                  'Koperasi Anugrah Artha Abadi',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w200),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: ClipPath(
                                            clipper: ClipPathLoginClass(),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: PrimaryColor().blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
        ],
      ),
    );
  }
}
