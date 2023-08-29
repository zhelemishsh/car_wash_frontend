import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class DataPanel extends StatelessWidget {
  final Widget child;
  final double margin;
  final Color? backgroundColor;
  final double borderRadius;
  final double padding;
  final Color? borderColor;

  const DataPanel({
    Key? key,
    required this.child,
    this.margin = 0,
    this.backgroundColor = AppColors.grey,
    this.borderRadius = 10,
    this.padding = 8,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null ? Border.all(
          color: borderColor!,
          width: 2.0,
        ) : null,
        color: backgroundColor,
      ),
      child: child,
    );
  }
}

class DataButtonPanel extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final Color? splashColor;
  final double margin;
  final Color? backgroundColor;
  final double? height;
  final Color? borderColor;

  const DataButtonPanel({
    Key? key,
    required this.child,
    required this.onPressed,
    this.height,
    this.splashColor = AppColors.orange,
    this.margin = 0,
    this.backgroundColor = AppColors.grey,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.all(margin),
      child: TextButton(
        onPressed: onPressed,
        child: child,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: borderColor != null ? BorderSide(
              color: borderColor!,
              width: 2.0,
            ) : BorderSide.none,
          ),
          padding: const EdgeInsets.all(8),
          backgroundColor: backgroundColor,
          foregroundColor: splashColor,
          iconColor: AppColors.black,
        ),
      ),
    );
  }
}