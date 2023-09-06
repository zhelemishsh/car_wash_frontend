import 'package:flutter/cupertino.dart';

import '../theme/custom_icons.dart';

enum WashService {
  interiorDryCleaning, diskCleaning, bodyPolishing, engineCleaning
}

extension ServiceParse on WashService {
  String parseToString() {
    switch (this) {
      case WashService.interiorDryCleaning:
        return "Химчистка салона";
      case WashService.diskCleaning:
        return "Чистка дисков";
      case WashService.bodyPolishing:
        return "Полировка кузова";
      case WashService.engineCleaning:
        return "Мойка двигателя";
    }
  }

  IconData getIconData() {
    switch (this) {
      case WashService.interiorDryCleaning:
        return CustomIcons.flask;
      case WashService.diskCleaning:
        return CustomIcons.disk;
      case WashService.bodyPolishing:
        return CustomIcons.clean;
      case WashService.engineCleaning:
        return CustomIcons.engine;
    }
  }
}