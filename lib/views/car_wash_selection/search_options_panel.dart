import 'package:car_wash_frontend/models/wash_order.dart';
import 'package:car_wash_frontend/theme/custom_icons.dart';
import 'package:flutter/material.dart';

import '../../models/car.dart';
import '../../theme/app_colors.dart';
import '../time_picker/time_picker_popup.dart';

class SearchOptionsPanel extends StatefulWidget {
  final Function() onSearchButtonPressed;
  final WashOrderBuilder orderBuilder;

  const SearchOptionsPanel({
    Key? key,
    required this.orderBuilder,
    required this.onSearchButtonPressed,
  }) : super(key: key);

  @override
  SearchOptionsPanelState createState() {
    return SearchOptionsPanelState();
  }
}

class SearchOptionsPanelState extends State<SearchOptionsPanel> {
  final List<ServiceWidgetData> _carServices = [
    ServiceWidgetData(WashService.interiorDryCleaning, CustomIcons.flask, "Interior dry cleaning"),
    ServiceWidgetData(WashService.diskCleaning, CustomIcons.disk, "Disk cleaning"),
    ServiceWidgetData(WashService.bodyPolishing, CustomIcons.clean, "Body polishing"),
    ServiceWidgetData(WashService.engineCleaning, CustomIcons.engine, "Engine cleaning")
  ];

  final List<Car> _cars = [
    Car("1", "Mercedes-Benz A"), Car("2", "BMW X7 M60i"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 45,
          child: Row(
            children: [
              Expanded(flex: 5, child: startTimeButton(),),
              Expanded(flex: 1, child: timeDivider(),),
              Expanded(flex: 5, child: endTimeButton(),),
              Expanded(flex: 2, child: startSearchButton()),
            ],
          ),
        ),
        SizedBox(
          height: 32,
          child: Row(
            children: [
              Expanded(flex: 1, child: dayButton("Today"),),
              Expanded(flex: 1, child: dayButton("Tomorrow"),),
              Expanded(flex: 1, child: dayButton("Day about"),),
            ],
          ),
        ),
        SizedBox(
          height: 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: carNamesList(),
          )
        ),
        SizedBox(
          height: 55,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _carServices.length,
            itemBuilder: (BuildContext context, int index) {
              return carServiceWidget(_carServices[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget carServiceWidget(ServiceWidgetData serviceData) {
    return styledButton(
        isToggled: widget.orderBuilder.services.contains(serviceData.service),
        onPressed: () {
          if (widget.orderBuilder.services.contains(serviceData.service)) {
            widget.orderBuilder.deleteService(serviceData.service);
          }
          else {
            widget.orderBuilder.addService(serviceData.service);
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
              child: Text(serviceData.serviceName, softWrap: true,),
            ),
          ],
        )
    );
  }

  List<Widget> carNamesList() {
    List<Widget> carNames = [];
    for (Car car in _cars) {
      carNames.add(
        Expanded(
          flex: 1,
          child: styledButton(
            onPressed: () {
              widget.orderBuilder.car = car;
              setState(() {});
            },
            isToggled: widget.orderBuilder.car?.number == car.number,
            child: Text(car.name),
          ),
        ),
      );
    }

    return carNames;
  }

  Widget timeDivider() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "-",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget startTimeButton() {
    return timeButton(
      time: widget.orderBuilder.startTime,
      onTimePicked: (TimeOfDay selectedTime) {
        try {widget.orderBuilder.startTime = selectedTime;}
        on Exception catch(_) {return false;}
        setState(() {});
        return true;
      },
    );
  }

  Widget endTimeButton() {
    return timeButton(
      time: widget.orderBuilder.endTime,
      onTimePicked: (TimeOfDay selectedTime) {
        try {widget.orderBuilder.endTime = selectedTime;}
        on Exception catch(_) {return false;}
        setState(() {});
        return true;
      },
    );
  }

  Widget startSearchButton() {
    return IconButton(
      onPressed: widget.onSearchButtonPressed,
      icon: const Icon(
        Icons.wifi_tethering_rounded,
        size: 35,
      ),
    );
  }

  Widget timeButton({
    required TimeOfDay time,
    required bool Function(TimeOfDay) onTimePicked
  }) {
    return styledButton(
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
        to24hours(time),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget dayButton(String day) {
    return styledButton(
      onPressed: () {
        widget.orderBuilder.washDay = day;
        setState(() {});
      },
      isToggled: widget.orderBuilder.washDay == day,
      child: Text(
        day,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget styledButton({
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

  String to24hours(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, "0");
    final min = time.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class ServiceWidgetData {
  WashService service;
  IconData iconData;
  String serviceName;

  ServiceWidgetData(this.service, this.iconData, this.serviceName);
}
