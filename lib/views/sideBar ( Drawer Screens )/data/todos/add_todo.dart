import 'dart:developer';

import 'package:aiponics_web_app/models/todos/todos_model.dart';
import 'package:aiponics_web_app/provider/todo%20provider/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class AddTodo extends ConsumerStatefulWidget {
  final bool isEditing;
  const AddTodo({super.key, this.isEditing = false});

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  late String _selectedPriority;

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd')
.format(picked);
    }
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      log("Title: ${_titleController.text}");
      log("Date: ${_dateController.text}");
      log("Priority: $_selectedPriority");
      log("Description: ${_descriptionController.text}");

      if(widget.isEditing){
        ref.read(todosProvider.notifier).updateTodo(
            TodoModel(
              id: ref.watch(todosProvider).todoForEditingOrAdding!.id,
              dueDate: _dateController.text,
              createdOn : DateFormat('yyyy-MM-dd').format(DateTime.now()),
              priority: _selectedPriority.toLowerCase(),
              title: _titleController.text,
              status: 'pending',
              taskDescription: _descriptionController.text,
            ));
      }else{
        ref.read(todosProvider.notifier).addTodo(
            TodoModel(
                id: 0,
              dueDate: _dateController.text,
              createdOn : DateFormat('yyyy-MM-dd').format(DateTime.now()),
              priority: _selectedPriority.toLowerCase(),
              title: _titleController.text,
              status: 'pending',
              taskDescription: _descriptionController.text,
            ));
      }

    }
  }

  void _setPriority(String priority) {
    ref.read(todosProvider.notifier).updateTodoForEditingOrAdding(
      TodoModel(id: 0,               createdOn : DateFormat('yyyy-MM-dd').format(DateTime.now()),
          dueDate: _dateController.text, priority: priority, title: _titleController.text, status: "pending", taskDescription: _descriptionController.text)
    );
  }

  @override
  void initState() {
    final todoProvider = ref.read(todosProvider);
    if (widget.isEditing && todoProvider.todoForEditingOrAdding != null) {
      final selected = todoProvider.todoForEditingOrAdding!;
      _titleController.text = selected.title;
      _descriptionController.text = selected.taskDescription;
      _dateController.text = DateFormat('yyyy-MM-dd')
.format(
        DateFormat('yyyy-MM-dd')
.parse(selected.dueDate),
      );
      _selectedPriority = selected.priority;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _selectedPriority = ref.watch(todosProvider).todoForEditingOrAdding?.priority ?? 'Low';

    return Scaffold(
      body: Form(
        key: _formKey,
        child: LayoutBuilder(builder: (_, constraints) {
          final isMobile = constraints.maxWidth < 700;
          return Padding(
            padding: const EdgeInsets.fromLTRB(100, 80, 50, 50),
            child: _mainContent(isMobile),
          );
        }),
      ),
    );
  }


  Widget _buildTextLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.raleway(fontSize: 18, letterSpacing: 2),
    );
  }

  Widget _buildPrioritySelector(bool isMobile) {
    final priorities = [
      {'label': 'High', 'color': Colors.red},
      {'label': 'Medium', 'color': Colors.orange},
      {'label': 'Low', 'color': Colors.green},
    ];

    final children = priorities.map((item) {
      final label = item['label'] as String;
      final color = item['color'] as Color;

      return Padding(
        padding: EdgeInsets.only(bottom: isMobile ? 5 : 0),
        child: SizedBox(
          width: 180,
          child: Row(
            children: [
              Checkbox(
                value: _selectedPriority == label,
                onChanged: (_) => _setPriority(label),
                activeColor: color,
              ),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
        ),
      );
    }).toList();

    return isMobile
        ? Column(children: children)
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children);
  }

  Widget _buildDescriptionField() {
    return GestureDetector(
      onPanUpdate: (details) {
        ref.read(todosProvider.notifier).updateDescriptionFieldHeight(details);
      },
      child: Container(
        height: ref.watch(todosProvider).textFieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: _descriptionController,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Start writing here......',
            hintStyle: TextStyle(fontSize: 13),
          ),
          validator: (value) =>
          value == null || value.isEmpty ? 'Please enter a description' : null,
        ),
      ),
    );
  }

  Widget _buildSaveButton(Color boxColor) {
    return ElevatedButton(
      onPressed: _saveTodo,
      style: ElevatedButton.styleFrom(
        backgroundColor: boxColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 10,
        shadowColor: Colors.black.withAlpha(75),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.save, color: Colors.white),
          SizedBox(width: 10),
          Text('Save ToDo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _mainContent(bool isMobile) {
    final boxColor = Theme.of(context).colorScheme.onSecondaryFixed;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add a New Todo",
              style: GoogleFonts.raleway(fontSize: 30, fontWeight: FontWeight.w500)),
          const SizedBox(height: 60),

          _buildTextLabel("Title"),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _titleController,
            hint: "Enter title",
            validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
          ),

          const SizedBox(height: 40),
          _buildTextLabel("Select Due Date"),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _pickDate(context),
            decoration: const InputDecoration(suffixIcon: Icon(Icons.calendar_today)),
            validator: (val) => val == null || val.isEmpty ? 'Please enter a date' : null, hint: '',
          ),

          const SizedBox(height: 40),
          _buildTextLabel("Priority"),
          const SizedBox(height: 15),
          _buildPrioritySelector(isMobile),

          const SizedBox(height: 40),
          _buildTextLabel("Task Description"),
          const SizedBox(height: 15),
          _buildDescriptionField(),

          const SizedBox(height: 32),
          _buildSaveButton(boxColor),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
    InputDecoration? decoration,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: decoration ?? const InputDecoration(),
    );
  }
}
