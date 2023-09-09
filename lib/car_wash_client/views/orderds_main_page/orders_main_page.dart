import 'package:car_wash_frontend/car_wash_client/views/car_wash_menu/car_wash_menu_page.dart';
import 'package:car_wash_frontend/car_wash_client/views/orderds_main_page/bottom_navigation_panel.dart';
import 'package:car_wash_frontend/car_wash_client/views/orderds_main_page/page_navigatrion_button.dart';
import 'package:car_wash_frontend/car_wash_client/views/pending_orders_page/pending_orders_page.dart';
import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/circle_button.dart';
import 'package:car_wash_frontend/views/data_panel.dart';
import 'package:flutter/material.dart';

class OrderMainPage extends StatefulWidget {
  const OrderMainPage({Key? key}) : super(key: key);

  @override
  OrderMainPageState createState() {
    return OrderMainPageState();
  }
}

class OrderMainPageState extends State<OrderMainPage> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 70,
        // color: Colors.transparent,
        child: _bottomNavigationPanel(),
      ),
      appBar: AppBar(),
      backgroundColor: AppColors.dirtyWhite,
      body: PageView(
        controller: _pageController,
        children: [
          const CarWashMenuPage(),
          const PendingOrdersPage(),
          Container(
            alignment: Alignment.center,
            child: Text("Free time"),
          ),
        ],
      ),
    );
  }

  Widget _appBarPanel() {
    return Row(
      children: [
        _menuButton(),
        Expanded(child: _pendingOrdersButton()),
        Expanded(child: _acceptedOrdersButton()),
      ],
    );
  }

  Widget _menuButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: CircleButton(
        size: 40,
        iconData: Icons.menu_rounded,
        onPressed: () {
          // Navigator.pushNamed(context, "/account_menu_page");
        },
      ),
    );
  }

  Widget _pendingOrdersButton() {
    return DataButtonPanel(
      margin: 3,
      onPressed: () { },
      backgroundColor: AppColors.black,
      child: Text("В ожидании"),
    );
  }

  Widget _acceptedOrdersButton() {
    return DataButtonPanel(
      margin: 3,
      onPressed: () { },
      backgroundColor: AppColors.black,
      child: Text("Принятые"),
    );
  }

  Widget _bottomNavigationPanel() {
    return BottomNavigationPanel(
      navigationPageController: _pageController,
      navigationButtonsData: [
        NavigationButtonData(Icons.menu_rounded, "Профиль"),
        NavigationButtonData(Icons.schedule_rounded, "Заказы в ожидании"),
        NavigationButtonData(Icons.done_rounded, "Принятые заказы"),
      ],
    );
  }
}
