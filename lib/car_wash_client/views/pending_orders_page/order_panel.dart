import 'package:flutter/material.dart';
import 'package:progress_border/progress_border.dart';

import '../../../theme/app_colors.dart';

class OrderPanel extends StatefulWidget {
  final Widget child;
  final int startSecond;
  final int fullDuration;
  final Function() onTimerFinished;


  const OrderPanel({
    Key? key,
    required this.startSecond,
    required this.fullDuration,
    required this.onTimerFinished,
    required this.child,
  }) : super(key: key);

  @override
  OrderPanelState createState() {
    return OrderPanelState();
  }
}

class OrderPanelState extends State<OrderPanel>
    with TickerProviderStateMixin {
  late int _currentSecond;
  late final _timeController = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget.fullDuration),
    value: widget.startSecond / widget.fullDuration,
  );

  @override
  void initState() {
    _currentSecond = widget.startSecond;
    _timeController.forward();
    _timeController.addListener(() {
      if (_timeController.isCompleted) {
        widget.onTimerFinished();
        return;
      }
      int time = (widget.fullDuration * _timeController.value).round();
      if (time != _currentSecond) {
        _currentSecond = time;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color: AppColors.black,
        border: ProgressBorder.all(
          color: AppColors.lightOrange,
          width: 4,
          progress: _timeController.value,
        ),
      ),
      child: widget.child,
    );
  }
}