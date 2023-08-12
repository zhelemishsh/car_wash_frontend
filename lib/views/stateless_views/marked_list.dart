import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MarkedList extends StatelessWidget {
  final List<MarkedTextData> markedTexts;
  final double size;

  const MarkedList({
    Key? key,
    required this.markedTexts,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _textWidgetsList(context),
      )
    );
  }

  List<Widget> _textWidgetsList(BuildContext context) {
    return markedTexts.map((data) =>
        _markedText(context, data),
    ).toList();
  }

  Widget _markedText(BuildContext context, MarkedTextData data) {
    TextStyle textStyle = data.textStyle
        ?? Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: size - 6,);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          data.iconData,
          color: AppColors.orange,
          size: data.iconData != null ? size : 0,
        ),
        const SizedBox(width: 6,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              data.text,
              style: textStyle,
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