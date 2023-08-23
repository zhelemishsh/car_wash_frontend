import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/account_menu/account_menu_page.dart';
import 'package:car_wash_frontend/views/login_page/login_page.dart';
import 'package:car_wash_frontend/views/main_page/main_page.dart';
import 'package:car_wash_frontend/views/sign_up_page/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    runApp(MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/main_page":
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => const MainPage(),
            );
          case "/account_menu_page":
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => const AccountMenuPage(),
            );
          case "/login_page":
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => const LoginPage(),
            );
          case "/sign_up_page":
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => const SignUpPage(),
            );
        }
        return null;
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          foregroundColor: AppColors.orange,
          color: AppColors.grey,
        ),
      ),
      title: 'Navigation Basics',
      // home: CarWashSelectionPage(),
      home: MainPage(),
    ));
  });
}

