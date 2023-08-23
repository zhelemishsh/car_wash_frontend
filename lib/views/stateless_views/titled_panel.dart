import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class TitledPanel extends StatelessWidget {
  final Widget title;
  final Widget child;
  final IconData buttonIconData;
  final Function() onButtonPressed;
  final Color buttonColor;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final double iconSize;

  const TitledPanel({
    Key? key,
    required this.title,
    required this.child,
    required this.buttonIconData,
    required this.onButtonPressed,
    required this.buttonColor,
    this.backgroundColor,
    this.titleStyle,
    this.iconSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataPanel(
      backgroundColor: backgroundColor ?? AppColors.grey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 35,
            child: _titlePanel(context),
          ),
          child,
        ],
      ),
    );
  }

  Widget _titlePanel(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: title,
        ),
        _titleButton(),
      ],
    );
  }

  Widget _titleButton() {
    return SizedBox(
      width: 35,
      height: 35,
      child: IconButton(
        onPressed: onButtonPressed,
        padding: EdgeInsets.zero,
        highlightColor: AppColors.orange.withOpacity(0.1),
        constraints: const BoxConstraints(),
        icon: Icon(
          buttonIconData,
          color: buttonColor,
          size: iconSize,
        ),
      ),
    );
  }
}