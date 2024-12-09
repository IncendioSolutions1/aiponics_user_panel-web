import 'dart:developer';

import 'package:aiponics_web_app/views/sideBar ( Drawer Screens )/data/todos/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ViewTodos extends StatefulWidget {
  const ViewTodos({super.key});

  @override
  State<ViewTodos> createState() => _ViewTodosState();
}

class _ViewTodosState extends State<ViewTodos> {
  String name = "Ahmad Ali";

  List<Map<String, dynamic>> todoList = [
    {
      "title": "Complete Flutter Web Dashboard",
      "description":
          "Finish the dashboard management for the agriculture app with a focus on UI improvements and graph display features.",
      "priority": "High", // High, Medium, Low
      "status": "In Progress", // In Progress, Completed, Pending
      "createdOn": "2024-09-30",
    },
    {
      "title": "Update Database Schema",
      "description":
          "Modify the database structure to support new fields in the user profile section.",
      "priority": "Medium",
      "status": "In Progress",
      "createdOn": "2024-09-28",
    },
    {
      "title": "Design Marketing Materials",
      "description":
          "Create social media banners and email templates for the upcoming product launch.",
      "priority": "Low",
      "status": "Completed",
      "createdOn": "10 days ago",
    },
    {
      "title": "Fix Notification Bug",
      "description":
          "Resolve the issue where users are not receiving event notifications in the app.",
      "priority": "High",
      "status": "In Progress",
      "createdOn": "2024-09-29",
    },
    {
      "title": "Write User Documentation",
      "description":
          "Prepare a detailed user manual for the farm monitoring system with step-by-step instructions.",
      "priority": "Medium",
      "status": "Pending",
      "createdOn": "2024-09-26",
    },
    {
      "title": "Write User Documentation",
      "description":
          "Prepare a detailed user manual for the farm monitoring system with step-by-step instructions.",
      "priority": "Medium",
      "status": "Completed",
      "createdOn": "2 days ago",
    },
  ];

  late int totalTodos;
  late int completedTodo;
  late int pendingTodos;
  late int inProgressTodos;

  late double completedPercentage;
  late double pendingPercentage;
  late double inProgressPercentage;

