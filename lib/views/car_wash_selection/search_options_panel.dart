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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: timeButton(_startTime, (TimeOfDay selectedTime) {
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
              },),
              flex: 5,
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "-",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Expanded(
              child: timeButton(_endTime, (TimeOfDay selectedTime) {
                if (isTimeBefore(selectedTime, _startTime)) {
                  return false;
                }
                _endTime = selectedTime;
                setState(() {});
                return true;
              },),
              flex: 5,),
            Expanded(
              flex: 2,
              child: IconButton(
                onPressed: widget.onSearchButtonPressed,
                icon: const Icon(
                  Icons.wifi_tethering_rounded,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7,),
        Row(
          children: [
            Expanded(flex: 1, child: dayButton("Today"),),
            const SizedBox(width: 5,),
            Expanded(flex: 1, child: dayButton("Tomorrow"),),
            const SizedBox(width: 5,),
            Expanded(flex: 1, child: dayButton("Day about"),),
          ],
        ),
      ],
    );
  }

  Widget timeButton(TimeOfDay time, bool Function(TimeOfDay) onTimePicked) {
    return SizedBox(
      height: 40,
      child: TextButton(
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
        style: textButtonStyle(false),
        child: Text(
          to24hours(time),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }

  Widget dayButton(String day) {
    return SizedBox(
      height: 25,
      child: TextButton(
        onPressed: () {
          _selectedDay = day;
          setState(() {});
        },
        style: textButtonStyle(_selectedDay == day),
        child: Text(
          day,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }

  ButtonStyle textButtonStyle(bool isToggled) {
    return TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.all(4),
        foregroundColor: Colors.black,
        backgroundColor: isToggled
            ? AppColors.orange
            : AppColors.lightGrey
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
