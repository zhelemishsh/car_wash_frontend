import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class RoundedIconText extends StatelessWidget {
  final IconData iconData;
  final double size;
  final String text;

  const RoundedIconText({
    Key? key,
    required this.iconData,
    required this.size,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _roundedIcon(size, iconData),
          const SizedBox(width: 6,),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundedIcon(double size, IconData iconData) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      ),
      child: Icon(
        iconData,
        color: AppColors.orange,
        size: size - 5,
      ),
    );
  }
}