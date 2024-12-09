import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreenInfoNotifier extends StateNotifier<Map<String, dynamic>> {
  DashboardScreenInfoNotifier()
      : super({
    'screenResponsiveness': 'desktop',
    'fiveWidth': 0.0,
    'fiveHeight': 0.0,
    'screenRemainingWidth': 0.0,
    'screenFullWidth': 0.0,
  });

  // Update screen responsiveness
  void updateScreenResponsiveness(String responsiveness) {
    state = {...state, 'screenResponsiveness': responsiveness};
  }

  // Update fiveWidth
  void updateFiveWidth(double width) {
    state = {...state, 'fiveWidth': width};
  }

  // Update fiveHeight
  void updateFiveHeight(double height) {
    state = {...state, 'fiveHeight': height};
  }

  // Update screenWidth
  void updateScreenRemainingWidth(double width) {
    state = {...state, 'screenRemainingWidth': width};
  }

  void updateScreenFullWidth(double width) {
    state = {...state, 'screenFullWidth': width};
  }

  // Update all values at once
  void updateAll({
    required String responsiveness,
    required double fiveWidth,
    required double fiveHeight,
    required double screenWidth,
    required double screenRemainingWidth,
    required double screenFullWidth,
  }) {
    state = {
      ...state,
      'screenResponsiveness': responsiveness,
      'fiveWidth': fiveWidth,
      'fiveHeight': fiveHeight,
      'screenWidth': screenWidth,
      'screenRemainingWidth': screenRemainingWidth,
      'screenFullWidth': screenFullWidth,
    };
  }
}

final dashboardScreenInfoProvider =
StateNotifierProvider<DashboardScreenInfoNotifier, Map<String, dynamic>>(
        (ref) {
      return DashboardScreenInfoNotifier();
    });
