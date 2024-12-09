import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
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

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = 'Low'; // Default value
  double _textFieldHeight = 200.0; // Initial height for text field

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('d MMM, yyyy').format(picked);
      });
    }
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      // Process the input (e.g., save the data to a database or display it in a list)
      log("Title: ${_titleController.text}");
      log("Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'No date selected'}");
      log("Priority: $_selectedPriority");
      log("Description: ${_descriptionController.text}");
    }
  }

  void _setPriority(String priority) {
    setState(() {
      _selectedPriority = priority;
    });
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

          if (constraints.maxWidth >= 700) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
                left: 100,
                right: 50,
                bottom: 50,
              ),
              child: desktopWidget(width, fiveWidth, fiveHeight),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                top: 80.0,
                left: 100,
                right: 50,
                bottom: 50,
              ),
              child: mobileWidget(width, fiveWidth, fiveHeight),
            );
          }
        },
      ),
    );
  }

  Widget mainHeading(double fontSize) {
    return Text(
      "Add a New Todo",
      style:
          GoogleFonts.domine(fontSize: fontSize, fontWeight: FontWeight.w500),
    );
  }

  Widget desktopWidget(double width, double fiveWidth, double fiveHeight) {
    Color boxColor = Theme.of(context).colorScheme.onSecondaryFixed;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // This ensures the dialog isn't fullscreen
        children: [
          mainHeading(30),
          const SizedBox(
            height: 60,
          ),
          // Title Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Select Date Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Date",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                onTap: () {
                  log("Clicked date picker field");
                  _pickDate(context);
                },
                controller: _dateController,
                readOnly: true, // User cannot manually type in the field
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Priority
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Priority",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 180, child: _buildCheckbox('High', Colors.red)),
                  SizedBox(
                      width: 180,
                      child: _buildCheckbox('Medium', Colors.orange)),
                  SizedBox(
                      width: 180, child: _buildCheckbox('Low', Colors.green)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Description Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Task Description",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Drag to resize the height of the text field
                    _textFieldHeight += details.delta.dy;
                  });
                },
                child: Container(
                  height: _textFieldHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null, // Allows text field to grow
                    expands: true, // Fills the available container height
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Start writing here......',
                      hintStyle: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Save Button
          ElevatedButton(
            onPressed: _saveTodo,
            style: ElevatedButton.styleFrom(
              backgroundColor: boxColor, // Background color
              padding: const EdgeInsets.symmetric(
                  horizontal: 30, vertical: 15), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              elevation: 10, // Shadow elevation
              shadowColor: Colors.black.withOpacity(0.3), // Shadow color
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.save, color: Colors.white), // Save icon
                SizedBox(width: 10),
                Text(
                  'Save ToDo',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileWidget(double width, double fiveWidth, double fiveHeight) {
    Color boxColor = Theme.of(context).colorScheme.onSecondaryFixed;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // This ensures the dialog isn't fullscreen
        children: [
          mainHeading(30),
          const SizedBox(
            height: 60,
          ),
          // Title Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Select Date Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Date",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                onTap: () {
                  log("Clicked date picker field");
                  _pickDate(context);
                },
                controller: _dateController,
                readOnly: true, // User cannot manually type in the field
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Priority
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Priority",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: 180, child: _buildCheckbox('High', Colors.red)),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: 180,
                      child: _buildCheckbox('Medium', Colors.orange)),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      width: 180, child: _buildCheckbox('Low', Colors.green)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Description Field
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Task Description",
                style: GoogleFonts.domine(
                  fontSize: 18,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Drag to resize the height of the text field
                    _textFieldHeight += details.delta.dy;
                  });
                },
                child: Container(
                  height: _textFieldHeight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null, // Allows text field to grow
                    expands: true, // Fills the available container height
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Start writing here......',
                      hintStyle: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Save Button
          ElevatedButton(
            onPressed: _saveTodo,
            style: ElevatedButton.styleFrom(
              backgroundColor: boxColor, // Background color
              padding: const EdgeInsets.symmetric(
                  horizontal: 30, vertical: 15), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              elevation: 10, // Shadow elevation
              shadowColor: Colors.black.withOpacity(0.3), // Shadow color
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.save, color: Colors.white), // Save icon
                SizedBox(width: 10),
                Text(
                  'Save ToDo',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String priorityLabel, Color color) {
    return CheckboxListTile(
      title: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(priorityLabel),
        ],
      ),
      activeColor: Colors.green,
      value: _selectedPriority == priorityLabel,
      onChanged: (bool? value) {
        if (value == true) {
          _setPriority(priorityLabel);
        }
      },
      controlAffinity:
          ListTileControlAffinity.trailing, // Checkbox before the label
    );
  }
}
