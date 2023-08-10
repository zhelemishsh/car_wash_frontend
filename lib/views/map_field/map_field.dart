import 'dart:typed_data';

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
  Function(CameraPosition) onCameraPositionChanged = (position) {};
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
        target: await _getUserLocation(),
      )),
    );
  }

  Future<double> getDistance(ScreenPoint point1, ScreenPoint point2) async {
    Point? mapPoint1 = await mapController.getPoint(point1);
    Point? mapPoint2 = await mapController.getPoint(point2);
    return _calcDistance(mapPoint1!, mapPoint2!);
  }

  Widget _mapPanel() {
    return FutureBuilder<List<MapObject>>(
      future: _makePlacemarks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _placemarks = snapshot.data!;
        }
        return YandexMap(
          onCameraPositionChanged: (position, reason, finish) {
            onCameraPositionChanged(position);
          },
          logoAlignment: const MapAlignment(
            horizontal: HorizontalAlignment.right,
            vertical: VerticalAlignment.top,
          ),
          onMapCreated: (YandexMapController controller) {
            mapController = controller;
            _getUserLocationPermission();
          },
          mapObjects: _placemarks,
        );
      },
    );
  }

  Future<List<MapObject>> _makePlacemarks() async {
    List<MapObject> placemarks = [];
    for (PlacemarkData data in placemarksWidgetsBuilder()) {
      Uint8List image = await _makeImageFromOfferWidget(data.widget);
      placemarks.add(_makePlacemark(data, image));
    }
    return placemarks;
  }

  Future<Point> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return Point(latitude: position.latitude, longitude: position.longitude);
  }

  void _getUserLocationPermission() async {
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
      point: Point(
        latitude: data.position.latitude,
        longitude: data.position.longitude,
      ),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromBytes(placeMarkImage),
          anchor: data.offset,
        ),
      ),
    );
  }

  Future<Uint8List> _makeImageFromOfferWidget(Widget widget) async {
    return await _screenshotController.captureFromWidget(
      widget,
      delay: const Duration(seconds: 0),
    );
  }
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