import 'package:car_wash_frontend/car_wash_client/views/pending_orders_page/pending_orders_presenter.dart';
import 'package:car_wash_frontend/car_wash_client/views/pending_orders_page/time_border_panel.dart';
import 'package:car_wash_frontend/models/car_type.dart';
import 'package:car_wash_frontend/models/was_day.dart';
import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/utils/time_utils.dart';
import 'package:car_wash_frontend/views/data_panel.dart';
import 'package:car_wash_frontend/views/marked_list.dart';
import 'package:flutter/material.dart';
import 'package:progress_border/progress_border.dart';

import '../../../models/wash_service.dart';
import '../../models/client_order.dart';

class PendingOrdersPage extends StatefulWidget {
  const PendingOrdersPage({Key? key}) : super(key: key);

  @override
  PendingOrdersPageState createState() {
    return PendingOrdersPageState();
  }
}

class PendingOrdersPageState extends State<PendingOrdersPage> {
  late PendingOrdersPresenter _presenter;

  @override
  void initState() {
    _presenter = PendingOrdersPresenter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ListView.builder(
        itemCount: _presenter.orders.length,
        itemBuilder: (context, index) {
          return _orderTimerPanel(_presenter.orders[index]);
        },
      ),
    );
  }

  Widget _mainInfoPanel(ClientOrder order) {
    return DataPanel(
      margin: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userInfoPanel(order),
          _markedText(
            iconData: Icons.drive_eta_rounded,
            text: order.clientCar.type.parseToString(),
          ),
        ],
      ),
    );
  }

  Widget _orderResultParamsPanel(ClientOrder order) {
    return DataPanel(
      margin: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _comparePanel(
            selfValue: order.price,
            bestValue: order.bestPrice,
            bestText: "Лучшая цена: ",
            iconData: Icons.currency_ruble_rounded,
          ),
          _comparePanel(
              selfValue: order.duration,
              bestValue: order.bestDuration,
              bestText: "Лучшее время: ",
              iconData: Icons.schedule_rounded,
              textSuffix: "мин."
          ),
        ],
      ),
    );
  }

  Widget _userInfoPanel(ClientOrder order) {
    return Row(
      children: [
        Expanded(
          child: Text(
            order.clientName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _markedText(
          iconData: Icons.star_rounded,
          text: order.clientRating.toString(),
          rightIcon: true,
        ),
      ],
    );
  }

  Widget _userDataPanel(ClientOrder order) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: _userImagePanel(),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _mainInfoPanel(order),
                _orderResultParamsPanel(order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomPanel(ClientOrder order) {
    return Row(
      children: [
        Expanded(child: _clientTimePanel(order),),
        _actionButton(Icons.close_rounded, AppColors.darkRed),
        _actionButton(Icons.done_rounded, AppColors.yesGreen),
      ],
    );
  }

  Widget _userImagePanel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image:  AssetImage("assets/kiruha.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _clientTimePanel(ClientOrder order) {
    return DataPanel(
      margin: 3,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Text(
              order.day.parseToString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const VerticalDivider(color: AppColors.lightGrey,),
            Expanded(
              child: Text(
                "${TimeUtils.formatTime(order.startTime)} - ${TimeUtils.formatTime(order.endTime)}",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Widget _actionButton(IconData iconData, Color buttonColor) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        iconData,
        color: buttonColor,
        size: 30,
      ),
    );
  }

  Widget _comparePanel({
    required double selfValue,
    required double bestValue,
    required String bestText,
    required IconData iconData,
    String textSuffix = "",
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child : _markedText(
            iconData: iconData,
            text: "$selfValue $textSuffix",
          ),
        ),
        DataPanel(
          padding: 0,
          margin: 2,
          backgroundColor: AppColors.lightGrey.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bestText,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                    "$bestValue",
                  style: bestValue < selfValue
                      ? Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.lightRed)
                      : Theme.of(context).textTheme.titleSmall,
                ),
              ],
            )
          ),
        ),
      ],
    );
  }

  Widget _orderTimerPanel(ClientOrder order) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: TimeBorderPanel(
        startSecond: 0,
        fullDuration: 60,
        onTimerFinished: () {
          _presenter.orders.removeWhere((o) => o == order);
          setState(() {});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _userDataPanel(order),
            _servicesList(order.services),
            _bottomPanel(order),
          ],
        ),
      ),
    );
  }

  Widget _servicesList(List<WashService> services) {
    return DataPanel(
      margin: 3,
      child: MarkedList(
        iconSize: 20,
        textStyle: Theme.of(context).textTheme.titleSmall,
        markedTexts: services.map((service) {
          return MarkedTextData(
            text: service.parseToString(),
            iconData: Icons.water_drop_rounded,
          );
        }).toList(),
      ),
    );
  }

  Widget _markedText({
    required IconData iconData,
    required String text,
    double iconSize = 20,
    TextStyle? textStyle,
    bool rightIcon = false,
  }) {
    Widget textWidget = Text(
      text,
      style: textStyle ?? Theme.of(context).textTheme.titleSmall,
    );
    Widget icon = Icon(iconData, size: iconSize, color: AppColors.orange,);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        rightIcon ? textWidget : icon,
        const SizedBox(width: 5,),
        rightIcon ? icon : textWidget,
      ],
    );
  }
}
