import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/common_methods.dart';
import '../../controllers/todo controller/todo_controller.dart';
import '../../models/todos/todos_model.dart';

class TodosNotifier extends StateNotifier<TodosModelForProvider> {
  TodosNotifier()
      : super(TodosModelForProvider(
    todos: [],
    isLoading: true,
    isError: false,
    
    textFieldHeight: 200.0,
  )) {
    // Automatically check the state.
    addListener(_autoFetchIfNull);

    // Initial fetch if the todos list is empty.
    if (_isNull()) {
      fetchTodos();
    } else {
      state = TodosModelForProvider(
        todos: state.todos,
        isLoading: false,
        isError: false,
        
        textFieldHeight: 200.0,
      );
    }
  }

  /// Checks if the todos list is empty.
  bool _isNull() {
    return state.todos.isEmpty;
  }

  /// Listener to automatically fetch todos if state becomes "null".
  void _autoFetchIfNull(TodosModelForProvider newState) {
    if (newState.todos.isEmpty && !newState.isLoading && !newState.isError) {
      fetchTodos();
    }
  }

  /// Fetches todos from the API.
  Future<void> fetchTodos() async {
    state = TodosModelForProvider(
      todos: state.todos,
      isLoading: true,
      isError: false,
      
      textFieldHeight: 200.0,
    );

    try {
      List<TodoModel> fetchedTodos = await TodoApi.getTodos();
      if (fetchedTodos.isEmpty) {
        state = TodosModelForProvider(
          todos: fetchedTodos,
          isLoading: false,
          isError: true,
           
          textFieldHeight: 200.0,
        );
      } else if (fetchedTodos[0].id == 0) {
        state = TodosModelForProvider(
          todos: fetchedTodos,
          isLoading: false,
          isError: false,
           
    textFieldHeight: 200.0,
        );
      } else {
        state = TodosModelForProvider(
          todos: fetchedTodos,
          isLoading: false,
          isError: false,
           
    textFieldHeight: 200.0,
        );
      }
    } catch (error) {
      state = TodosModelForProvider(
        todos: state.todos,
        isLoading: false,
        isError: true,
        
        textFieldHeight: 200.0,
      );
    }
  }

  /// Adds a new todo and updates the state.
  Future<void> addTodo(TodoModel newTodo) async {
    state = TodosModelForProvider(
      todos: state.todos,
      isLoading: true,
      isError: false,
    textFieldHeight: 200.0,
    );

    try {
      TodoModel createdTodo = await TodoApi.addTodo(newTodo);
      if (createdTodo.id == 0) {
        state = TodosModelForProvider(
          todos: [],
          isLoading: false,
          isError: false,
          textFieldHeight: 200.0,
          todoForEditingOrAdding: newTodo,
        );
        CommonMethods.showSnackBarWithoutContext("Error while adding todo", "Something went wrong", "failure");
      }else{
        final updatedTodos = [...state.todos, createdTodo];
        state = TodosModelForProvider(
          todos: updatedTodos,
          isLoading: false,
          isError: false,
          textFieldHeight: 200.0,
          todoForEditingOrAdding: newTodo,
        );
        CommonMethods.showSnackBarWithoutContext("Success", "Successfully Added Todo", "success");
      }
      // Update state by adding the new todo.

    } catch (error) {
      state = TodosModelForProvider(
        todos: state.todos,
        isLoading: false,
        isError: true,
         
    textFieldHeight: 200.0,
      );
    }
  }

  /// Updates an existing todo and updates the state.
  Future<void> updateTodo(TodoModel updatedTodo) async {
    state = TodosModelForProvider(
      todos: state.todos,
      isLoading: true,
      isError: false,
      textFieldHeight: 200.0,
    );

    try {
      bool status = await TodoApi.updateTodo(updatedTodo);
      // Update the specific todo in the list.
      if(status){
        List<TodoModel> updatedTodos = state.todos.map((todo) {
          if (todo.id == updatedTodo.id) {
            return updatedTodo;
          }
          return todo;
        }).toList();
        state = TodosModelForProvider(
          todos: updatedTodos,
          isLoading: false,
          isError: false,
          textFieldHeight: 200.0,
        );
        CommonMethods.showSnackBarWithoutContext("Success", "Successfully Updated Todo", "success");
      } else{
        CommonMethods.showSnackBarWithoutContext("Failed", "Failed to update Todo", "failure");
      }

    } catch (error) {
      state = TodosModelForProvider(
        todos: state.todos,
        isLoading: false,
        isError: true,
         
    textFieldHeight: 200.0,
      );
    }
  }

  void updateTodoForEditingOrAdding(TodoModel todo) {
    state = TodosModelForProvider(
      todos: state.todos,
      isLoading: state.isLoading,
      isError: state.isError,
      todoForEditingOrAdding: todo,
      textFieldHeight: 200.0,
    );
  }

  void updateDescriptionFieldHeight(DragUpdateDetails details){
    state.textFieldHeight += details.delta.dy;
  }

  /// Deletes a todo by id and updates the state.
  Future<void> deleteTodo(int todoId) async {
    state = TodosModelForProvider(
      todos: state.todos,
      isLoading: true,
      isError: false,
       
    textFieldHeight: 200.0,
    );

    try {
      bool success = await TodoApi.deleteTodo(todoId);
      if (success) {
        List<TodoModel> updatedTodos = state.todos.where((todo) => todo.id != todoId).toList();
        state = TodosModelForProvider(
          todos: updatedTodos,
          isLoading: false,
          isError: false,
           
    textFieldHeight: 200.0,
        );
        CommonMethods.showSnackBarWithoutContext("Success", "Successfully Deleted Todo", "success");
      } else {
        state = TodosModelForProvider(
          todos: state.todos,
          isLoading: false,
          isError: true,
           
    textFieldHeight: 200.0,

        );
        CommonMethods.showSnackBarWithoutContext("Failed", "Failed to delete Todo", "failure");
      }
    } catch (error) {
      state = TodosModelForProvider(
        todos: state.todos,
        isLoading: false,
        isError: true,
         
    textFieldHeight: 200.0,
      );
      CommonMethods.showSnackBarWithoutContext("Failed", "Failed to delete Todo", "failure");
    }
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, TodosModelForProvider>(
      (ref) => TodosNotifier(),
);
