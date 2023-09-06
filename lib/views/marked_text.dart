import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MarkedText extends StatelessWidget {
  final String text;
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final TextStyle? textStyle;

  const MarkedText({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.iconData,
    this.iconColor = AppColors.orange,
    this.iconSize = 22,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          color: iconColor,
          size: iconSize,
        ),
        const SizedBox(width: 6,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}