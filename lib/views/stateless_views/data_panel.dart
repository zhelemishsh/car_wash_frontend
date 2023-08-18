import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class DataPanel extends StatelessWidget {
  final Widget child;
  final double margin;
  final Color? backgroundColor;

  const DataPanel({
    Key? key,
    required this.child,
    this.margin = 0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor ?? AppColors.dirtyWhite,
      ),
      child: child,
    );
  }
}

class DataButtonPanel extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final Color? splashColor;
  final bool isToggled;
  final double margin;

  const DataButtonPanel({
    Key? key,
    required this.child,
    required this.onPressed,
    this.splashColor,
    this.isToggled = false,
    this.margin = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          backgroundColor: isToggled ? AppColors.lightOrange : AppColors.dirtyWhite,
          foregroundColor: splashColor ?? AppColors.orange,
          iconColor: AppColors.black,
        ),
      ),
    );
  }
}