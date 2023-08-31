import 'dart:typed_data';

import 'package:car_wash_frontend/models/car_wash_offer.dart';
import 'package:car_wash_frontend/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:great_circle_distance_calculator/great_circle_distance_calculator.dart';
import 'package:screenshot/screenshot.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapField extends StatefulWidget {
  const MapField({Key? key,}) : super(key: key);

  @override
  MapFieldState createState() {
    return MapFieldState();
  }
}

class MapFieldState extends State<MapField> {
  List<Widget> Function() topLayerWidgetsBuilder = () => [];
  List<PlacemarkData> Function() placemarksWidgetsBuilder = () => [];
  Future<RouteData?> Function() routeBuilder = () async => null;
  List<Function(CameraPosition, bool)> onCameraPositionChanged = [];
  List<MapObject> _placemarks = [];
  final _screenshotController = ScreenshotController();
  late YandexMapController mapController;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [_mapPanel()];
    widgets.addAll(topLayerWidgetsBuilder());

    return Stack(children: widgets,);
  }

  void moveCameraToUser(double zoom) async {
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        zoom: zoom,
        target: (await getUserPosition()).toPoint(),
      )),
      animation: const MapAnimation(type: MapAnimationType.smooth),
    );
  }

  Future<double> getDistance(ScreenPoint point1, ScreenPoint point2) async {
    Point? mapPoint1 = await mapController.getPoint(point1);
    Point? mapPoint2 = await mapController.getPoint(point2);
    return _calcDistance(mapPoint1!, mapPoint2!);
  }

  Future<MapPosition> getUserPosition() async {
    CameraPosition? userCameraPosition = await mapController.getUserCameraPosition();
    if (userCameraPosition != null) {
      return userCameraPosition.target.toMapPosition();
    }
    else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return MapPosition(position.latitude, position.longitude);
    }
  }

  Widget _mapPanel() {
    return FutureBuilder<List<MapObject>>(
      future: _makePlacemarks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _placemarks = snapshot.data!;
        }
        return YandexMap(
          rotateGesturesEnabled: false,
          onCameraPositionChanged: (position, reason, finish) {
            for (var func in onCameraPositionChanged) {
              func(position, finish);
            }
          },
          logoAlignment: const MapAlignment(
            horizontal: HorizontalAlignment.right,
            vertical: VerticalAlignment.top,
          ),
          onMapCreated: (YandexMapController controller) {
            mapController = controller;
            _getUserLocationPermission().then((_) {
              mapController.toggleUserLayer(visible: true);
              moveCameraToUser(11);
            });
          },
          onUserLocationAdded: (userLocationView) async {
            PlacemarkMapObject placemark = await _buildLocationPlacemark(userLocationView.pin);
            PlacemarkMapObject arrow = await _buildLocationPlacemark(userLocationView.arrow);

            return userLocationView.copyWith(
              pin: placemark,
              arrow: arrow,
            );
          },
          mapObjects: _placemarks,
        );
      },
    );
  }

  Future<PolylineMapObject> _makeRoute(RouteData routeData) async {
    DrivingSessionResult sessionResult = await YandexDriving.requestRoutes(
      drivingOptions: const DrivingOptions(
        avoidPoorConditions: true,
        avoidUnpaved: true,
      ),
      points: [
        RequestPoint(
          requestPointType: RequestPointType.wayPoint,
          point: routeData.startPosition.toPoint(),
        ),
        RequestPoint(
          requestPointType: RequestPointType.wayPoint,
          point: routeData.endPosition.toPoint(),
        ),
      ],
    ).result;
    return PolylineMapObject(
      mapId: const MapObjectId("route"),
      strokeColor: AppColors.routeBlue,
      zIndex: -1000,
      gapLength: 4,
      dashLength: 10,
      polyline: Polyline(points: sessionResult.routes![0].geometry),
    );
  }

  Future<List<MapObject>> _makePlacemarks() async {
    List<MapObject> placemarks = [];
    RouteData? routeData = await routeBuilder();
    if (routeData != null) placemarks.add(await _makeRoute(routeData));

    for (PlacemarkData placemarkData in placemarksWidgetsBuilder()) {
      Uint8List image = await _makeImageFromWidget(placemarkData.widget);
      placemarks.add(_makePlacemark(placemarkData, image));
    }
    return placemarks;
  }

  Future<void> _getUserLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied
        || permission == LocationPermission.deniedForever) {
      while (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }
  }

  double _calcDistance(Point point1, Point point2) {
    return GreatCircleDistance.fromDegrees(
      latitude1: point1.latitude,
      longitude1: point1.longitude,
      latitude2: point2.latitude,
      longitude2: point2.longitude,
    ).haversineDistance();
  }

  PlacemarkMapObject _makePlacemark(PlacemarkData data, Uint8List placeMarkImage) {
    return PlacemarkMapObject(
      consumeTapEvents: true,
      zIndex: -data.position.latitude,
      mapId: MapObjectId("${data.position.latitude} ${data.position.longitude}"),
      onTap: (mapObject, point) {
        data.onPressed();
      },
      point: data.position,
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromBytes(placeMarkImage),
          anchor: data.offset,
        ),
      ),
    );
  }

  Future<Uint8List> _makeImageFromWidget(Widget widget) async {
    return await _screenshotController.captureFromWidget(
      widget,
      delay: const Duration(seconds: 0),
    );
  }

  Future<PlacemarkMapObject> _buildLocationPlacemark(PlacemarkMapObject pin) async {
    Uint8List userImage = await _makeImageFromWidget(
      const Icon(
        Icons.person_pin_circle_rounded,
        color: AppColors.routeBlue,
        size: 40,
      ),
    );

    return pin.copyWith(
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromBytes(userImage),
          anchor: const Offset(0.5, 0.85),
        ),
      ),
      opacity: 1,
    );
  }
}

class RouteData {
  MapPosition startPosition;
  MapPosition endPosition;

  RouteData(this.startPosition, this.endPosition);
}

class PlacemarkData {
  Widget widget;
  Point position;
  Function() onPressed;
  Offset offset;

  PlacemarkData({
    required this.widget,
    required this.position,
    required this.onPressed,
    required this.offset,
  });
}

extension PointToMapPosition on Point {
  MapPosition toMapPosition() {
    return MapPosition(latitude, longitude);
  }
}

extension MapPositionToPoint on MapPosition {
  Point toPoint() {
    return Point(latitude: latitude, longitude: longitude);
  }
}