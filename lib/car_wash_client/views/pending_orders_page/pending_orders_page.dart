import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/views/data_panel.dart';
import 'package:car_wash_frontend/views/marked_list.dart';
import 'package:flutter/material.dart';

import '../../../models/wash_service.dart';

class PendingOrdersPage extends StatefulWidget {
  const PendingOrdersPage({Key? key}) : super(key: key);

  @override
  PendingOrdersPageState createState() {
    return PendingOrdersPageState();
  }
}

class PendingOrdersPageState extends State<PendingOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return _orderPanel();
        },
      ),
    );
  }

  Widget _orderPanel() {
    return DataPanel(
      margin: 3,
      backgroundColor: AppColors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _userDataPanel(),
          _servicesList([WashService.diskCleaning, WashService.engineCleaning]),
          _bottomPanel(),
        ],
      )
    );
  }

  Widget _mainInfoPanel() {
    return DataPanel(
      margin: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userInfoPanel(),
          _markedText(
            iconData: Icons.drive_eta_rounded,
            text: "Легковая машина",
          ),
        ],
      ),
    );
  }

  Widget _orderResultParamsPanel() {
    return DataPanel(
      margin: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _comparePanel(
            selfValue: 200,
            bestValue: 100,
            bestText: "Лучшая цена: ",
            iconData: Icons.currency_ruble_rounded,
          ),
          _comparePanel(
              selfValue: 50,
              bestValue: 60,
              bestText: "Лучшее время: ",
              iconData: Icons.schedule_rounded,
              textSuffix: "мин."
          ),
        ],
      ),
    );
  }

  Widget _userInfoPanel() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Гошан",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _markedText(
          iconData: Icons.star_rounded,
          text: "4.01",
          rightIcon: true,
        ),
      ],
    );
  }

  Widget _userDataPanel() {
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
                _mainInfoPanel(),
                _orderResultParamsPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomPanel() {
    return Row(
      children: [
        Expanded(child: _clientTimePanel(TimeOfDay.now(), TimeOfDay.now()),),
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
          image:  AssetImage("assets/goshan.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  Widget _clientTimePanel(TimeOfDay startTime, TimeOfDay endTime) {
    return DataPanel(
      margin: 3,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "12:20 - 13:40",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      )
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
