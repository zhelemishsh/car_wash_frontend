import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/models/wash_order.dart';
import 'package:car_wash_frontend/views/stateless_views/marked_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../theme/app_colors.dart';
import '../../utils/time_utils.dart';
import '../map_field/map_field.dart';
import 'accepted_order_presenter.dart';

class AcceptedOrderPanel extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;

  const AcceptedOrderPanel({
    Key? key,
    required this.mapKey,
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
    widget.mapKey.currentState!.routeBuilder = () => null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths:  const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            _carWashPositionPanel(),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: _actionButtons(),
            ),
          ],
        ),
        TableRow(
          children: [
            _orderInfoPanel(),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: _imagePanel(),
            ),
          ],
        )
      ],
    );
  }

  @override
  void setState(VoidCallback fn) {
    widget.mapKey.currentState?.setState(() {});
    super.setState(fn);
  }

  Widget _imagePanel() {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image:  AssetImage("assets/goshan.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _carWashPositionPanel() {
    return Container(
      margin: const EdgeInsets.all(3),
      child: MarkedList(
        size: 25,
        markedTexts: [
          MarkedTextData(
            text: _presenter.order.carWashName,
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
          MarkedTextData(
            text: _presenter.order.carWashAddress,
            textStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _styledTextButton(
          iconData: Icons.route_rounded,
          iconColor: AppColors.routeBlue,
          onPressed: () {
            _isRouteCreated = true;
            setState(() {});
          },
        ),
        _styledTextButton(
          iconData: Icons.delete_rounded,
          iconColor: AppColors.darkRed,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _styledTextButton({
    required IconData iconData,
    required Color iconColor,
    required Function() onPressed
  }) {
    return Container(
      width: 58,
      margin: const EdgeInsets.all(3),
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          backgroundColor: AppColors.dirtyWhite,
          foregroundColor: iconColor,
          iconColor: Colors.black,
        ),
        onPressed: onPressed,
        child: Icon(
          iconData,
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }

  Widget _orderInfoPanel() {
    return Container(
      margin: const EdgeInsets.all(3),
      child: MarkedList(
        size: 25,
        markedTexts: [
          MarkedTextData(
            text: DateFormat.MMMMd('en_US').format(_presenter.order.startTime),
            iconData: Icons.calendar_month_rounded,
          ),
          MarkedTextData(
            text: "${TimeUtils.formatDateTime(_presenter.order.startTime)} - "
                "${TimeUtils.formatDateTime(_presenter.order.endTime)}",
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
          MarkedTextData(
            text: _serviceListString(),
            iconData: Icons.settings_rounded,
          ),
        ],
      ),
    );
  }

  String _serviceListString() {
    String result = "";
    for (int i = 0; i < _presenter.order.services.length; ++i) {
      result += i == 0
          ? _presenter.order.services[i].parseToString()
          : _presenter.order.services[i].parseToString().toLowerCase();
      if (i != _presenter.order.services.length - 1) {
        result += ", ";
      }
    }
    return result;
  }

  Widget _placemarkWidget() {
    return const Icon(
      Icons.location_on_rounded,
      color: AppColors.orange,
      size: 70,
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
        position: Point(
          latitude: _presenter.order.carWashPosition.latitude,
          longitude: _presenter.order.carWashPosition.longitude,
        ),
        offset: const Offset(0.5, 0.87),
        onPressed: () {},
      ),
    ];
  }

  MapPosition? _buildRoute() {
    if (_isRouteCreated) {
      return _presenter.order.carWashPosition;
    }
    return null;
  }
}