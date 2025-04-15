import 'dart:developer';
import 'package:aiponics_web_app/models/todos/todos_model.dart';
import 'package:dio/dio.dart';
import 'package:aiponics_web_app/api%20information/api_constants.dart';
import 'package:aiponics_web_app/controllers/token%20controllers/access_and_refresh_token_controller.dart';

class TodoApi {
  /// Fetches the list of todos from the API.
  static Future<List<TodoModel>> getTodos() async {
    List<TodoModel> todos = [];

    // Get access token.
    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      return todos;
    }

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ));

      final response = await dio.get(
        todosApi, // Defined in api_constants.dart (e.g. 'https://yourapi.com/todos')
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
      );

      log("TODO_API: Received response with status code ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("TODO_API: Response Data: ${response.data}");

        // Check if response.data is a list and if it's empty.
        if (response.data is List && response.data.isEmpty) {
          log("TODO_API: The response returned an empty list of todos.");
          todos.add(
            TodoModel(
              id: 0,
              title: '',
              dueDate: '',
              createdOn: '',
              priority: '',
              status: '',
              taskDescription: '',
            ),
          );
        } else {
          // If the API response returns a list of JSON objects, create the todos list.
          for (var todoJson in response.data) {
            todos.add(TodoModel.fromJson(todoJson));
          }
        }
      } else {
        log("TODO_API: Response error ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("TODO_API: Request failed: ${e.message} - ${e.response?.data}");
    }
    return todos;
  }

  /// Adds a new todo via API.
  static Future<TodoModel> addTodo(TodoModel newTodo) async {
    TodoModel addedTodo = newTodo;

    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      return addedTodo;
    }

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ));

      log("TODO_API (ADD): Sending request to $todosApi");
      log("TODO_API (ADD): Request body: ${newTodo.toJson()}");

      final response = await dio.post(
        todosApi,
        data: newTodo.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
      );

      log("TODO_API (ADD): Received response with status code ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        addedTodo = TodoModel.fromJson(response.data);
      } else {
        log("TODO_API (ADD): Response error ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("TODO_API (ADD): Request failed: ${e.message} - ${e.response?.data}");
    }
    return addedTodo;
  }

  /// Updates an existing todo via API.
  static Future<bool> updateTodo(TodoModel updatedTodo) async {
    bool status = false;

    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      return status;
    }

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ));

      // Assuming the update endpoint is constructed as baseUrl/{id}
      final url = "$todosApi${updatedTodo.id}/";

      final response = await dio.put(
        url,
        data: updatedTodo.toJson(),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
      );

      log("TODO_API (UPDATE): Received response with status code ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        // newTodo = TodoModel.fromJson(response.data);
        status = true;
      } else {
        log("TODO_API (UPDATE): Response error ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("TODO_API (UPDATE): Request failed: ${e.message} - ${e.response?.data}");
    }
    return status;
  }

  /// Deletes a todo via API.
  static Future<bool> deleteTodo(int todoId) async {
    bool isDeleted = false;
    String? bearerToken = await fetchAccessToken();
    if (bearerToken == null) {
      return isDeleted;
    }

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
      ));

      // Assuming the delete endpoint is constructed as baseUrl/{id}
      final url = "$todosApi$todoId";

      final response = await dio.delete(
        url,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $bearerToken",
          },
        ),
      );

      log("TODO_API (DELETE): Received response with status code ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 204) {
        isDeleted = true;
      } else {
        log("TODO_API (DELETE): Response error ${response.statusCode}");
      }
    } on DioException catch (e) {
      log("TODO_API (DELETE): Request failed: ${e.message} - ${e.response?.data}");
    }
    return isDeleted;
  }
}
