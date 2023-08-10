import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class OfferPlacemarkWidget extends StatefulWidget {
  final CarWashOffer offer;

  const OfferPlacemarkWidget({
    Key? key,
    required this.offer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OfferPlacemarkWidgetState();
  }
}

class OfferPlacemarkWidgetState extends State<OfferPlacemarkWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 800,
      height: 145,
      child: Stack(
        children: [
          Positioned(
            left: 230,
            child: _offerInfoPanel(widget.offer),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _placemarkIcon(),
          ),
        ],
      ),
    );
  }

  Widget _placemarkIcon() {
    return const Icon(
      Icons.location_on_rounded,
      color: AppColors.orange,
      size: 70,
      shadows: [
        Shadow(
          color: Color.fromRGBO(0, 0, 0, 0.4),
          offset: Offset(0, 0),
          blurRadius: 6,
        ),
      ],
    );
  }

  Widget _offerInfoPanel(CarWashOffer offer) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColors.lightGrey,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            blurRadius: 6,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Container(
            child: _pricePanel(offer.price),
          ),
          Container(
            child: _timePanel(offer.startTime, offer.endTime),
          ),
        ],
      ),
    );
  }

  Widget _timePanel(TimeOfDay startTime, TimeOfDay endTime) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.schedule_rounded,
          size: 17,
        ),
        Text(
          "${_formatTime(startTime)} - ${_formatTime(endTime)}",
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        ':${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _pricePanel(int price) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.currency_ruble_rounded,
          size: 17,
        ),
        Text(
          price.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}