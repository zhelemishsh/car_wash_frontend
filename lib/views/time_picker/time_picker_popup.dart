import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../shaking_dialog/shaking_dialog.dart';

class TimePickerPopup extends StatefulWidget {
  final bool Function(TimeOfDay) onTimePicked;
  final TimeOfDay initTime;

  const TimePickerPopup({
    Key? key,
    required this.initTime,
    required this.onTimePicked
  }) : super(key: key);

  @override
  TimePickerPopupState createState() {
    return TimePickerPopupState();
  }
}

class TimePickerPopupState extends State<TimePickerPopup> {
  late String _selectedHour, _selectedMinute;
  final CarouselController _hoursController = CarouselController();
  final CarouselController _minutesController = CarouselController();
  final List<String> _hours = [];
  final List<String> _minutes = [];
  final _dialogKey = GlobalKey<ShakingDialogState>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= 23; ++i) {
      _hours.add(i.toString().padLeft(2, "0"));
    }
    for (int i = 0; i <= 59; ++i) {
      _minutes.add(i.toString().padLeft(2, "0"));
    }
    _selectedHour = widget.initTime.hour.toString();
    _selectedMinute = widget.initTime.minute.toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _hoursController.jumpToPage(int.parse(_selectedHour));
      _minutesController.jumpToPage(int.parse(_selectedMinute));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ShakingDialog(
      key: _dialogKey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Container(
        padding: const EdgeInsets.all(13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                selectionCarousel(
                    _hoursController,
                    _hours,
                    (hour) {_selectedHour = hour;}),
                Container(
                  alignment: Alignment.center,
                  height: 300,
                  width: 35,
                  child: const Text(":", style: TextStyle(fontSize: 40,),),
                ),
                selectionCarousel(
                    _minutesController,
                    _minutes,
                    (minute) {_selectedMinute = minute;}),
              ],
            ),
            IconButton(
              onPressed: () {
                var time = TimeOfDay(
                  hour: int.parse(_selectedHour),
                  minute: int.parse(_selectedMinute),
                );
                if (!widget.onTimePicked(time)) {
                  _dialogKey.currentState?.shake();
                }
                else {
                  Navigator.pop(context);
                }
              },
              iconSize: 40,
              icon: const Icon(
                Icons.done_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget selectionCarousel(
      CarouselController controller,
      List<String> items,
      Function(String) selectItem) {
    return Container(
      width: 100,
      height: 300,
      decoration: const BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(19)),
      ),
      child: CarouselSlider.builder(
        carouselController: controller,
        itemCount: items.length,
        options: CarouselOptions(
          enlargeCenterPage: true,
          viewportFraction: 0.2,
          scrollDirection: Axis.vertical,
          enlargeFactor: 0.35,
          onPageChanged: (index, reason) {
            selectItem(items[index]);
          }
        ),
        itemBuilder: (context, index, a) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              items[index],
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          );
        },
      ),
    );
  }
}
