import 'package:car_wash_frontend/user_client/models/car_wash_offer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../models/wash_service.dart';
import '../../../theme/app_colors.dart';
import '../../../views/ask_dialog.dart';
import '../../../views/data_panel.dart';
import '../../../views/marked_list.dart';
import '../../utils/route_utils.dart';
import '../bottom_panel/bottom_titled_container.dart';
import '../map_field/map_field.dart';
import '../../../views/circle_button.dart';
import 'accepted_order_presenter.dart';

class AcceptedOrderPanel extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final Function() onOrderCanceled;

  const AcceptedOrderPanel({
    Key? key,
    required this.mapKey,
    required this.onOrderCanceled,
  }) : super(key: key);

  @override
  AcceptedOrderPanelState createState() {
    return AcceptedOrderPanelState();
  }
}

class AcceptedOrderPanelState extends State<AcceptedOrderPanel> {
  late AcceptedOrderPresenter _presenter;
  bool _isRouteCreated = false;

  @override
  void initState() {
    super.initState();

    _presenter = AcceptedOrderPresenter();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.mapKey.currentState!.placemarksWidgetsBuilder = _buildPlacemarks;
      widget.mapKey.currentState!.routeBuilder = _buildRoute;
      widget.mapKey.currentState!.setState(() {});
    });
  }

  @override
  void dispose() {
    widget.mapKey.currentState!.placemarksWidgetsBuilder = () => [];
    widget.mapKey.currentState!.routeBuilder = () async => null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomTitledPanel(
      title: CircleButton(
        backgroundColor: AppColors.darkRed,
        iconData: Icons.clear_rounded,
        size: 40,
        onPressed: _showOrderCancelDialog,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _topPanel(),
          _bottomPanel(),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    widget.mapKey.currentState?.setState(() {});
    super.setState(fn);
  }

  Widget _topPanel() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: _carWashInfoPanel(),
          ),
          _imagePanel(),
        ],
      ),
    );
  }

  Widget _bottomPanel() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _offerInfoPanel(),
          ),
          Expanded(
            child: _washInfoPanel(),
          ),
        ],
      ),
    );
  }

  void _showOrderCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AskDialog(
          text: "Отказаться от предложения?",
          onConfirmed: () {
            _presenter.cancelOrder();
            widget.onOrderCanceled();
          },
        );
      },
    );
  }

  Widget _imagePanel() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            image:  AssetImage("assets/goshan.jpg"),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }

  Widget _carWashInfoPanel() {
    return DataPanel(
      margin: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _carWashMainInfoPanel(),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: MarkedList(
              textStyle: Theme.of(context).textTheme.titleSmall,
              mainAxisSize: MainAxisSize.max,
              iconSize: 23,
              markedTexts: [
                MarkedTextData(
                  text: _presenter.order.carWashNumber,
                  iconData: Icons.phone_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _carWashMainInfoPanel() {
    return DataPanel(
      backgroundColor: AppColors.lightGrey.withOpacity(0.2),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _presenter.order.carWashName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                _presenter.order.carWashAddress,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _offerInfoPanel() {
    return DataPanel(
      margin: 3,
      child: MarkedList(
        textStyle: Theme.of(context).textTheme.titleSmall,
        mainAxisSize: MainAxisSize.max,
        iconSize: 23,
        markedTexts: [
          MarkedTextData(
            text: DateFormat('dd.MM.yy').format(_presenter.order.startTime),
            iconData: Icons.calendar_month_rounded,
          ),
          MarkedTextData(
            text: "${DateFormat.Hm().format(_presenter.order.startTime)} - "
                "${DateFormat.Hm().format(_presenter.order.endTime)}",
            iconData: Icons.schedule_rounded,
          ),
          MarkedTextData(
            text: _presenter.order.price.toString(),
            iconData: Icons.currency_ruble_rounded,
          ),
          MarkedTextData(
            text: _presenter.order.car.name,
            iconData: Icons.directions_car_rounded,
          ),
        ],
      ),
    );
  }

  Widget _washInfoPanel() {
    List<MarkedTextData> markedList = _presenter.order.services.map(
        (service) => MarkedTextData(
          text: service.parseToString(),
          iconData: Icons.water_drop,
        ),
    ).toList();

    return DataPanel(
      margin: 3,
      child: MarkedList(
        textStyle: Theme.of(context).textTheme.titleSmall,
        mainAxisSize: MainAxisSize.max,
        iconSize: 23,
        markedTexts: markedList,
      ),
    );
  }

  Widget _placemarkWidget() {
    return const Icon(
      Icons.location_on_rounded,
      color: AppColors.orange,
      size: 40,
      shadows: [
        Shadow(
          color: Color.fromRGBO(0, 0, 0, 0.4),
          offset: Offset(0, 0),
          blurRadius: 6,
        ),
      ],
    );
  }

  List<PlacemarkData> _buildPlacemarks() {
    return [
      PlacemarkData(
        widget: _placemarkWidget(),
        position: _presenter.order.carWashPosition.toPoint(),
        offset: const Offset(0.5, 0.87),
        onPressed: () {
          _isRouteCreated = true;
          setState(() {});
        },
      ),
    ];
  }

  Future<DrivingRoute?> _buildRoute() async {
    if (_isRouteCreated) {
      return RouteUtils.makeRoute(
        await widget.mapKey.currentState!.getUserPosition(),
        _presenter.order.carWashPosition,
      );
    }
    return null;
  }
}