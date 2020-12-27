import 'package:flutter/foundation.dart';
import 'package:todo_app/helpers/db_helper.dart';

class Task with ChangeNotifier {
  final String id;
  final String title;
  final String detail;
  final DateTime due;
  final DateTime createdAt;
  bool isDone;

  Task({
    this.id,
    this.title,
    this.detail,
    this.due,
    this.createdAt,
    this.isDone = false,
  });

  void _setDoneValue(bool newValue) {
    isDone = newValue;
    notifyListeners();
  }

  void toggleDoneStatus() {
    isDone = !isDone;
    notifyListeners();
    DBHelper.update('tasks', {
      'isDone': isDone ? 0 : 1,
    });
  }
}
