import 'dart:developer';

import 'package:aiponics_web_app/models/todos/todos_model.dart';
import 'package:aiponics_web_app/provider/todo%20provider/todo_provider.dart';
import 'package:aiponics_web_app/views/sideBar ( Drawer Screens )/data/todos/add_todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ViewTodos extends ConsumerStatefulWidget {
  const ViewTodos({super.key});

  @override
  ConsumerState<ViewTodos> createState() => _ViewTodosState();
}

class _ViewTodosState extends ConsumerState<ViewTodos> {
  String name = "Ahmad Ali";

  List<TodoModel> allTodoList = [];
  List<TodoModel> pendingOrInProgressTodosList = [];
  List<TodoModel> completedTodosList = [];

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size to make the layout responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final fiveWidth = screenWidth * 0.003434;
    final fiveHeight = screenHeight * 0.005681;

    allTodoList = ref.watch(todosProvider).todos;

    completedTodosList = allTodoList
        .where((todo) => todo.status.toLowerCase() == 'completed')
        .toList();

    pendingOrInProgressTodosList = allTodoList
        .where((todo) => todo.status.toLowerCase() != 'completed')
        .toList();

    totalTodos = allTodoList.length;
    completedTodo = completedTodosList.length;
    pendingTodos = allTodoList.where((todo) => todo.status.toLowerCase() == 'pending').length;
    inProgressTodos = allTodoList.where((todo) => todo.status.toLowerCase() == 'in progress').length;

    completedPercentage = totalTodos > 0 ? (completedTodo / totalTodos) * 100 : 0;
    pendingPercentage = totalTodos > 0 ? (pendingTodos / totalTodos) * 100 : 0;
    inProgressPercentage = totalTodos > 0 ? (inProgressTodos / totalTodos) * 100 : 0;

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
    Color circularColor = Theme.of(context).colorScheme.onSecondaryFixed;

    return Container(
      padding:
          const EdgeInsets.only(top: 30.0, right: 30, left: 30, bottom: 30),
      height: height * 84,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: (ref.watch(todosProvider).isLoading || completedTodosList.isEmpty ) ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if(ref.watch(todosProvider).isLoading)...[
            CircularProgressIndicator(color: circularColor,)
          ]else if(completedTodosList.isEmpty)...[
            Text(
              "No Completed Todos Found",
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            )
          ]else...[
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
              itemCount: completedTodosList.length, // Number of items in the list
              itemBuilder: (context, index) {
                // Filter and get only incomplete tasks
                var todoItem = completedTodosList[index];

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
                                    todoItem.title,
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
                                    todoItem.taskDescription,
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
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onSelected: (value) {
                              if (value == 'delete') {
                                ref.read(todosProvider.notifier).deleteTodo(todoItem.id);
                              } else if (value == 'toggle_status') {
                                ref.read(todosProvider.notifier).updateTodo(
                                    TodoModel(
                                        id: todoItem.id,
                                        dueDate: todoItem.dueDate,
                                        createdOn: todoItem.createdOn,
                                        priority: todoItem.priority,
                                        title: todoItem.title,
                                        status: todoItem.status == "completed" ? "pending" : "completed",
                                        taskDescription: todoItem.taskDescription)
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.more_horiz_outlined,
                              size: 25,
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text("Delete"),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'toggle_status',
                                child: Row(
                                  children: [
                                    const Icon(Icons.sync_alt, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(todoItem.status == "completed" ? "Mark as Pending" : "Mark as Completed"),
                                  ],
                                ),
                              ),
                            ],
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
                                    todoItem.status.toLowerCase(),
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
                                "Due Date: ${todoItem.dueDate}",
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
                                  todoItem.status.toLowerCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Created On: ${todoItem.createdOn}",
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
          ]
        ],
      ),
    );
  }

  Widget addAndSeeTodos(double height, double width, double fiveWidth, bool isMobile) {
    Color boxColor = Theme.of(context).colorScheme.onSecondary;
    Color innerBoxColor = Theme.of(context).colorScheme.onSecondaryContainer;
    Color? boxHeadingColor = Theme.of(context).textTheme.labelLarge!.color;
    Color? boxDescriptionColor = Theme.of(context).textTheme.labelLarge!.color;
    Color? boxTextColor = Theme.of(context).textTheme.labelLarge!.color;
    Color borderColor = Theme.of(context).inputDecorationTheme.border!.borderSide.color;
    Color circularColor = Theme.of(context).colorScheme.onSecondaryFixed;

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
          mainAxisAlignment: (ref.watch(todosProvider).isLoading || pendingOrInProgressTodosList.isEmpty ) ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            if(ref.watch(todosProvider).isLoading)...[
              Center(child: CircularProgressIndicator(color: circularColor,))
            ]else if(pendingOrInProgressTodosList.isEmpty)...[
              Center(
                child: Text(
                  "No Pending Todos Found",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              )
            ]else...[
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
                  itemCount: pendingOrInProgressTodosList.length, // Number of items in the list
                  itemBuilder: (context, index) {
                    // Filter and get only incomplete tasks
                    var todoItem = pendingOrInProgressTodosList[index];

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
                                color: todoItem.status.toLowerCase() == "In Progress"
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
                                        todoItem.title,
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
                                        todoItem.taskDescription,
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
                              PopupMenuButton<String>(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    ref.read(todosProvider.notifier).deleteTodo(todoItem.id);
                                  } else if (value == 'toggle_status') {
                                    ref.read(todosProvider.notifier).updateTodo(
                                      TodoModel(
                                          id: todoItem.id,
                                          dueDate: todoItem.dueDate,
                                          createdOn: todoItem.createdOn,
                                          priority: todoItem.priority,
                                          title: todoItem.title,
                                          status: todoItem.status == "completed" ? "pending" : "completed",
                                          taskDescription: todoItem.taskDescription)
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.more_horiz_outlined,
                                  size: 25,
                                ),
                                itemBuilder: (context) => [
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'toggle_status',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.sync_alt, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(todoItem.status == "completed" ? "Mark as Pending" : "Mark as Completed"),
                                      ],
                                    ),
                                  ),
                                ],
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
                                        todoItem.priority,
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
                                        todoItem.status.toLowerCase(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color:
                                          todoItem.status.toLowerCase() == "In Progress"
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
                                    "Created On: ${todoItem.createdOn}",
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
                                            todoItem.priority,
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
                                            todoItem.status.toLowerCase(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: todoItem.status.toLowerCase() ==
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
                                    "Created On: ${todoItem.createdOn}",
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
            ]

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
