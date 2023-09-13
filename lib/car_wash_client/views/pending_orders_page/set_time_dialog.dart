import 'package:car_wash_frontend/utils/time_utils.dart';
import 'package:car_wash_frontend/views/data_panel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import '../../../theme/app_colors.dart';

class SetTimeDialog extends StatefulWidget {
  final Function(TimeOfDay start, TimeOfDay end) onTimePicked;
  final TimeOfDay lowerLimit;
  final TimeOfDay upperLimit;
  final int duration;

  const SetTimeDialog({
    Key? key,
    required this.onTimePicked,
    required this.lowerLimit,
    required this.upperLimit,
    required this.duration,
  }) : super(key: key);

  @override
  SetTimeDialogState createState() {
    return SetTimeDialogState();
  }
}

class SetTimeDialogState extends State<SetTimeDialog> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    _selectedTime = widget.lowerLimit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _timeRangePanel(),
            _timePanel(),
            _acceptButton(),
          ],
        ),
      ),
    );
  }

  Widget _acceptButton() {
    return DataButtonPanel(
      height: 45,
      backgroundColor: AppColors.orange,
      splashColor: AppColors.dirtyWhite,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Выбрать время",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      onPressed: () {
        widget.onTimePicked(_selectedTime, _selectedTime.addMinutes(widget.duration));
        Navigator.pop(context);
      },
    );
  }

  Widget _timePanel() {
    return FlutterSlider(
      values: [_selectedTime.getMinutes().toDouble()],
      min: widget.lowerLimit.getMinutes().toDouble(),
      max: widget.upperLimit.getMinutes().toDouble(),
      tooltip: FlutterSliderTooltip(disabled: true,),
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: 14,
        inactiveTrackBarHeight: 14,
        activeTrackBar: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.grey,
        ),
        inactiveTrackBar: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(6),
        )
      ),
      handler: FlutterSliderHandler(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.lightOrange,
        ),
        child: const Icon(
          Icons.schedule,
          color: AppColors.black,
        ),
      ),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        int minutes = lowerValue.round();
        _selectedTime = TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);
        setState(() {});
      },
    );
  }

  Widget _timeRangePanel() {
    TimeOfDay startTime = _selectedTime;
    TimeOfDay endTime = startTime.addMinutes(widget.duration);
    return DataPanel(
      borderColor: AppColors.lightOrange,
      backgroundColor: AppColors.black,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "${TimeUtils.formatTime(startTime)} - ${TimeUtils.formatTime(endTime)}",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
