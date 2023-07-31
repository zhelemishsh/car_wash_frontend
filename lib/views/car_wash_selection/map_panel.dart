import 'dart:math';
import 'dart:typed_data';

import 'package:car_wash_frontend/models/wash_order.dart';
import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:great_circle_distance_calculator/great_circle_distance_calculator.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car_wash_offer.dart';

class MapPanel extends StatefulWidget {
  final Function() onMapTouched;
  final List<CarWashOffer> offers;

  const MapPanel({
    Key? key,
    required this.onMapTouched,
    required this.offers,
  }) : super(key: key);

  @override
  MapPanelState createState() {
    return MapPanelState();
  }
}

class MapPanelState extends State<MapPanel> {
  List<MapObject> placemarks = [];
  final screenshotController = ScreenshotController();
  String selectedCarWash = "";
  final double _searchCircleRadius = 170;
  late YandexMapController _mapController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YandexMap(
          logoAlignment: const MapAlignment(
            horizontal: HorizontalAlignment.right,
            vertical: VerticalAlignment.top,
          ),
          onMapCreated: (YandexMapController controller) {
            _mapController = controller;
          },
          onMapTap: (Point point) {
            widget.onMapTouched();
          },
          mapObjects: placemarks,
        ),
        Align(
          alignment: Alignment.center,
          child: IgnorePointer(
            child: CustomPaint(
              painter: CirclePainter(_searchCircleRadius),
            ),
          ),
        )
      ],
    );
  }

  Future<SearchArea> getSearchArea(MapPosition position, double radius) async {
    double screenWidth = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    double screenHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    double circleRadius = _searchCircleRadius *
        MediaQuery.of(context).devicePixelRatio;
    Point? centerPoint = await _mapController.getPoint(
      ScreenPoint(
        x: screenWidth / 2,
        y: screenHeight / 2,
      ),
    );
    Point? borderPoint = await _mapController.getPoint(
      ScreenPoint(
        x: screenWidth / 2,
        y: screenHeight / 2 - circleRadius,
      ),
    );
    double radius = _calcDistance(centerPoint!, borderPoint!);
    SearchArea area = SearchArea(
      MapPosition(centerPoint!.latitude, centerPoint.longitude),
      radius,
    );
    return area;
  }

  double _calcDistance(Point point1, Point point2) {
    return GreatCircleDistance.fromDegrees(
      latitude1: point1.latitude,
      longitude1: point1.longitude,
      latitude2: point2.latitude,
      longitude2: point2.longitude,
    ).haversineDistance();
  }

  void updatePage() {
    Future(() async {
      placemarks = [];
      for (CarWashOffer offer in widget.offers) {
        Widget widget = placemarkWidget(offer);
        Uint8List image = await makeImageFromOfferWidget(widget);
        placemarks.add(makePlacemark(offer, image));
      }
    }).then((value) {
      setState(() {});
    });
  }

  PlacemarkMapObject makePlacemark(offer, Uint8List placeMarkImage) {
    return PlacemarkMapObject(
      mapId: MapObjectId(offer.id.toString()),
      point: Point(
        latitude: offer.position.latitude,
        longitude: offer.position.longitude,
      ),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromBytes(placeMarkImage),
        ),
      ),
    );
  }

  Future<Uint8List> makeImageFromOfferWidget(Widget widget) async {
    return await screenshotController.captureFromWidget(
      widget,
      delay: const Duration(seconds: 0),
    );
  }

  Widget placemarkWidget(CarWashOffer offer) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 800,
      height: 145,
      child: Stack(
        children: [
          Positioned(
            left: 230,
            child: offerInfoPanel(offer),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: placemarkIcon(),
          ),
        ],
      ),
    );
  }

  Widget placemarkIcon() {
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

  Widget offerInfoPanel(CarWashOffer offer) {
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
            child: pricePanel(offer.price),
          ),
          Container(
            child: timePanel(offer.startTime, offer.endTime),
          ),
        ],
      ),
    );
  }

  Widget timePanel(TimeOfDay startTime, TimeOfDay endTime) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.schedule_rounded,
          size: 17,
        ),
        Text(
          "${formatTime(startTime)} - ${formatTime(endTime)}",
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        ':${time.minute.toString().padLeft(2, '0')}';
  }

  Widget pricePanel(int price) {
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

class CirclePainter extends CustomPainter {
  final double _circleRadius;

  CirclePainter(this._circleRadius);

  @override
  void paint(Canvas canvas, Size size) {
    var paintCircle = Paint()
      ..color = AppColors.mapBlue.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    var paintOutline = Paint()
      ..color = AppColors.mapBlue.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawCircle(const Offset(0, 0), _circleRadius, paintCircle,);
    canvas.drawCircle(const Offset(0, 0), _circleRadius, paintOutline,);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}