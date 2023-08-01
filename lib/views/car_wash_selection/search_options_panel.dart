import 'package:car_wash_frontend/theme/custom_icons.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../time_picker/time_picker_popup.dart';

class SearchOptionsPanel extends StatefulWidget {
  final Function() onSearchButtonPressed;

  const SearchOptionsPanel({
    Key? key,
    required this.onSearchButtonPressed,
  }) : super(key: key);

  @override
  SearchOptionsPanelState createState() {
    return SearchOptionsPanelState();
  }
}

class SearchOptionsPanelState extends State<SearchOptionsPanel> {
  String _selectedDay = "Today";
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  List<ServiceIcon> carServices = [
    ServiceIcon(CustomIcons.flask, "Interior dry cleaning"),
    ServiceIcon(CustomIcons.disk, "Disk cleaning"),
    ServiceIcon(CustomIcons.clean, "Body polishing"),
    ServiceIcon(CustomIcons.engine, "Engine cleaning")
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
            itemCount: carServices.length,
            itemBuilder: (BuildContext context, int index) {
              return  styledButton(
                isToggled: false,
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      carServices[index].iconData,
                      size: 35,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 75),
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(carServices[index].serviceName, softWrap: true,),
                    ),
                  ],
                )
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> carNamesList() {
    List<String> cars = ["Mercedes-Benz A", "BMW X7 M60i"];
    List<Widget> carNames = [];
    for (String car in cars) {
      carNames.add(
        Expanded(
          flex: 1,
          child: styledButton(
            onPressed: () {},
            isToggled: false,
            child: Text(car),
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
      time: _startTime,
      onTimePicked: (TimeOfDay selectedTime) {
        if (_selectedDay == "Today"
            && isTimeBefore(selectedTime, TimeOfDay.now())) {
          return false;
        }
        _startTime = selectedTime;
        if (isTimeBefore(_endTime, _startTime)) {
          _endTime = _startTime;
        }
        setState(() {});
        return true;
      },
    );
  }

  Widget endTimeButton() {
    return timeButton(
      time: _endTime,
      onTimePicked: (TimeOfDay selectedTime) {
        if (isTimeBefore(selectedTime, _startTime)) {
          return false;
        }
        _endTime = selectedTime;
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
        _selectedDay = day;
        setState(() {});
      },
      isToggled: _selectedDay == day,
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

  bool isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    return time1.hour < time2.hour
        || (time1.hour == time2.hour
            && time1.minute < time2.minute);
  }
}

class ServiceIcon {
  IconData iconData;
  String serviceName;

  ServiceIcon(this.iconData, this.serviceName);
}
