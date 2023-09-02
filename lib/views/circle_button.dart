import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CircleButton extends StatelessWidget {
  final Function() onPressed;
  final IconData iconData;
  final double size;
  final Color iconColor;
  final Color backgroundColor;

  const CircleButton({
    required this.iconData,
    required this.onPressed,
    required this.size,
    this.iconColor = AppColors.dirtyWhite,
    this.backgroundColor = AppColors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonSize = size;
    return SizedBox(
      height: buttonSize,
      width: buttonSize,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          padding: const EdgeInsets.all(8),
          backgroundColor: backgroundColor.withOpacity(0.7),
          foregroundColor: AppColors.orange,
          shadowColor: Colors.black.withOpacity(0.8),
        ),
        child: Icon(
          iconData,
          color: iconColor,
        ),
      ),
    );
  }
}