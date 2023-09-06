import 'package:flutter/material.dart';

import '../../../models/wash_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/custom_icons.dart';
import '../../models/car.dart';
import '../../models/car_wash_offer.dart';
import '../../models/wash_order.dart';
import '../../utils/time_utils.dart';
import '../bottom_panel/bottom_titled_container.dart';
import '../map_field/map_field.dart';
import '../map_field/start_position_pin.dart';
import '../../../views/data_panel.dart';
import '../time_picker/time_picker_popup.dart';
import 'order_creation_contract.dart';
import 'order_creation_presenter.dart';

class OrderCreationPanel extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final Function(MapPosition) onOrderMade;

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
  final _startPositionPinKey = GlobalKey<StartPositionPinState>();

  @override
  void initState() {
    super.initState();
    _presenter = OrderCreationPresenter(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.mapKey.currentState!.topLayerWidgetsBuilder = () => [
        StartPositionPin(
          key: _startPositionPinKey,
          minZoom: _minZoom,
          mapKey: widget.mapKey,
          radius: 170,
        ),
      ];
      widget.mapKey.currentState!.setState(() {});
    });
  }

  @override
  void dispose() {
    widget.mapKey.currentState!.topLayerWidgetsBuilder = () => [];
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    widget.mapKey.currentState!.setState(() {});
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BottomTitledPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 55,
            child: Row(
              children: [
                Expanded(
                  child: _timePickerPanel(),
                ),
                _startSearchButton(),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _carNamesList(),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: WashService.values.length,
              itemBuilder: (BuildContext context, int index) {
                return _carServiceWidget(WashService.values[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _timePickerPanel() {
    return DataButtonPanel(
      margin: 3,
      onPressed: _showTimePicker,
      child: Row(
        children: [
          DataPanel(
            padding: 4,
            backgroundColor: AppColors.lightGrey.withOpacity(0.2),
            child: Text(
              _presenter.orderBuilder.washDay.parseToString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 6,),
          Expanded(
            child: DataPanel(
              padding: 4,
              backgroundColor: AppColors.lightGrey.withOpacity(0.2),
              child: Text(
                "${TimeUtils.formatTime(_presenter.orderBuilder.startTime)} - "
                    "${TimeUtils.formatTime(_presenter.orderBuilder.endTime)}",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTimePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimePickerPopup(
          initDay: _presenter.orderBuilder.washDay,
          initStartTime: _presenter.orderBuilder.startTime,
          initEndTime: _presenter.orderBuilder.endTime,
          onTimePicked: (startTime, endTime, day) {
            _presenter.orderBuilder.washDay = day;
            _presenter.orderBuilder.startTime = startTime;
            _presenter.orderBuilder.endTime = endTime;
            setState(() {});
          },
        );
      },
    );
  }

  Widget _carServiceWidget(WashService service) {
    bool isToggled = _presenter.orderBuilder.services.contains(service);

    return DataButtonPanel(
      margin: 3,
      backgroundColor: isToggled ? AppColors.lightOrange : AppColors.grey,
      onPressed: () {
        if (_presenter.orderBuilder.services.contains(service)) {
          _presenter.orderBuilder.deleteService(service);
        }
        else {
          _presenter.orderBuilder.addService(service);
        }
        setState(() {});
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            service.getIconData(),
            color: AppColors.dirtyWhite,
            size: 35,
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 80),
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              service.parseToString(),
              softWrap: true,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _carNamesList() {
    List<Widget> carNames = [];
    for (Car car in _presenter.cars) {
      bool isToggled = _presenter.orderBuilder.car?.number == car.number;
      carNames.add(
        Expanded(
          flex: 1,
          child: DataButtonPanel(
            backgroundColor: isToggled ? AppColors.lightOrange : AppColors.grey,
            margin: 3,
            onPressed: () {
              _presenter.orderBuilder.car = car;
              setState(() {});
            },
            child: Text(
              car.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      );
    }
    return carNames;
  }

  Widget _startSearchButton() {
    return IconButton(
      padding: const EdgeInsets.all(5),
      highlightColor: AppColors.orange.withOpacity(0.1),
      constraints: const BoxConstraints(),
      onPressed: () async {
        _presenter.orderBuilder.startPosition = await _startPositionPinKey
            .currentState!.getStartPosition();
        Future(_presenter.makeOrder).then((_) => widget.onOrderMade(
          _presenter.orderBuilder.startPosition!,
        ));
      },
      iconSize: 40,
      icon: const Icon(
        Icons.wifi_tethering_rounded,
        color: AppColors.orange,
      ),
    );
  }
}
