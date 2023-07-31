import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/car_wash_selection/car_wash_selection_page.dart';
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
    home: CarWashSelectionPage(),
  ));
}

