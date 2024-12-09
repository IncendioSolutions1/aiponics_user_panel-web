import 'dart:developer'; // Importing dart's log for logging events

import 'package:aiponics_web_app/routes/route.dart'; // Importing the route definitions
import 'package:flutter/material.dart'; // Importing Flutter material package
import 'package:get/get.dart'; // Importing GetX package

class RouteObserverCustom extends GetObserver {
  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    // This method is called when a route is popped off the navigator

    if (previousRoute != null) {
      // If there is a previous route, check its name against defined routes

      for (var routeName in TRoutes.sideMenuItems) {
        if (previousRoute.settings.name == routeName['route']) {
          log("Method Called: Did Popped");
          log("Previous Route: ${previousRoute.settings.name}");
          log("Current Route: ${route?.settings.name}");
        }
      }
    } else {
      log(": Did Popped is null");
    }
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    // This method is called when a new route is pushed onto the navigator

    if (route != null) {
      // If the new route is not null, check its name against defined routes

      for (var routeName in TRoutes.sideMenuItems) {
        if (route.settings.name == routeName['route']) {
          log("Method Called: Did Pushed");
          log("Previous Route: ${previousRoute?.settings.name}");
          log("Current Route: ${route.settings.name}");
        }
      }
    } else {
      log(": Did Pushed is null");
    }
  }
}
