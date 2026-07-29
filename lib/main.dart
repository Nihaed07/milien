import 'package:flutter/material.dart';
import 'package:metal_weight/bottomnav.dart';
import 'package:metal_weight/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MetalCalc Pro',
      home: SplashScreen(),
    );
  }
}