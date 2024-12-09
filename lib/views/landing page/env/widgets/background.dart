import 'package:aiponics_web_app/routes/app_routes.dart';
import 'package:dart_fusion/dart_fusion.dart';
import 'package:flutter/cupertino.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    this.opacity = 0.25,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    required this.child,
  }) : builder = null, backgroundGradient = null;

  const Background.builder(
      this.builder, {
        super.key,
        this.opacity = 0.25,
        this.child = const SizedBox(),
        this.backgroundGradient,
      })  : fit = BoxFit.cover,
        alignment = Alignment.center,
        assert(builder != null);

  final Widget child;
  final Widget Function(BuildContext context, Widget child)? builder;
  final double opacity;
  final Gradient? backgroundGradient;
  final BoxFit fit;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DChangeBuilder(
            value: TAppRoute.controller.scroll,
            builder: (context, value, child) {
              double position = 0.0;
              if (value.hasClients) {
                double maxScrollExtent = value.position.maxScrollExtent;
                double offset = value.offset;

                // Normalize the scroll value to get a range from 0 to 1
                if (maxScrollExtent > 0) {
                  position = offset / maxScrollExtent;
                }
              }

              // Define cooler, more vibrant greens and other accent colors
              Color startColor = const Color(0xFF66BB6A); // Light Green
              Color middleColor = const Color(0xFF2E7D32); // Strong Green
              Color endColor = const Color(0xFF1B5E20); // Dark Green
              Color accentColor = const Color(0xFF00C853); // Bright accent color (light green)

              // Interpolate between colors based on scroll position
              Color interpolatedStartColor = Color.lerp(startColor, middleColor, position)!;
              Color interpolatedEndColor = Color.lerp(middleColor, endColor, position)!;
              Color interpolatedAccentColor = Color.lerp(accentColor, middleColor, position)!;

              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      interpolatedStartColor,
                      interpolatedAccentColor,
                      interpolatedEndColor
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.5, 1.0], // Control the gradient's spread
                  ),
                ),
              );
            },
          ),
        ),
        child,
      ],
    );
  }

  // Parallax effect for gradient background
  static Background parallax({
    required Widget child,
  }) {
    return Background.builder(
          (_, __) => DChangeBuilder(
        value: TAppRoute.controller.scroll,
        builder: (context, value, child) {
          double position = 0.0;
          if (value.hasClients) {
            double maxScrollExtent = value.position.maxScrollExtent;
            double offset = value.offset;

            if (maxScrollExtent > 0) {
              position = offset / maxScrollExtent * 2.0; // Apply parallax effect
            }
          }

          // Vibrant color palette with parallax effect
          Color startColor = const Color(0xFF66BB6A); // Light Green
          Color middleColor = const Color(0xFF2E7D32); // Strong Green
          Color endColor = const Color(0xFF1B5E20); // Dark Green
          Color accentColor = const Color(0xFF00C853); // Bright accent color (light green)

          // Interpolate colors based on the scroll position
          Color interpolatedStartColor = Color.lerp(startColor, middleColor, position)!;
          Color interpolatedEndColor = Color.lerp(middleColor, endColor, position)!;
          Color interpolatedAccentColor = Color.lerp(accentColor, middleColor, position)!;

          return RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    interpolatedStartColor,
                    interpolatedAccentColor,
                    interpolatedEndColor
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0], // Control the gradient's spread
                ),
              ),
            ),
          );
        },
      ),
      child: child,
    );
  }
}
