import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../models/car_wash_offer.dart';
import '../../../utils/time_utils.dart';
import '../../../views/data_panel.dart';
import '../../../views/marked_list.dart';

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
      backgroundColor: AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Container (
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dataPanel(),
            _acceptButton(),
          ],
        )
      ),
    );
  }

  Widget _dataPanel() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _carWashImagePanel(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _carWashDataPanel(),
                _offerDataPanel(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _carWashDataPanel() {
    return DataPanel(
      margin: 3,
      child: MarkedList(
        iconSize: 25,
        markedTexts: [
          MarkedTextData(
            text: widget.offer.name,
            textStyle: Theme.of(context).textTheme.titleMedium,
          ),
          MarkedTextData(
            text: widget.offer.address,
            textStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget _offerDataPanel() {
    return DataPanel(
      margin: 3,
      child: MarkedList(
        iconSize: 22,
        textStyle: Theme.of(context).textTheme.titleMedium,
        markedTexts: [
          MarkedTextData(
            iconData: Icons.schedule_rounded,
            text: "${TimeUtils.formatTime(widget.offer.startTime)} - "
                "${TimeUtils.formatTime(widget.offer.endTime)}",
          ),
          MarkedTextData(
            iconData: Icons.currency_ruble_rounded,
            text: widget.offer.price.toString(),
          ),
        ],
      ),
    );
  }

  Widget _carWashImagePanel() {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image:  AssetImage("assets/goshan.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
  
  Widget _acceptButton() {
    return DataButtonPanel(
      splashColor: AppColors.dirtyWhite,
      height: 45,
      margin: 3,
      backgroundColor: AppColors.orange,
      onPressed: () {
        Navigator.pop(context);
        widget.onConfirmed();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Принять предложение",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 10,),
          const Icon(
            Icons.done_rounded,
            color: AppColors.dirtyWhite,
            size: 30,
          ),
        ],
      ),
    );
  }
}