  void showAddTodoDialog(BuildContext context) {
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

  @override
  void initState() {
    totalTodos = todoList.length;
    completedTodo =
        todoList.where((todo) => todo['status'] == 'Completed').length;
    pendingTodos = todoList.where((todo) => todo['status'] == 'Pending').length;
    inProgressTodos =
        todoList.where((todo) => todo['status'] == 'In Progress').length;

    completedPercentage =
        totalTodos > 0 ? (completedTodo / totalTodos) * 100 : 0;
    pendingPercentage = totalTodos > 0 ? (pendingTodos / totalTodos) * 100 : 0;
    inProgressPercentage =
        totalTodos > 0 ? (inProgressTodos / totalTodos) * 100 : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size to make the layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final fiveWidth = screenWidth * 0.003434;
    final fiveHeight = screenHeight * 0.005681;

    return Scaffold(
      body: LayoutBuilder(
        builder: (_, constraints) {
          final width = MediaQuery.of(context).size.width;
          log("Width: $width");
          log("Width Constraints: ${constraints.maxWidth}");
          if (constraints.maxWidth >= 1000) {
            return Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 100, right: 50),
              child: desktopWidget(width, fiveWidth, fiveHeight),
            );
          } else if ((constraints.maxWidth < 1000 &&
                  constraints.maxWidth >= 700) ||
              width >= 700) {
            return Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 100, right: 50),
              child: tabletWidget(width, fiveWidth, fiveHeight),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 80.0, left: 100, right: 50),
              child: mobileWidget(width, fiveWidth, fiveHeight),
            );
          }
        },
      ),
    );
  }

  Widget mainHeading(double fontSize) {
    return Text(
      "Welcome Back, $name",
      style:
          GoogleFonts.domine(fontSize: fontSize, fontWeight: FontWeight.w500),
    );
  }

  Widget desktopWidget(double width, double fiveWidth, double fiveHeight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainHeading(30),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child:
                      addAndSeeTodos(fiveHeight, width / 2, fiveWidth, false),
                ),
                const SizedBox(
                  width: 15,
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      todoStatus(fiveHeight, fiveWidth, 18),
                      const SizedBox(
                        height: 15,
                      ),
                      completedTodos(fiveHeight, fiveWidth, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabletWidget(double width, double fiveWidth, double fiveHeight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainHeading(25),
          const SizedBox(
            height: 60,
          ),
          todoStatus(fiveHeight / 1, fiveWidth * 1.25, 13),
          const SizedBox(
            height: 20,
          ),
          addAndSeeTodos(fiveHeight, width, fiveWidth, false),
          const SizedBox(
            height: 20,
          ),
          completedTodos(fiveHeight, fiveWidth, false),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget mobileWidget(double width, double fiveWidth, double fiveHeight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainHeading(20),
          const SizedBox(
            height: 60,
          ),
          todoMobileStatus(fiveHeight, fiveWidth * 1.1, 12),
          const SizedBox(
            height: 20,
          ),
          addAndSeeTodos(fiveHeight * 1.3, width, fiveWidth * 1.5, true),
          const SizedBox(
            height: 20,
          ),
          completedTodos(fiveHeight * 1.5, fiveWidth * 2, true),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget completedTodos(double height, double fiveWidth, bool isMobile) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;
    Color innerBoxColor = Theme.of(context).colorScheme.onSecondaryContainer;
    Color? boxHeadingColor = Theme.of(context).textTheme.labelLarge!.color;
    Color? boxDescriptionColor = Theme.of(context).textTheme.labelLarge!.color;
    Color? boxTextColor = Theme.of(context).textTheme.labelLarge!.color;

    return Container(
      padding:
          const EdgeInsets.only(top: 30.0, right: 30, left: 30, bottom: 30),
      height: height * 84,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_turned_in_outlined),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Completed Tasks",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList
                  .where((todo) => todo['status'] == 'Completed')
                  .length, // Number of items in the list
              itemBuilder: (context, index) {
                // Filter and get only incomplete tasks
                var filteredTodoList = todoList
                    .where((todo) => todo['status'] == 'Completed')
                    .toList();
                var todoItem = filteredTodoList[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 7,
                  ),
                  padding: const EdgeInsets.only(
                    top: 10,
                    right: 15,
                    left: 15,
                    bottom: 15,
                  ),
                  decoration: BoxDecoration(
                      color: innerBoxColor,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.circle_outlined,
                            size: 20,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: fiveWidth * 4,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: fiveWidth * 45,
                                  child: Text(
                                    todoItem['title'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: boxHeadingColor,
                                    ),
                                    maxLines:
                                        null, // Allows text to wrap to the next line
                                    overflow: TextOverflow
                                        .visible, // Text will not overflow
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  width: fiveWidth * 55,
                                  child: Text(
                                    todoItem['description'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: boxDescriptionColor),
                                    maxLines:
                                        null, // Allows text to wrap to the next line
                                    overflow: TextOverflow
                                        .visible, // Text will not overflow
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints:
                                const BoxConstraints(), // Removes any extra constraints
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_horiz_outlined,
                              size: fiveWidth * 5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isMobile)
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Status: ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: boxTextColor,
                                    ),
                                  ),
                                  Text(
                                    todoItem['status'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Completed: ${todoItem['createdOn']}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: boxTextColor,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Status: ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: boxTextColor,
                                  ),
                                ),
                                Text(
                                  todoItem['status'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Completed: ${todoItem['createdOn']}",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: boxTextColor,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget addAndSeeTodos(
      double height, double width, double fiveWidth, bool isMobile) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;
    Color innerBoxColor = Theme.of(context).colorScheme.onSecondaryContainer;
    Color? boxHeadingColor = Theme.of(context).textTheme.labelLarge!.color;
    Color? boxDescriptionColor = Theme.of(context).textTheme.labelLarge!.color;
    Color? boxTextColor = Theme.of(context).textTheme.labelLarge!.color;
    Color borderColor =
        Theme.of(context).inputDecorationTheme.border!.borderSide.color;

    return Container(
      height: height * 130,
      width: width,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 30.0, right: 30, left: 30, bottom: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "To-Do",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showAddTodoDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                        color: innerBoxColor,
                        border: Border.all(
                          color: borderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add Task",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoList
                    .where((todo) => todo['status'] != 'Completed')
                    .length, // Number of items in the list
                itemBuilder: (context, index) {
                  // Filter and get only incomplete tasks
                  var filteredTodoList = todoList
                      .where((todo) => todo['status'] != 'Completed')
                      .toList();
                  var todoItem = filteredTodoList[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    padding: const EdgeInsets.only(
                      top: 10,
                      right: 15,
                      left: 15,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                        color: innerBoxColor,
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              size: 20,
                              color: todoItem['status'] == "In Progress"
                                  ? Colors.blue
                                  : Colors.red,
                            ),
                            SizedBox(
                              width: fiveWidth * 4,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: fiveWidth * 50,
                                    child: Text(
                                      todoItem['title'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: boxHeadingColor,
                                      ),
                                      maxLines:
                                          null, // Allows text to wrap to the next line
                                      overflow: TextOverflow
                                          .visible, // Text will not overflow
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: fiveWidth * 55,
                                    child: Text(
                                      todoItem['description'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: boxDescriptionColor,
                                      ),
                                      textAlign: TextAlign.start,
                                      maxLines:
                                          null, // Allows text to wrap to the next line
                                      overflow: TextOverflow
                                          .visible, // Text will not overflow
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints:
                                  const BoxConstraints(), // Removes any extra constraints
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz_outlined,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (isMobile)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 20, top: 0, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Priority: ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: boxTextColor,
                                      ),
                                    ),
                                    Text(
                                      todoItem['priority'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.lightBlueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Status: ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: boxTextColor,
                                      ),
                                    ),
                                    Text(
                                      todoItem['status'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color:
                                            todoItem['status'] == "In Progress"
                                                ? Colors.blue
                                                : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Created On: ${todoItem['createdOn']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: boxTextColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 20, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Priority: ",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: boxTextColor,
                                          ),
                                        ),
                                        Text(
                                          todoItem['priority'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.lightBlueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Status: ",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: boxTextColor,
                                          ),
                                        ),
                                        Text(
                                          todoItem['status'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: todoItem['status'] ==
                                                    "In Progress"
                                                ? Colors.blue
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 20, top: 0, bottom: 10),
                                child: Text(
                                  "Created On: ${todoItem['createdOn']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: boxTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget todoStatus(double height, double fiveWidth, double fontSize) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;

    return Container(
      height: fiveWidth * 42,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: SizedBox(
          height: fiveWidth * 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Completed Todos Gauge
              _buildGauge(
                label: 'Completed',
                percentage: completedPercentage,
                color: Colors.green,
                fiveWidth: fiveWidth,
                fontSize: fontSize,
              ),
              // Pending Todos Gauge
              _buildGauge(
                label: 'Pending',
                percentage: pendingPercentage,
                color: Colors.orange,
                fiveWidth: fiveWidth,
                fontSize: fontSize,
              ),
              // In Progress Todos Gauge
              _buildGauge(
                label: 'In Progress',
                percentage: inProgressPercentage,
                color: Colors.blue,
                fiveWidth: fiveWidth,
                fontSize: fontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget todoMobileStatus(double height, double fiveWidth, double fontSize) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;

    return Container(
      height: fiveWidth * 300,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Completed Todos Gauge
            _buildGauge(
              label: 'Completed',
              percentage: completedPercentage,
              color: Colors.green,
              fiveWidth: fiveWidth * 2.8,
              fontSize: fontSize,
            ),
            // Pending Todos Gauge
            _buildGauge(
              label: 'Pending',
              percentage: pendingPercentage,
              color: Colors.orange,
              fiveWidth: fiveWidth * 2.8,
              fontSize: fontSize,
            ),
            // In Progress Todos Gauge
            _buildGauge(
              label: 'In Progress',
              percentage: inProgressPercentage,
              color: Colors.blue,
              fiveWidth: fiveWidth * 2.8,
              fontSize: fontSize,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create individual full-circle gauges
  Widget _buildGauge(
      {required String label,
      required double percentage,
      required Color color,
      required double fiveWidth,
      required double fontSize}) {
    Color? boxDescriptionColor = Theme.of(context).textTheme.labelLarge!.color;

    return Column(
      children: [
        SizedBox(
          height: fiveWidth * 29,
          width: fiveWidth * 29,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: 100,
                startAngle: 0,
                endAngle: 360,
                showLabels: false,
                showTicks: false,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.15,
                  cornerStyle: CornerStyle.bothCurve,
                  color: Colors.grey[200]!,
                  thicknessUnit: GaugeSizeUnit.factor,
                ),
                pointers: <GaugePointer>[
                  RangePointer(
                    value: percentage,
                    cornerStyle: CornerStyle.bothCurve,
                    width: 0.15,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: color,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          label,
                          style: TextStyle(
                              fontSize: fontSize, color: boxDescriptionColor),
                        ),
                      ],
                    ),
                    angle: 90,
                    positionFactor:
                        0.1, // Controls the positioning of the text inside the gauge
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
