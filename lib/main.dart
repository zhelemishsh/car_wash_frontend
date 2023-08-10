import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/main_page/main_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
      appBarTheme: const AppBarTheme(
        color: AppColors.orange,
      ),
    ),
    title: 'Navigation Basics',
    // home: CarWashSelectionPage(),
    home: MainPage(),
  ));
}

