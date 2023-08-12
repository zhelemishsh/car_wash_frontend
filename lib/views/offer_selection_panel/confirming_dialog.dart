import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:car_wash_frontend/utils/time_utils.dart';
import 'package:car_wash_frontend/views/stateless_views/rounded_icon_text.dart';
import 'package:flutter/material.dart';

import '../../models/car_wash_offer.dart';

class ConfirmingDialog extends StatefulWidget {
  final CarWashOffer offer;
  final Function() onConfirmed;

  const ConfirmingDialog({
    Key? key,
    required this.offer,
    required this.onConfirmed,
  }) : super(key: key);

  @override
  ConfirmingDialogState createState() {
    return ConfirmingDialogState();
  }
}

class ConfirmingDialogState extends State<ConfirmingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Container (
        padding: const EdgeInsets.all(13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/goshan.jpg"),
              radius: 40,
            ),
            Text(
              widget.offer.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              widget.offer.address,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _offerDataPanel(widget.offer),
            _acceptButton(),
          ],
        ),
      ),
    );
  }

  Widget _offerDataPanel(CarWashOffer offer) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15,),
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundedIconText(
            iconData: Icons.currency_ruble_rounded,
            size: 30,
            text: offer.price.toString(),
          ),
          RoundedIconText(
            iconData: Icons.schedule_rounded,
            size: 30,
            text: "${TimeUtils.formatTime(offer.startTime)} - "
                "${TimeUtils.formatTime(offer.endTime)}",
          ),
        ],
      ),
    );
  }

  Widget _iconOfferPanel(IconData iconData, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _roundedIcon(30, iconData),
          const SizedBox(width: 6,),
          Text(
            text,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _acceptButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        widget.onConfirmed();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Accept offer",
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          const SizedBox(width: 10,),
          const Icon(
            Icons.done_rounded,
            size: 30,
          ),
        ],
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        backgroundColor: AppColors.lightGrey,
        foregroundColor: AppColors.orange,
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