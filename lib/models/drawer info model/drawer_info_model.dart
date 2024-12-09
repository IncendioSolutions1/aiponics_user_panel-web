class DrawerInfo {
  final bool isDesktopCollapsed;
  final int selectedIndex;
  final int? expandedIndex;
  final int selectedSubIndex;
  final bool showDesktopData;
  final bool showMobileData;
  final bool isMobileCollapsed;

  // Constructor
  const DrawerInfo({
    this.isDesktopCollapsed = false,
    this.selectedIndex = 1,
    this.expandedIndex,
    this.selectedSubIndex = -1,
    this.showDesktopData = false,
    this.showMobileData = true,
    this.isMobileCollapsed = true,
  });

  // CopyWith method for immutability
  DrawerInfo copyWith({
    bool? isDesktopCollapsed,
    int? selectedIndex,
    int? expandedIndex,
    int? selectedSubIndex,
    bool? showDesktopData,
    bool? showMobileData,
    bool? isMobileCollapsed,
  }) {
    return DrawerInfo(
      isDesktopCollapsed: isDesktopCollapsed ?? this.isDesktopCollapsed,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      expandedIndex: expandedIndex ?? this.expandedIndex,
      selectedSubIndex: selectedSubIndex ?? this.selectedSubIndex,
      showDesktopData: showDesktopData ?? this.showDesktopData,
      showMobileData: showMobileData ?? this.showMobileData,
      isMobileCollapsed: isMobileCollapsed ?? this.isMobileCollapsed,
    );
  }
}
