import 'dart:async';

import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/account_menu/account_menu_page.dart';
import 'package:car_wash_frontend/views/car_wash_selection/car_wash_selection_contract.dart';
import 'package:car_wash_frontend/views/car_wash_selection/car_wash_selection_presenter.dart';
import 'package:car_wash_frontend/views/car_wash_selection/map_panel.dart';
import 'package:car_wash_frontend/views/car_wash_selection/search_options_panel.dart';
import 'package:car_wash_frontend/views/car_wash_selection/wash_offers_panel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CarWashSelectionPage extends StatefulWidget {
  const CarWashSelectionPage({Key? key}) : super(key: key);

  @override
  CarWashSelectionPageState createState() {
    return CarWashSelectionPageState();
  }
}

class CarWashSelectionPageState
    extends State<CarWashSelectionPage>
    implements CarWashSelectionContract {
  late CarWashSelectionPresenter _presenter;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _mapKey = GlobalKey<MapPanelState>();
  final _washOffersPanelKey = GlobalKey<WashOffersPanelState>();
  bool isBottomPanelOpened = true;
  Uint8List? image;

  @override
  void initState() {
    super.initState();
    _presenter = CarWashSelectionPresenter(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showSearchOptionsPanel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          MapPanel(
            key: _mapKey,
            offers: _presenter.getOffers(),
            onMapTouched: () {
              if (Navigator.canPop(context)) {
                hideBottomPanel();
              }
            },
          ),
          Positioned(
            left: 15,
            top: 30,
            child: accountMenuButton(),
          ),
          Positioned(
            right: 15,
            bottom: 15,
            child: Container(
              child: bottomPanelButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget accountMenuButton() {
    return FloatingActionButton.small(
      backgroundColor: Colors.white,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => const AccountMenuPage())
        );
      },
      child: const Icon(
        Icons.menu_rounded,
        size: 27,
        color: Colors.black,
      ),
    );
  }

  Widget? bottomPanelButton() {
    if (isBottomPanelOpened) return null;

    IconData iconData;
    Function() onPressed = showBottomPanel;
    switch (_presenter.getSearchState()) {
      case SearchState.loading:
        return null;
      case SearchState.optionsSelection:
        iconData = Icons.edit_rounded;
        break;
      case SearchState.offersShowing:
        iconData = Icons.format_list_bulleted_rounded;
        break;
      case SearchState.offerSelected:
        iconData = Icons.local_car_wash_rounded;
        break;
    }

    return FloatingActionButton.small(
      backgroundColor: Colors.white,
      onPressed: onPressed,
      child: Icon(
        iconData,
        size: 27,
        color: Colors.black,
      ),
    );
  }

  void makeBottomPanel(Widget childWidget) {
    isBottomPanelOpened = true;
    _scaffoldKey.currentState?.showBottomSheet(
          (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                spreadRadius: 2,
                blurRadius: 14,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: childWidget,
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      enableDrag: false,
    );
    updatePage();
  }

  void showSearchOptionsPanel() {
    makeBottomPanel(
      SearchOptionsPanel(
        onSearchButtonPressed: () {
          _presenter.loadWashOffers();
        },
      ),
    );
  }

  @override
  void hideBottomPanel() {
    isBottomPanelOpened = false;
    Navigator.pop(context);
    updatePage();
  }

  @override
  void showBottomPanel() {
    switch (_presenter.getSearchState()) {
      case SearchState.optionsSelection:
        showSearchOptionsPanel();
        break;
      case SearchState.offersShowing:
        showWashOffersPanel();
        break;
      case SearchState.offerSelected:
        break;
      case SearchState.loading:
        break;
    }
  }

  void showWashOffersPanel() {
    makeBottomPanel(
      WashOffersPanel(
        key: _washOffersPanelKey,
        offers: _presenter.getOffers(),
        onOfferSelected: (CarWashOffer selectedOffer) {
          _presenter.sendWashAgreement(selectedOffer);
        },
      )
    );
  }

  void showAcceptedWashOffer() {
    // TODO: implement showAcceptedWashOffer
  }

  @override
  void updatePage() {
    setState(() {});
  }

  @override
  void updateWashOffers() {
    _washOffersPanelKey.currentState?.updatePage();
    _mapKey.currentState?.updatePage();
  }
}