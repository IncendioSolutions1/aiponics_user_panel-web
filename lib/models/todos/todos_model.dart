// todo_model.dart

import 'package:intl/intl.dart';

class TodoModel {
  final int id;
  final String dueDate;
  final String createdOn;
  final String priority;
  final String title;
  final String status;
  final String taskDescription;

  TodoModel({
    required this.id,
    required this.dueDate,
    required this.createdOn,
    required this.priority,
    required this.title,
    required this.status,
    required this.taskDescription,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      dueDate: json['due_date'],
      createdOn: DateFormat('yyyy-MM-dd').format(DateTime.parse(json['created_at'])),
      priority: json['priority'],
      status: json['status'],
      title: json['title'],
      taskDescription: json['task_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'due_date': dueDate,
      'created_on': createdOn,
      'priority': priority,
      'status': status,
      'title': title,
      'task_description': taskDescription,
    };
  }
}

class TodosModelForProvider{
  List<TodoModel> todos;
  bool isLoading;
  bool isError;
  TodoModel? todoForEditingOrAdding;
  double textFieldHeight;

  TodosModelForProvider({
    required this.todos,
    required this.isLoading,
    required this.isError,
    this.todoForEditingOrAdding,
    required this.textFieldHeight,
});

}