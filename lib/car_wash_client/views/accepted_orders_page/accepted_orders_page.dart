import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:car_wash_frontend/car_wash_client/models/accepted_client_order.dart';
import 'package:car_wash_frontend/models/car_type.dart';
import 'package:car_wash_frontend/models/was_day.dart';
import 'package:car_wash_frontend/models/wash_service.dart';
import 'package:car_wash_frontend/utils/time_utils.dart';
import 'package:car_wash_frontend/views/ask_dialog.dart';
import 'package:car_wash_frontend/views/data_panel.dart';
import 'package:flutter/material.dart';

import '../../../models/car.dart';
import '../../../theme/app_colors.dart';
import '../../../views/marked_list.dart';
import 'accepted_orders_contract.dart';
import 'accepted_orders_presenter.dart';

class AcceptedOrdersPage extends StatefulWidget {
  const AcceptedOrdersPage({Key? key}) : super(key: key);

  @override
  AcceptedOrdersPageState createState() {
    return AcceptedOrdersPageState();
  }
}

class AcceptedOrdersPageState extends State<AcceptedOrdersPage>
    implements AcceptedOrdersContract {
  late AcceptedOrdersPresenter _presenter;

  @override
  void initState() {
    _presenter = AcceptedOrdersPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ImplicitlyAnimatedList(
        items: _presenter.orders,
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, item, index) {
          return SizeFadeTransition(
            sizeFraction: 0.7,
            curve: Curves.easeInOut,
            animation: animation,
            child: _orderPanel(item),
          );
        },
      ),
    );
  }

  Widget _orderPanel(AcceptedClientOrder order) {
    return DataPanel(
      borderRadius: 13,
      margin: 3,
      backgroundColor: AppColors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _userDataPanel(order),
          _servicesList(order),
          _bottomPanel(order),
        ],
      ),
    );
  }

  Widget _bottomPanel(AcceptedClientOrder order) {
    return Row(
      children: [
        _pricePanel(order),
        Expanded(child: _clientTimePanel(order),),
        _actionButton(
          iconData: Icons.close_rounded,
          buttonColor: AppColors.darkRed,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AskDialog(
                  text: "Отменить предложение?",
                  onConfirmed: () {
                    _presenter.cancelOffer(order);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _clientTimePanel(AcceptedClientOrder order) {
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

  Widget _actionButton({
    required IconData iconData,
    required Color buttonColor,
    required onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: buttonColor,
        size: 30,
      ),
    );
  }

  Widget _servicesList(AcceptedClientOrder order) {
    return DataPanel(
      margin: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkedList(
            iconSize: 20,
            textStyle: Theme.of(context).textTheme.titleSmall,
            markedTexts: order.services.map((service) {
              return MarkedTextData(
                text: service.parseToString(),
                iconData: Icons.water_drop_rounded,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _pricePanel(AcceptedClientOrder order) {
    return DataPanel(
      margin: 3,
      child: _markedText(
        textStyle: Theme.of(context).textTheme.titleMedium,
        iconData: Icons.currency_ruble_rounded,
        text: order.price.toString(),
      ),
    );
  }

  Widget _userDataPanel(AcceptedClientOrder order) {
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userImagePanel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image:  AssetImage("assets/kiruha.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _mainInfoPanel(AcceptedClientOrder order) {
    return DataPanel(
      margin: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _userInfoPanel(order),
          _markedText(
            iconData: Icons.phone_rounded,
            text: order.clientPhoneNumber,
          ),
          _carInfoPanel(order.clientCar),
        ],
      ),
    );
  }

  Widget _carInfoPanel(Car car) {
    return Row(
      children: [
        Expanded(
          child: _markedText(
            iconData: car.type.carIcon(),
            text: car.name,
          ),
        ),
        _carNumberPanel(car.number)
      ],
    );
  }

  Widget _carNumberPanel(String carNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppColors.lightGrey.withOpacity(0.2),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.titleSmall,
          children: [
            TextSpan(
              text: carNumber[0],
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
            ),
            TextSpan(
              text: carNumber.substring(1, 4),
            ),
            TextSpan(
              text: carNumber.substring(4, 6),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
            ),
            TextSpan(
              text: carNumber.substring(6, carNumber.length),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userInfoPanel(AcceptedClientOrder order) {
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

  @override
  updatePage() {
    setState(() {});
  }
}