import 'package:bluetooth_thermal_printer_example/models/colorPalleteModel.dart';
import 'package:bluetooth_thermal_printer_example/routes/appPages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // onGenerateRoute: (settings) {
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return NotFoundRoute();
      //     },
      //   );
      // },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: PrimaryColor().blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white),
      darkTheme: ThemeData(primarySwatch: Colors.grey),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
    );
  }
}
