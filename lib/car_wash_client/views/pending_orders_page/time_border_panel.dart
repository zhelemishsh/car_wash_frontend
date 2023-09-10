import 'package:flutter/material.dart';
import 'package:progress_border/progress_border.dart';

import '../../../theme/app_colors.dart';

class TimeBorderPanel extends StatefulWidget {
  final Widget child;
  final int startSecond;
  final int fullDuration;
  final Function() onTimerFinished;


  const TimeBorderPanel({
    Key? key,
    required this.startSecond,
    required this.fullDuration,
    required this.onTimerFinished,
    required this.child,
  }) : super(key: key);

  @override
  TimeBorderPanelState createState() {
    return TimeBorderPanelState();
  }
}

class TimeBorderPanelState extends State<TimeBorderPanel>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: widget.fullDuration),
    value: widget.startSecond / widget.fullDuration,
  );

  @override
  void initState() {
    _animationController.forward();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        widget.onTimerFinished();
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color: AppColors.black,
        border: ProgressBorder.all(
          color: AppColors.lightOrange,
          width: 4,
          progress: _animationController.value,
        ),
      ),
      child: widget.child,
    );
  }
}