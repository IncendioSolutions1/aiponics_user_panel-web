import 'dart:developer';
import 'package:aiponics_web_app/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

import '../controllers/token controllers/access_and_refresh_token_controller.dart';

class TRouteMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    log("------------Middle ware called.-------");

    // Use TokenManager to check if the refresh token is expired
    bool isTokenExpired = TokenManager.isRefreshTokenExpired();
    log(isTokenExpired ? "Token is expired" : "Token is not expired");

    // Redirect to login if expired
    if (isTokenExpired) {
      return const RouteSettings(name: TRoutes.login);
    }

    // Return null if token is not expired
    return null;
  }
}
