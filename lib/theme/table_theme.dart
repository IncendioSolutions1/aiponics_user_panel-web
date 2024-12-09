import 'package:flutter/material.dart';

// Custom ThemeExtension for table colors
class TableColors extends ThemeExtension<TableColors> {
  final Color evenRowColor; // Color for even rows
  final Color oddRowColor;   // Color for odd rows
  final Color textColor;     // Color for text in the table

  // Constructor to initialize the colors
  TableColors({
    required this.evenRowColor,
    required this.oddRowColor,
    required this.textColor,
  });

  @override
  // Method to create a copy of this instance with optional new values
  TableColors copyWith({
    Color? evenRowColor,
    Color? oddRowColor,
    Color? textColor,
  }) {
    return TableColors(
      evenRowColor: evenRowColor ?? this.evenRowColor,
      oddRowColor: oddRowColor ?? this.oddRowColor,
      textColor: textColor ?? this.textColor,
    );
  }

  @override
  // Method to interpolate between two TableColors instances
  TableColors lerp(ThemeExtension<TableColors>? other, double t) {
    if (other is! TableColors) return this; // Ensure the other is a TableColors instance
    return TableColors(
      evenRowColor: Color.lerp(evenRowColor, other.evenRowColor, t)!, // Interpolate even row color
      oddRowColor: Color.lerp(oddRowColor, other.oddRowColor, t)!,     // Interpolate odd row color
      textColor: Color.lerp(textColor, other.textColor, t)!,           // Interpolate text color
    );
  }
}
