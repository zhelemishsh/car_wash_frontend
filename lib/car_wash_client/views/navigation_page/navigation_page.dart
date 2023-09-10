import 'package:car_wash_frontend/car_wash_client/views/accepted_orders_page/accepted_orders_page.dart';
import 'package:car_wash_frontend/car_wash_client/views/car_wash_menu/car_wash_menu_page.dart';
import 'package:car_wash_frontend/car_wash_client/views/pending_orders_page/pending_orders_page.dart';
import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/ask_dialog.dart';
import 'package:flutter/material.dart';

import 'bottom_navigation_panel.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  NavigationPageState createState() {
    return NavigationPageState();
  }
}

class NavigationPageState extends State<NavigationPage> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        elevation: 0,
        height: 70,
        // color: Colors.transparent,
        child: _bottomNavigationPanel(),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: _onExitButtonPressed,
          icon: const Icon(
            Icons.logout_rounded,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _onSupportButtonPressed,
            icon: const Icon(
              Icons.question_mark_rounded,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.dirtyWhite,
      body: PageView(
        controller: _pageController,
        children: [
          const CarWashMenuPage(),
          const PendingOrdersPage(),
          const AcceptedOrdersPage(),
          Container(
            alignment: Alignment.center,
            child: Text("Статистика"),
          )
        ],
      ),
    );
  }

  Widget _bottomNavigationPanel() {
    return BottomNavigationPanel(
      navigationPageController: _pageController,
      navigationButtonsData: [
        NavigationButtonData(Icons.menu_rounded, "Профиль"),
        NavigationButtonData(Icons.notifications_rounded, "Заказы в ожидании"),
        NavigationButtonData(Icons.done_rounded, "Принятые заказы"),
        NavigationButtonData(Icons.leaderboard_rounded, "Статистика"),
      ],
    );
  }

  void _onExitButtonPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AskDialog(
          text: "Выйти из профиля?",
          onConfirmed: () {},
        );
      },
    );
  }

  void _onSupportButtonPressed() {
  }
}
