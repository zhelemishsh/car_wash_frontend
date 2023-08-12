import 'package:car_wash_frontend/models/wash_order.dart';
import 'package:car_wash_frontend/views/stateless_views/marked_list.dart';
import 'package:car_wash_frontend/views/stateless_views/rounded_icon_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/time_utils.dart';
import '../bottom_panel/bottom_panel.dart';
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
  final _bottomPanelKey = GlobalKey<BottomPanelState>();
  late AcceptedOrderPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = AcceptedOrderPresenter();
    widget.mapKey.currentState!.topLayerWidgetsBuilder = () => [];
    widget.mapKey.currentState!.placemarksWidgetsBuilder = () => [];
  }

  @override
  Widget build(BuildContext context) {
    return BottomPanel(
      key: _bottomPanelKey,
      childBuilder: () {
        return Table(
          columnWidths:  const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5,),
                  child: _carWashPositionPanel(),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, left: 5),
                    child: _actionButtons(),
                  ),
                ),
              ]
            ),
            TableRow(
              children: [
                _orderInfoPanel(),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.fill,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: _imagePanel(),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void setState(VoidCallback fn) {
    _bottomPanelKey.currentState?.setState(() {});
    widget.mapKey.currentState?.setState(() {});
    super.setState(fn);
  }

  Widget _imagePanel() {
    return Container(
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
    return MarkedList(
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
    );
  }

  Widget _actionButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _styledTextButton(Icons.route_rounded, AppColors.orange),
        Padding(
          padding: const EdgeInsets.only(left: 5,),
          child: _styledTextButton(Icons.delete_rounded, AppColors.darkRed),
        ),
      ],
    );
  }

  Widget _styledTextButton(IconData iconData, Color iconColor) {
    return SizedBox(
      width: 58,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          backgroundColor: AppColors.lightGrey,
          foregroundColor: iconColor,
          iconColor: Colors.black,
        ),
        onPressed: () {},
        child: Icon(
          iconData,
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }

  Widget _orderInfoPanel() {
    return MarkedList(
      size: 25,
      markedTexts: [
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
}