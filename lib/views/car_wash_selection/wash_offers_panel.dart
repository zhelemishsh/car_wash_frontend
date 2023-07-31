import 'package:flutter/material.dart';

import '../../models/car_wash_offer.dart';
import '../../theme/app_colors.dart';

class WashOffersPanel extends StatefulWidget {
  final List<CarWashOffer> offers;
  final Function(CarWashOffer) onOfferSelected;

  const WashOffersPanel({
    Key? key,
    required this.offers,
    required this.onOfferSelected,
  }) : super(key: key);

  @override
  WashOffersPanelState createState() {
    return WashOffersPanelState();
  }
}

class WashOffersPanelState extends State<WashOffersPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 350, minHeight: 20),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.offers.length,
        itemBuilder: (BuildContext context, int index) {
          return carWashOfferWidget(widget.offers[index]);
        },
      ),
    );
  }

  void updatePage() {
    setState(() {});
  }

  Widget carWashOfferWidget(CarWashOffer offer) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/goshan.jpg"),
                radius: 40,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: InkWell(
              onTap: () {
                widget.onOfferSelected(offer);
              },
              child: carWashInfoPanel(offer),
            ),
          ),
        ],
      ),
    );
  }

  Widget carWashInfoPanel(CarWashOffer offer) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: AppColors.lightGrey,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  offer.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                flex: 1,
                child: ratingPanel(offer.rating),
              ),
            ],
          ),
          Text(
            offer.address,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Container(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: timePanel(offer.startTime, offer.endTime)
                ),
                Expanded(
                  flex: 1,
                  child: pricePanel(offer.price),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget timePanel(TimeOfDay startTime, TimeOfDay endTime) {
    return Row(
      children: [
        const Icon(
          Icons.schedule_rounded,
        ),
        Text(
          "${formatTime(startTime)} - ${formatTime(endTime)}",
          style: Theme.of(context).textTheme.titleLarge,
        )
      ],
    );
  }

  Widget pricePanel(int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          price.toString(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Icon(
          Icons.currency_ruble_rounded,
        ),
      ],
    );
  }

  Widget ratingPanel(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          rating.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Icon(
          Icons.star_rounded,
          color: AppColors.orange,
          size: 20,
        ),
      ],
    );
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        ':${time.minute.toString().padLeft(2, '0')}';
  }
}