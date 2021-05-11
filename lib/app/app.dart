import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:urbvan/app/screens/home_screen.dart';
import 'package:urbvan/core/controllers/app_controller.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  
  final AppController c = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urbvan Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
