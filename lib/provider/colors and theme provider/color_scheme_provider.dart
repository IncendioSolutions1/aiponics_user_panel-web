import 'package:flutter/material.dart';

class ThemeColors{
  final BuildContext context;

  // Constructor to initialize context
  ThemeColors(this.context);

  Color get backgroundColor => Theme.of(context).colorScheme.surface;
  Color get boxColor => Theme.of(context).colorScheme.onSecondary;
  Color get accessibilityButtonsBorderColor => Theme.of(context).inputDecorationTheme.border!.borderSide.color;
  Color get boxHeadingColor => Theme.of(context).textTheme.labelLarge!.color!;
  Color get borderColor => Theme.of(context).colorScheme.onSecondaryFixed;
  Color get imageBorderColor => Theme.of(context).colorScheme.secondaryFixed;
  Color get graphLabelColor => Theme.of(context).colorScheme.onSurface;
  Color get graphMajorTicksColor => Theme.of(context).colorScheme.onSurface;
  Color get graphMinorTicksColor => Theme.of(context).colorScheme.onSurface;
  Color get graphKnobColor => Theme.of(context).colorScheme.onSurface;
  Color get graphNeedleColor => Theme.of(context).colorScheme.onSurface;
  Color get sidebarHighlightedColor => Theme.of(context).colorScheme.surfaceContainer;
  Color get buttonColor => Theme.of(context).colorScheme.surfaceContainer;
  Color get dividerColor => Theme.of(context).colorScheme.onSurface;

}