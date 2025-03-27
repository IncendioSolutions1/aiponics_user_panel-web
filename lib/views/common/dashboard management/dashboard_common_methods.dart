import 'dart:math';
import 'package:aiponics_web_app/provider/dashboard%20management%20provider/dashboard_provider.dart';
import 'package:aiponics_web_app/views/sideBar%20(%20Drawer%20Screens%20)/data/todos/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FanPainter extends CustomPainter {
  final int numberOfBlades = 5; // Number of blades

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue // Color of the fan blades
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2; // Adjust blade length

    // Draw the fan blades
    for (int i = 0; i < numberOfBlades; i++) {
      double angle = i *
          (2 *
              pi /
              numberOfBlades); // Calculate angle based on number of blades
      canvas.drawPath(
        _createFanBlade(centerX, centerY, angle, radius),
        paint,
      );
    }
  }

  Path _createFanBlade(double centerX, double centerY, double angle, double radius) {
    Path path = Path();
    path.moveTo(centerX, centerY); // Start at the center

    // Create a more curved shape for the blades
    double controlPointX = centerX + radius * cos(angle + pi / 4);
    double controlPointY = centerY + radius * sin(angle + pi / 4);

    path.lineTo(centerX + radius * cos(angle), centerY + radius * sin(angle));
    path.lineTo(controlPointX, controlPointY);
    path.close(); // Close the path to create the blade shape
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30, // Width of the color box
          height: 10, // Height of the color box
          color: color,
        ),
        const SizedBox(width: 8), // Space between color box and label
        Text(
          label,
          style: const TextStyle(
              fontSize: 14, color: Colors.black), // Style for legend text
        ),
      ],
    );
  }
}

class DashboardCommonMethods{

  static Color getHumidityColor(double humidity) {
    if (humidity < 20) {
      return Colors.lightBlueAccent; // Low Humidity
    } else if (humidity < 40) {
      return Colors.blue; // Moderate Humidity
    } else {
      return Colors.blueAccent; // High Humidity
    }
  }

  static Color getSunIntensityColor(double value) {
    // Define colors based on solar radiation intensity
    if (value < 200) {
      return Colors.green; // Low intensity
    } else if (value < 600) {
      return Colors.orange; // Moderate intensity
    } else {
      return Colors.red; // High intensity
    }
  }

  static Color getSunIntensityGradientColor(double value) {
    // Define gradient colors based on solar radiation intensity
    if (value < 200) {
      return Colors.green.withOpacity(0.3);
    } else if (value < 600) {
      return Colors.orange.withOpacity(0.3);
    } else {
      return Colors.red.withOpacity(0.3);
    }
  }

  static Future<void> selectDate(BuildContext context, WidgetRef ref, DateTime? selectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      ref.read(dashboardInfoProvider.notifier).updateSelectedDate(picked);
    }
  }

  static void showAddTodoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 16,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.7,
                child: const AddTodo(), // Embed AddToDo screen here
              ),
            ),
          ),
        );
      },
      transitionDuration:
      const Duration(milliseconds: 500), // Control the animation duration
    );
  }

}
