import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MarkedList extends StatelessWidget {
  final List<MarkedTextData> markedTexts;
  final double iconSize;
  final TextStyle? textStyle;
  final MainAxisSize mainAxisSize;

  const MarkedList({
    Key? key,
    this.textStyle,
    required this.markedTexts,
    required this.iconSize,
    this.mainAxisSize = MainAxisSize.min,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: mainAxisSize,
      children: _textWidgetsList(context),
    );
  }

  List<Widget> _textWidgetsList(BuildContext context) {
    return markedTexts.map((data) =>
        _markedText(context, data),
    ).toList();
  }

  Widget _markedText(BuildContext context, MarkedTextData data) {
    TextStyle? style = data.textStyle ?? textStyle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          data.iconData,
          color: AppColors.orange,
          size: data.iconData != null ? iconSize : 0,
        ),
        const SizedBox(width: 6,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              data.text,
              style: style,
            ),
          ),
        ),
      ],
    );
  }
}

class MarkedTextData {
  String text;
  IconData? iconData;
  TextStyle? textStyle;

  MarkedTextData({required this.text, this.iconData, this.textStyle});
}