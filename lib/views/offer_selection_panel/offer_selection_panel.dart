import 'package:car_wash_frontend/theme/custom_icons.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/confirming_dialog.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_placemark_widget.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_selection_presenter.dart';
import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car_wash_offer.dart';
import '../../theme/app_colors.dart';
import '../map_field/map_field.dart';
import 'offer_selection_contract.dart';

class OfferSelectionPanel extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final Function() onOfferSelected;
  final MapPosition startPosition;

  const OfferSelectionPanel({
    Key? key,
    required this.mapKey,
    required this.startPosition,
    required this.onOfferSelected,
  }) : super(key: key);

  @override
  OfferSelectionPanelState createState() {
    return OfferSelectionPanelState();
  }
}

class OfferSelectionPanelState
    extends State<OfferSelectionPanel> implements OfferSelectionContract {
  late OfferSelectionPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = OfferSelectionPresenter(this);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.mapKey.currentState!.placemarksWidgetsBuilder = _buildPlacemarks;
      widget.mapKey.currentState!.setState(() {});

      _presenter.loadWashOffers();
    });
  }

  @override
  void dispose() {
    widget.mapKey.currentState!.placemarksWidgetsBuilder = () => [];
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    widget.mapKey.currentState?.setState(() {});
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 270, minHeight: 0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _presenter.offers.length,
        itemBuilder: (BuildContext context, int index) {
          return _carWashOfferWidget(_presenter.offers[index]);
        },
      ),
    );
  }

  @override
  void updateOffers() => setState(() {});

  List<PlacemarkData> _buildPlacemarks() {
    List<PlacemarkData> result = [
      PlacemarkData(
        offset: const Offset(0.5, 0.9),
        widget: const Icon(
          CustomIcons.start_pin,
          size: 80,
          color: AppColors.darkRed,
        ),
        position: Point(
          latitude: widget.startPosition.latitude,
          longitude: widget.startPosition.longitude,
        ),
        onPressed: () {},
      ),
    ];
    result.addAll(_presenter.offers.map((offer) {
      return PlacemarkData(
        offset: const Offset(0.205, 0.803),
        widget: OfferPlacemarkWidget(
          offer: offer,
        ),
        position: Point(
          latitude: offer.position.latitude,
          longitude: offer.position.longitude,
        ),
        onPressed: () {
          _showConfirmingDialog(offer);
        },
      );
    }).toList());
    return result;
  }

  Widget _carWashOfferWidget(CarWashOffer offer) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(aspectRatio: 1, child: _imagePanel(),),
          Expanded(
            child: _carWashInfoPanel(offer),
          ),
        ],
      ),
    );
  }

  Widget _imagePanel() {
    return Container(
      width: 75,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
          image:  AssetImage("assets/goshan.jpg"),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  void _showConfirmingDialog(CarWashOffer offer) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmingDialog(
          offer: offer,
          onConfirmed: () {
            widget.onOfferSelected();
          },
        );
      },
    );
  }

  Widget _carWashInfoPanel(CarWashOffer offer) {
    return Container(
      margin: const EdgeInsets.all(3),
      child: DataButtonPanel(
        onPressed: () {
          _showConfirmingDialog(offer);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    offer.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _ratingPanel(offer.rating),
              ],
            ),
            Text(offer.address,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Container(
              padding: const EdgeInsets.only(top: 7),
              child: Row(
                children: [
                  Expanded(child: _timePanel(offer.startTime, offer.endTime)),
                  _pricePanel(offer.price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timePanel(TimeOfDay startTime, TimeOfDay endTime) {
    return Row(
      children: [
        const Icon(
          Icons.schedule_rounded,
          size: 20,
          color: AppColors.orange,
        ),
        Text(
          "${_formatTime(startTime)} - ${_formatTime(endTime)}",
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }

  Widget _pricePanel(int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          price.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Icon(
          Icons.currency_ruble_rounded,
          color: AppColors.orange,
          size: 20,
        ),
      ],
    );
  }

  Widget _ratingPanel(double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
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

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        ':${time.minute.toString().padLeft(2, '0')}';
  }
}