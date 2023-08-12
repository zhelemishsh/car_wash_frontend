import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/bottom_panel/bottom_panel.dart';
import 'package:car_wash_frontend/views/map_field/map_field.dart';
import 'package:car_wash_frontend/views/order_creation_panel/order_creation_contract.dart';
import 'package:car_wash_frontend/views/order_creation_panel/order_creation_presenter.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car.dart';
import '../../models/wash_order.dart';
import '../../theme/custom_icons.dart';
import '../map_field/search_area_circle.dart';
import '../time_picker/time_picker_popup.dart';

class OrderCreationPanel extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final Function() onOrderMade;

  const OrderCreationPanel({
    Key? key,
    required this.mapKey,
    required this.onOrderMade,
  }) : super(key: key);

  @override
  OrderCreationPanelState createState() {
    return OrderCreationPanelState();
  }
}

class OrderCreationPanelState
    extends State<OrderCreationPanel> implements OrderCreationContract{
  late OrderCreationPresenter _presenter;
  final double _minZoom = 10.5;
  final _bottomPanelKey = GlobalKey<BottomPanelState>();
  final _searchAreaCircleKey = GlobalKey<SearchAreaCircleState>();
  final List<ServiceWidgetData> _carServices = [
    ServiceWidgetData(WashService.interiorDryCleaning, CustomIcons.flask),
    ServiceWidgetData(WashService.diskCleaning, CustomIcons.disk),
    ServiceWidgetData(WashService.bodyPolishing, CustomIcons.clean),
    ServiceWidgetData(WashService.engineCleaning, CustomIcons.engine)
  ];

  @override
  void initState() {
    super.initState();
    _presenter = OrderCreationPresenter(this);
    widget.mapKey.currentState!.topLayerWidgetsBuilder = () => [
      SearchAreaCircle(
        key: _searchAreaCircleKey,
        minZoom: _minZoom,
        mapKey: widget.mapKey,
        radius: 170,
      ),
    ];
    widget.mapKey.currentState!.placemarksWidgetsBuilder = () => [];
    widget.mapKey.currentState!.setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    _bottomPanelKey.currentState?.setState(() {});
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BottomPanel(
      key: _bottomPanelKey,
      childBuilder: () => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 45,
            child: Row(
              children: [
                Expanded(flex: 5, child: _startTimeButton(),),
                Expanded(flex: 1, child: _timeDivider(),),
                Expanded(flex: 5, child: _endTimeButton(),),
                Expanded(flex: 2, child: _startSearchButton()),
              ],
            ),
          ),
          SizedBox(
            height: 32,
            child: Row(
              children: [
                Expanded(flex: 1, child: _dayButton("Today"),),
                Expanded(flex: 1, child: _dayButton("Tomorrow"),),
                Expanded(flex: 1, child: _dayButton("Day about"),),
              ],
            ),
          ),
          SizedBox(
              height: 32,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _carNamesList(),
              )
          ),
          SizedBox(
            height: 55,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _carServices.length,
              itemBuilder: (BuildContext context, int index) {
                return _carServiceWidget(_carServices[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void closeBottomPanel() async {
    await _bottomPanelKey.currentState!.closePanel();
  }

  Widget _carServiceWidget(ServiceWidgetData serviceData) {
    return _styledButton(
        isToggled: _presenter.orderBuilder.services.contains(serviceData.service),
        onPressed: () {
          if (_presenter.orderBuilder.services.contains(serviceData.service)) {
            _presenter.orderBuilder.deleteService(serviceData.service);
          }
          else {
            _presenter.orderBuilder.addService(serviceData.service);
          }
          setState(() {});
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              serviceData.iconData,
              size: 35,
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 75),
              padding: const EdgeInsets.only(left: 4),
              child: Text(serviceData.service.parseToString(), softWrap: true,),
            ),
          ],
        )
    );
  }

  List<Widget> _carNamesList() {
    List<Widget> carNames = [];
    for (Car car in _presenter.cars) {
      carNames.add(
        Expanded(
          flex: 1,
          child: _styledButton(
            onPressed: () {
              _presenter.orderBuilder.car = car;
              setState(() {});
            },
            isToggled: _presenter.orderBuilder.car?.number == car.number,
            child: Text(car.name),
          ),
        ),
      );
    }
    return carNames;
  }

  Widget _timeDivider() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "-",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _startTimeButton() {
    return _timeButton(
      time: _presenter.orderBuilder.startTime,
      onTimePicked: (TimeOfDay selectedTime) {
        try {_presenter.orderBuilder.startTime = selectedTime;}
        on Exception catch(_) {return false;}
        setState(() {});
        return true;
      },
    );
  }

  Widget _endTimeButton() {
    return _timeButton(
      time: _presenter.orderBuilder.endTime,
      onTimePicked: (TimeOfDay selectedTime) {
        try {_presenter.orderBuilder.endTime = selectedTime;}
        on Exception catch(_) {return false;}
        setState(() {});
        return true;
      },
    );
  }

  Widget _startSearchButton() {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () async {
          _presenter.orderBuilder.searchArea = await _searchAreaCircleKey
              .currentState!.getSearchArea();
          Future(_presenter.makeOrder).then((value) => widget.onOrderMade());
        },
        iconSize: 35,
        icon: const Icon(
          Icons.wifi_tethering_rounded,
        ),
      ),
    );
  }

  Widget _timeButton({
    required TimeOfDay time,
    required bool Function(TimeOfDay) onTimePicked
  }) {
    return _styledButton(
      isToggled: false,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return TimePickerPopup(
              initTime: time,
              onTimePicked: onTimePicked,
            );
          },
        );
      },
      child: Text(
        _to24hours(time),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _dayButton(String day) {
    return _styledButton(
      onPressed: () {
        _presenter.orderBuilder.washDay = day;
        setState(() {});
      },
      isToggled: _presenter.orderBuilder.washDay == day,
      child: Text(
        day,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _styledButton({
    required Widget child,
    required Function() onPressed,
    required bool isToggled,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          foregroundColor: Colors.black,
          backgroundColor: isToggled
              ? AppColors.orange
              : AppColors.lightGrey,
        ),
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          child: child,
        ),
      ),
    );
  }

  String _to24hours(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, "0");
    final min = time.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class ServiceWidgetData {
  WashService service;
  IconData iconData;

  ServiceWidgetData(this.service, this.iconData);
}