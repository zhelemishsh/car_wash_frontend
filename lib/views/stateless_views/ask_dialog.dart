import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AskDialog extends StatelessWidget {
  final Function() onConfirmed;
  final String text;

  const AskDialog({
    Key? key,
    required this.text,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Container (
        width: 200,
        padding: const EdgeInsets.all(11),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Row(
              children: [
                Expanded(child: _noButton(context)),
                Expanded(child: _yesButton(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _yesButton(BuildContext context) {
    return DataButtonPanel(
      height: 45,
      margin: 4,
      backgroundColor: AppColors.orange,
      splashColor: AppColors.dirtyWhite,
      onPressed: () {
        Navigator.pop(context);
        onConfirmed();
      },
      child: Text(
        "Да",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _noButton(BuildContext context) {
    return DataButtonPanel(
      height: 45,
      margin: 4,
      backgroundColor: AppColors.grey,
      borderColor: AppColors.lightOrange,
      splashColor: AppColors.orange,
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "Нет",
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightOrange),
      ),
    );
  }
}