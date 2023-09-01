import 'package:car_wash_frontend/theme/custom_icons.dart';
import 'package:car_wash_frontend/views/bottom_panel/bottom_titled_container.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/confirming_dialog.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_placemark_widget.dart';
import 'package:car_wash_frontend/views/offer_selection_panel/offer_selection_presenter.dart';
import 'package:car_wash_frontend/views/stateless_views/circle_button.dart';
import 'package:car_wash_frontend/views/stateless_views/data_panel.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car_wash_offer.dart';
import '../../theme/app_colors.dart';
import '../map_field/map_field.dart';
import '../stateless_views/ask_dialog.dart';
import 'offer_selection_contract.dart';

class OfferSelectionPanel extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final Function() onOfferSelected;
  final Function() onSearchStopped;
  final MapPosition startPosition;

  const OfferSelectionPanel({
    Key? key,
    required this.mapKey,
    required this.startPosition,
    required this.onOfferSelected,
    required this.onSearchStopped,
  }) : super(key: key);

  @override
  OfferSelectionPanelState createState() {
    return OfferSelectionPanelState();
  }
}

class OfferSelectionPanelState
    extends State<OfferSelectionPanel> implements OfferSelectionContract {
  late OfferSelectionPresenter _presenter;
  final _listKey = GlobalKey<AnimatedListState>();
  CarWashOffer? _selectedOffer;

  @override
  void initState() {
    super.initState();
    _presenter = OfferSelectionPresenter(this, widget.startPosition);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.mapKey.currentState!.placemarksWidgetsBuilder = _buildPlacemarks;
      widget.mapKey.currentState!.routeBuilder = _buildRoute;
      widget.mapKey.currentState!.setState(() {});

      _presenter.loadWashOffers();
    });
  }

  @override
  void dispose() {
    widget.mapKey.currentState!.placemarksWidgetsBuilder = () => [];
    widget.mapKey.currentState!.routeBuilder = () async => null;
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    widget.mapKey.currentState?.setState(() {});
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BottomTitledPanel(
      title: CircleButton(
        backgroundColor: AppColors.darkRed,
        iconData: Icons.clear_rounded,
        size: 40,
        onPressed: _showOrderCancelDialog,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 270, minHeight: 0),
        child: AnimatedList(
          key: _listKey,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          initialItemCount: 0,
          itemBuilder: (context, index, animation) {
            return SizeTransition(
              sizeFactor: animation,
              child: _carWashOfferWidget(_presenter.offers[index]),
            );
          },
        ),
      ),
    );
  }

  @override
  void updateMapOffers() => widget.mapKey.currentState?.setState(() {});

  @override
  void addOfferToList() {
    _listKey.currentState!.insertItem(
      0, duration: const Duration(milliseconds: 300),
    );
  }

  void _showOrderCancelDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AskDialog(
          text: "Прекратить поиск?",
          onConfirmed: () {
            _presenter.stopSearch();
            widget.onSearchStopped();
          },
        );
      },
    );
  }

  List<PlacemarkData> _buildPlacemarks() {
    List<PlacemarkData> result = [
      PlacemarkData(
        offset: const Offset(0.5, 0.9),
        widget: const Icon(
          CustomIcons.start_pin,
          size: 80,
          color: AppColors.darkRed,
        ),
        position: widget.startPosition.toPoint(),
        onPressed: () {},
      ),
    ];
    result.addAll(_presenter.offers.map((offer) {
      return PlacemarkData(
        offset: const Offset(0.155, 0.803),
        widget: OfferPlacemarkWidget(
          carWashName: offer.name,
          driveTime: offer.route!.metadata.weight.timeWithTraffic.text,
        ),
        position: offer.position.toPoint(),
        onPressed: () {
          _selectedOffer = offer;
          setState(() {});
        },
      );
    }).toList());
    return result;
  }

  Future<DrivingRoute?> _buildRoute() async {
    if (_selectedOffer != null) {
      return _selectedOffer!.route;
    }
    return null;
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