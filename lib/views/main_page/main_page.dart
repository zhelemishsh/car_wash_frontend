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
      body: Stack(
        children: [
          mapField,
          BottomPanel(
            key: _bottomPanelKey,
            child: _orderStateWidget(),
          ),
          _menuButton(),
          _userPositionButton(),
        ],
      ),
    );
  }

  Widget _menuButton() {
    return Positioned(
      top: 30,
      left: 10,
      child: FloatingActionButton.small(
        heroTag: "menu button",
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(
          Icons.menu_rounded,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountMenuPage()),
          );
        },
      )
    );
  }

  void _onMapCameraPositionChanged(bool isFinished) {
    if (isFinished) {
      Future.delayed(const Duration(milliseconds: 200))
          .then((_) => _bottomPanelKey.currentState!.openBottomPanel());
    }
    else {
      _bottomPanelKey.currentState!.closeBottomPanel();
    }
  }

  Widget _userPositionButton() {
    return Positioned(
        top: 30,
        right: 10,
        child: FloatingActionButton.small(
          heroTag: "user position button",
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: const Icon(
            Icons.near_me_rounded,
          ),
          onPressed: () {
            _mapKey.currentState?.moveCameraToUser(10);
          },
        )
    );
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
}

enum OrderState {
  orderCreation, offerSelection, waitingForWash
}