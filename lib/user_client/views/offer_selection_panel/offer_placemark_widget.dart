import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class OfferPlacemarkWidget extends StatefulWidget {
  final String carWashName;
  final String driveTime;

  const OfferPlacemarkWidget({
    Key? key,
    required this.carWashName,
    required this.driveTime,
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
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _placemarkIcon(),
          _offerInfoPanel(),
        ],
      ),
    );
  }

  Widget _placemarkIcon() {
    return const Icon(
      Icons.location_on_rounded,
      color: AppColors.orange,
      size: 40,
      shadows: [
        Shadow(
          color: Color.fromRGBO(0, 0, 0, 0.4),
          offset: Offset(0, 0),
          blurRadius: 6,
        ),
      ],
    );
  }

  Widget _offerInfoPanel() {
    return Container(
      width: 110,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColors.dirtyWhite,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              widget.carWashName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            fit: BoxFit.fill,
          ),
          _routeTimePanel(),
        ],
      ),
    );
  }

  Widget _routeTimePanel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.route_rounded,
          size: 17,
        ),
        Text(
          widget.driveTime,
          style: Theme.of(context).textTheme.titleSmall,
        )
      ],
    );
  }
}