import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../models/car_wash_offer.dart';
import '../../theme/app_colors.dart';
import '../../theme/custom_icons.dart';
import 'map_field.dart';

class StartPositionPin extends StatefulWidget {
  final GlobalKey<MapFieldState> mapKey;
  final double radius;
  final double minZoom;

  const StartPositionPin({
    Key? key,
    required this.minZoom,
    required this.radius,
    required this.mapKey,
  }) : super(key: key);

  @override
  StartPositionPinState createState() {
    return StartPositionPinState();
  }
}

class StartPositionPinState extends State<StartPositionPin> {
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    widget.mapKey.currentState!.onCameraPositionChanged.add(
      onMapCameraPositionChanged,
    );
  }

  void onMapCameraPositionChanged(CameraPosition position, bool isFinished) {
    if (isFinished) {
      _isMoving = false;
      setState(() {});
    }
    else {
      if (!_isMoving) {
        _isMoving = true;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: IgnorePointer(
        child: SizedBox(
          height: 200,
          width: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _shadowContainer(),
              AnimatedPositioned(
                top: _isMoving ? 4 : 26,
                curve: Curves.easeInQuad,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  CustomIcons.start_pin,
                  size: 80,
                  color: AppColors.darkRed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shadowContainer() {
    return Transform.scale(
      scaleY: 0.5,
      child: AnimatedContainer(
        curve: Curves.easeInQuad,
        duration: const Duration(milliseconds: 200),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              _isMoving ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.6),
              _isMoving ? Colors.black.withOpacity(0.1) : Colors.black.withOpacity(0.25),
              Colors.transparent,
            ],
            focal: Alignment.center,
          ),
        ),
      ),
    );
  }

  Future<MapPosition> getStartPosition() async {
    Size screenSize = MediaQuery.of(context).size;
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    double screenWidth = screenSize.width * pixelRatio;
    double screenHeight = screenSize.height * pixelRatio;

    ScreenPoint centerScreenPoint = ScreenPoint(
      x: screenWidth / 2,
      y: screenHeight / 2,
    );

    Point? centerPoint = await widget.mapKey.currentState!.mapController
        .getPoint(centerScreenPoint);

    return MapPosition(centerPoint!.latitude, centerPoint.longitude);
  }

  @override
  void dispose() {
    widget.mapKey.currentState!
        .onCameraPositionChanged.remove(onMapCameraPositionChanged);
    super.dispose();
  }
}
