import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/account_menu/account_menu_page.dart';
import 'package:car_wash_frontend/views/bottom_panel/bottom_panel.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_selection_panel.dart';
import 'package:car_wash_frontend/views/order_creation_panel/order_creation_panel.dart';
import 'package:flutter/material.dart';

import '../accepted_order_panel/accepted_order_panel.dart';
import '../map_field/map_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key,}) : super(key: key);

  @override
  MainPageState createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  final _mapKey = GlobalKey<MapFieldState>();
  final _bottomPanelKey = GlobalKey<BottomPanelState>();
  OrderState _orderState = OrderState.orderCreation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _mapKey.currentState!.onCameraPositionChanged.add((_, isFinished) {
        _onMapCameraPositionChanged(isFinished);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mapField = MapField(key: _mapKey,);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: _appBarPanel(),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          mapField,
          BottomPanel(
            key: _bottomPanelKey,
            child: _orderStateWidget(),
          ),
        ],
      ),
    );
  }

  Widget _appBarPanel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _menuButton(),
        ),
        _descriptionPanel(),
        Align(
          alignment: Alignment.centerRight,
          child: _userPositionButton(),
        )
      ],
    );
  }

  Widget _descriptionPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(0, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        _descriptionText(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _userPositionButton() {
    return _topPanelButton(
      iconData: Icons.near_me_rounded,
      onPressed: () {
        _mapKey.currentState?.moveCameraToUser(11);
      },
    );
  }

  Widget _menuButton() {
    return _topPanelButton(
      iconData: Icons.menu_rounded,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountMenuPage()),
        );
      },
    );
  }

  Widget _topPanelButton({
    required IconData iconData,
    required Function() onPressed
  }) {
    double buttonSize = 40;
    return SizedBox(
      height: buttonSize,
      width: buttonSize,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          padding: const EdgeInsets.all(8),
          backgroundColor: AppColors.grey,
          foregroundColor: AppColors.orange,
        ),
        child: Icon(
          iconData,
          color: AppColors.dirtyWhite,
        ),
      ),
    );
  }

  void _onMapCameraPositionChanged(bool isFinished) {
    if (isFinished) {
      Future.delayed(const Duration(milliseconds: 300))
          .then((_) => _bottomPanelKey.currentState!.openBottomPanel());
    }
    else {
      _bottomPanelKey.currentState!.closeBottomPanel();
    }
  }

  Widget _orderStateWidget() {
    switch (_orderState) {
      case OrderState.orderCreation:
        return OrderCreationPanel(
          mapKey: _mapKey,
          onOrderMade: () {
            _orderState = OrderState.offerSelection;
            _reopenBottomPanel();
          },
        );
      case OrderState.offerSelection:
        return OfferSelectionPanel(
          mapKey: _mapKey,
          onOfferSelected: () {
            _orderState = OrderState.waitingForWash;
            _reopenBottomPanel();
          },
        );
      case OrderState.waitingForWash:
        return AcceptedOrderPanel(
          mapKey: _mapKey,
        );
    }
  }

  void _reopenBottomPanel() {
    Future(_bottomPanelKey.currentState!.closeBottomPanel).then((_) {
      setState(() {});
      _bottomPanelKey.currentState!.openBottomPanel();
    });
  }

  String _descriptionText() {
    switch (_orderState) {
      case OrderState.orderCreation:
        return "Select order options";
      case OrderState.offerSelection:
        return "Choose a car wash offer";
      case OrderState.waitingForWash:
        return "Order waiting for you";
    }
  }
}

enum OrderState {
  orderCreation, offerSelection, waitingForWash
}