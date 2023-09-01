import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class BottomTitledPanel extends StatelessWidget {
  final Widget child;
  final Widget? title;

  const BottomTitledPanel({
    Key? key,
    required this.child,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          alignment: Alignment.centerLeft,
          child: title,
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            color: Theme.of(context).dialogBackgroundColor,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                spreadRadius: 2,
                blurRadius: 14,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
