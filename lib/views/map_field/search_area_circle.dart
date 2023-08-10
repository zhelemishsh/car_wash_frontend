import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car_wash_offer.dart';
import '../../models/wash_order.dart';
import '../../theme/app_colors.dart';
import 'map_field.dart';

class SearchAreaCircle extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final double radius;
  final double minZoom;

  const SearchAreaCircle({
    Key? key,
    required this.minZoom,
    required this.radius,
    required this.mapKey,
  }) : super(key: key);

  @override
  SearchAreaCircleState createState() {
    return SearchAreaCircleState();
  }
}

class SearchAreaCircleState extends State<SearchAreaCircle> {
  bool _isZoomTooSmall = true;

  @override
  void initState() {
    super.initState();
    widget.mapKey.currentState!.onCameraPositionChanged =
        onMapCameraPositionChanged;
  }

  void onMapCameraPositionChanged(CameraPosition position) {
    if (!_isZoomTooSmall && position.zoom < widget.minZoom) {
      _isZoomTooSmall = true;
      setState(() {});
    }
    if (_isZoomTooSmall && position.zoom >= widget.minZoom) {
      _isZoomTooSmall = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Color circleColor = _isZoomTooSmall ? AppColors.orange : AppColors.mapBlue;

    return Align(
      alignment: Alignment.center,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.radius * 2,
          height: widget.radius * 2,
          decoration: BoxDecoration(
            border: Border.all(
              color: circleColor.withOpacity(0.7),
              width: 3,
            ),
            color: circleColor.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(widget.radius),
            ),
          ),
        ),
      ),
    );
  }

  Future<SearchArea> getSearchArea() async {
    Size screenSize = MediaQuery.of(context).size;
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    double screenWidth = screenSize.width * pixelRatio;
    double screenHeight = screenSize.height * pixelRatio;
    double circleRadius = widget.radius * pixelRatio;

    ScreenPoint centerScreenPoint = ScreenPoint(
      x: screenWidth / 2,
      y: screenHeight / 2,
    );
    ScreenPoint borderScreenPoint = ScreenPoint(
      x: screenWidth / 2,
      y: screenHeight / 2 - circleRadius,
    );

    Point? centerPoint = await widget.mapKey.currentState!.mapController
        .getPoint(centerScreenPoint);
    double radius = await widget.mapKey.currentState!
        .getDistance(centerScreenPoint, borderScreenPoint);

    return SearchArea(
      MapPosition(centerPoint!.latitude, centerPoint.longitude),
      radius,
    );
  }
}
