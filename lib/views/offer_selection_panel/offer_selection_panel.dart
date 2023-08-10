import 'package:car_wash_frontend/views/offer_selection_panel/confirming_dialog.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_placemark_widget.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_selection_presenter.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car_wash_offer.dart';
import '../../theme/app_colors.dart';
import '../bottom_panel/bottom_panel.dart';
import '../map_field/map_field.dart';
import 'offer_selection_contract.dart';

class OfferSelectionPanel extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final Function() onOfferSelected;

  const OfferSelectionPanel({
    Key? key,
    required this.mapKey,
    required this.onOfferSelected,
  }) : super(key: key);

  @override
  OfferSelectionPanelState createState() {
    return OfferSelectionPanelState();
  }
}

class OfferSelectionPanelState
    extends State<OfferSelectionPanel> implements OfferSelectionContract {
  final _bottomPanelKey = GlobalKey<BottomPanelState>();
  late OfferSelectionPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = OfferSelectionPresenter(this);
    widget.mapKey.currentState!.topLayerWidgetsBuilder = () => [];
    widget.mapKey.currentState!.placemarksWidgetsBuilder = _buildPlacemarks;
    widget.mapKey.currentState!.setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _presenter.loadWashOffers();
    });
  }

  @override
  void setState(VoidCallback fn) {
    _bottomPanelKey.currentState?.setState(() {});
    widget.mapKey.currentState?.setState(() {});
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BottomPanel(
      key: _bottomPanelKey,
      childBuilder: () {
        return Container(
          constraints: const BoxConstraints(maxHeight: 350, minHeight: 20),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _presenter.offers.length,
            itemBuilder: (BuildContext context, int index) {
              return _carWashOfferWidget(_presenter.offers[index]);
            },
          ),
        );
      },
    );
  }

  @override
  void updateOffers() => setState(() {});

  List<PlacemarkData> _buildPlacemarks() {
    return _presenter.offers.map((offer) {
      return PlacemarkData(
        OfferPlacemarkWidget(
          offer: offer,
        ),
        Point(
          latitude: offer.position.latitude,
          longitude: offer.position.longitude,
        ),
      );
    }).toList();
  }

  Widget _carWashOfferWidget(CarWashOffer offer) {
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
            child: _carWashInfoPanel(offer),
          ),
        ],
      ),
    );
  }

  void _showConfirmingDialog(CarWashOffer offer) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmingDialog(
          offer: offer,
          onConfirmed: () {},
        );
      },
    );
  }

  Widget _carWashInfoPanel(CarWashOffer offer) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        backgroundColor: AppColors.lightGrey,
        foregroundColor: Colors.orange,
        iconColor: Colors.black,
      ),
      onPressed: () {
        _showConfirmingDialog(offer);
      },
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
              Expanded(flex: 1, child: _ratingPanel(offer.rating),),
            ],
          ),
          Text(offer.address, style: Theme.of(context).textTheme.titleSmall,),
          Container(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              children: [
                Expanded(flex: 2, child: _timePanel(offer.startTime, offer.endTime)),
                Expanded(flex: 1, child: _pricePanel(offer.price),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timePanel(TimeOfDay startTime, TimeOfDay endTime) {
    return Row(
      children: [
        const Icon(
          Icons.schedule_rounded,
        ),
        Text(
          "${_formatTime(startTime)} - ${_formatTime(endTime)}",
          style: Theme.of(context).textTheme.titleLarge,
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
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Icon(
          Icons.currency_ruble_rounded,
        ),
      ],
    );
  }

  Widget _ratingPanel(double rating) {
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

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        ':${time.minute.toString().padLeft(2, '0')}';
  }
}