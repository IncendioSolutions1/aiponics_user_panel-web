import 'dart:developer';

import 'package:aiponics_web_app/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TRouteMiddleWare extends GetMiddleware {

  @override
  RouteSettings? redirect(String? route) {
    log("------------Middle ware called.-------");
    const isAuthenticated = true;
    return isAuthenticated ?  null : const RouteSettings(name: TRoutes.login);
  }
}