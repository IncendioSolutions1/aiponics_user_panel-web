// DrawerInfo class with properties
import 'dart:developer';

import 'package:aiponics_web_app/models/drawer%20info%20model/drawer_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DrawerInfoNotifier class
class DrawerInfoNotifier extends StateNotifier<DrawerInfo> {
  DrawerInfoNotifier() : super(const DrawerInfo());

  // Update isDesktopCollapsed
  void updateIsDesktopCollapsed(bool value) {
    log("Updating isDesktopCollapsed: ${state.isDesktopCollapsed} -> $value");
    state = state.copyWith(isDesktopCollapsed: value);
  }

  // Update selectedIndex
  void updateSelectedIndex(int value) {
    log("Updating selectedIndex: ${state.selectedIndex} -> $value");
    state = state.copyWith(selectedIndex: value);
  }

  // Update expandedIndex
  void updateExpandedIndex(int? value) {
    log("Updating expandedIndex: ${state.expandedIndex} -> $value");
    state = state.copyWith(expandedIndex: value);
  }

  // Update selectedSubIndex
  void updateSelectedSubIndex(int value) {
    log("Updating selectedSubIndex: ${state.selectedSubIndex} -> $value");
    state = state.copyWith(selectedSubIndex: value);
  }

  // Update showDesktopData
  void updateShowDesktopData(bool value) {
    log("Updating showDesktopData: ${state.showDesktopData} -> $value");
    state = state.copyWith(showDesktopData: value);
  }

  // Update showMobileData
  void updateShowMobileData(bool value) {
    log("Updating showMobileData: ${state.showMobileData} -> $value");
    state = state.copyWith(showMobileData: value);
  }

  // Update isMobileCollapsed
  void updateIsMobileCollapsed(bool value) {
    log("Updating isMobileCollapsed: ${state.isMobileCollapsed} -> $value");
    state = state.copyWith(isMobileCollapsed: value);
  }

  // Batch update for multiple fields
  void batchUpdate({
    bool? isDesktopCollapsed,
    int? selectedIndex,
    int? expandedIndex,
    int? selectedSubIndex,
    bool? showDesktopData,
    bool? showMobileData,
    bool? isMobileCollapsed,
  }) {
    log("Batch updating fields:");
    if (isDesktopCollapsed != null) {
      log("isDesktopCollapsed: ${state.isDesktopCollapsed} -> $isDesktopCollapsed");
    }
    if (selectedIndex != null) {
      log("selectedIndex: ${state.selectedIndex} -> $selectedIndex");
    }
    if (expandedIndex != null) {
      log("expandedIndex: ${state.expandedIndex} -> $expandedIndex");
    }
    if (selectedSubIndex != null) {
      log("selectedSubIndex: ${state.selectedSubIndex} -> $selectedSubIndex");
    }
    if (showDesktopData != null) {
      log("showDesktopData: ${state.showDesktopData} -> $showDesktopData");
    }
    if (showMobileData != null) {
      log("showMobileData: ${state.showMobileData} -> $showMobileData");
    }
    if (isMobileCollapsed != null) {
      log("isMobileCollapsed: ${state.isMobileCollapsed} -> $isMobileCollapsed");
    }

    state = state.copyWith(
      isDesktopCollapsed: isDesktopCollapsed,
      selectedIndex: selectedIndex,
      expandedIndex: expandedIndex,
      selectedSubIndex: selectedSubIndex,
      showDesktopData: showDesktopData,
      showMobileData: showMobileData,
      isMobileCollapsed: isMobileCollapsed,
    );
  }
}

// Provider
final drawerInfoProvider =
StateNotifierProvider<DrawerInfoNotifier, DrawerInfo>((ref) {
  return DrawerInfoNotifier();
});
