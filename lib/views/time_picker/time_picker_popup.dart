import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/utils/time_utils.dart';
import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../shaking_dialog/shaking_dialog.dart';

class TimePickerPopup extends StatefulWidget {
  final bool Function(TimeOfDay) onTimePicked;
  final TimeOfDay initStartTime;
  final TimeOfDay initEndTime;
  final String initDay;

  const TimePickerPopup({
    Key? key,
    required this.initDay,
    required this.initStartTime,
    required this.initEndTime,
    required this.onTimePicked,
  }) : super(key: key);

  @override
  TimePickerPopupState createState() {
    return TimePickerPopupState();
  }
}

class TimePickerPopupState extends State<TimePickerPopup> {
  final CarouselController _startTimesController = CarouselController();
  final CarouselController _endTimesController = CarouselController();
  final List<TimeOfDay> _startTimes = [];
  final List<TimeOfDay> _endTimes = [];
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  final _dialogKey = GlobalKey<ShakingDialogState>();
  final List<String> _days = ["Сегодня", "Завтра", "Послезавтра"];
  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initDay;
    _selectedStartTime = widget.initStartTime;
    _selectedEndTime = widget.initEndTime;

    _initStartTimes((_) => false);
    _initEndTimes((_) => false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimesController.jumpToPage(
        _endTimes.indexWhere((time) => time == _selectedStartTime),
      );
      _endTimesController.jumpToPage(
        _endTimes.indexWhere((time) => time == _selectedEndTime),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: _dialogKey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(11),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _timeRangePanel(),
            _dateSelectionPanel(),
            _acceptButton(),
          ],
        ),
      ),
    );
  }

  Widget _acceptButton() {
    return DataButtonPanel(
      splashColor: AppColors.dirtyWhite,
      height: 45,
      margin: 3,
      backgroundColor: AppColors.orange,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Выбрать время",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 10,),
          const Icon(
            Icons.done_rounded,
            color: AppColors.dirtyWhite,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _dateSelectionPanel() {
    return SizedBox(
      child: CarouselSlider.builder(
        itemCount: _days.length,
        options: CarouselOptions(
          height: 40,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
          viewportFraction: 0.4,
          enlargeFactor: 0.5,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            _selectDay(_days[index]);
            setState(() {});
          }
        ),
        itemBuilder: (context, index, a) {
          return SizedBox(
            width: 100,
            child: Text(
              _days[index],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _days[index] == _selectedDay
                    ? AppColors.orange
                    : AppColors.lightOrange,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  void _selectDay(String day) {
    _selectedDay = day;
    switch (_selectedDay) {
      case "Сегодня":
        _initStartTimes((time) => time.isBefore(TimeOfDay.now()));
        _initEndTimes((time) => time.isBefore(TimeOfDay.now()));
        if (_selectedStartTime.isBefore(_startTimes.first)) {
          _selectedStartTime = _startTimes.first;
          _selectedEndTime = _endTimes.first;
        }
        break;
      case "Завтра":
        _initStartTimes((time) => false);
        _initEndTimes((time) => false);
        break;
      case "Послезавтра":
        _initStartTimes((time) => false);
        _initEndTimes((time) => false);
        break;
    }
    print("start1: ${TimeUtils.formatTime(_selectedStartTime)}");
    _startTimesController.jumpToPage(
      _startTimes.indexWhere((time) => time == _selectedStartTime),
    );
    _endTimesController.jumpToPage(
      _endTimes.indexWhere((time) => time == _selectedEndTime),
    );
    setState(() {});
  }

  void _initStartTimes(bool Function(TimeOfDay) removeCondition) {
    _initTimes(_startTimes, removeCondition);
    _startTimes.removeRange(_startTimes.length - 2, _startTimes.length);
  }

  void _initEndTimes(bool Function(TimeOfDay) removeCondition) {
    _initTimes(_endTimes, removeCondition);
    _endTimes.removeRange(0, 2);
  }

  void _initTimes(List<TimeOfDay> times, bool Function(TimeOfDay) removeCondition) {
    times.clear();
    var time = const TimeOfDay(hour: 0, minute: 0);
    while (time.hour != 24) {
      times.add(time);
      time = time.addMinutes(10);
    }
    times.removeWhere((time) => removeCondition(time));
  }

  void _onStartTimeSelected(TimeOfDay time, CarouselPageChangedReason reason) {
    if (reason != CarouselPageChangedReason.manual) return;
    print("start2: ${TimeUtils.formatTime(time)}");
    _selectedStartTime = time;
    if (_selectedEndTime.isBefore(_selectedStartTime.addMinutes(20))) {
      _selectedEndTime = _selectedStartTime.addMinutes(20);
      _endTimesController.jumpToPage(
        _endTimes.indexWhere((element) => element == _selectedEndTime),
      );
    }
    setState(() {});
  }

  void _onEndTimeSelected(TimeOfDay time, CarouselPageChangedReason reason) {
    if (reason != CarouselPageChangedReason.manual) return;
    _selectedEndTime = time;
    if (_selectedEndTime.isBefore(_selectedStartTime.addMinutes(20))) {
      _selectedStartTime = _selectedEndTime.subtractMinutes(20);
      _startTimesController.jumpToPage(
        _startTimes.indexWhere((element) => element == _selectedStartTime),
      );
    }
    setState(() {});
  }

  Widget _timeRangePanel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 3,
          child: _timeSelectionPanel(
            controller: _startTimesController,
            items: _startTimes,
            selectTime: _onStartTimeSelected,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "-", style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: _timeSelectionPanel(
            controller: _endTimesController,
            items: _endTimes,
            selectTime: _onEndTimeSelected,
          ),
        ),
      ],
    );
  }

  Widget _timeSelectionPanel({
    required CarouselController controller,
    required List<TimeOfDay> items,
    required Function(TimeOfDay, CarouselPageChangedReason) selectTime,
  }) {
    double panelHeight = 250;

    return SizedBox(
      height: panelHeight,
      child: DataPanel(
        borderRadius: 13,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.lightOrange,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            CarouselSlider.builder(
              carouselController: controller,
              itemCount: items.length,
              options: CarouselOptions(
                height: panelHeight,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                scrollDirection: Axis.vertical,
                viewportFraction: 0.2,
                enlargeFactor: 0,
                onPageChanged: (index, reason) {
                  selectTime(items[index], reason);
                },
              ),
              itemBuilder: (context, index, a) {
                return Text(
                  TimeUtils.formatTime(items[index]),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        )
      ),
    );
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TimeOfDay>('_selectedEndTime', _selectedEndTime));
  }
}

extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay other) {
    if (hour < other.hour) return true;
    if (hour > other.hour) return false;
    if (minute < other.minute) return true;
    return false;
  }

  TimeOfDay addMinutes(int minutes) {
    int total = hour * 60 + minute + minutes;
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }

  TimeOfDay subtractMinutes(int minutes) {
    int total = hour * 60 + minute - minutes;
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }
}