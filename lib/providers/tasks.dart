import 'package:flutter/foundation.dart';
import 'package:todo_app/helpers/db_helper.dart';
import 'package:todo_app/providers/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _items = [];

  List<Task> get items {
    return [..._items];
  }

  List<Task> get doneItems {
    return _items.where((prodItem) => prodItem.isDone).toList();
  }

  Task findById(String id) {
    return _items.firstWhere((task) => task.id == id);
  }

  Future<void> fetchAndSetTasks() async {
    final dataList = await DBHelper.getData('tasks');
    if (dataList != null) {
      _items = dataList
          .map(
            (item) => Task(
              id: item['id'],
              title: item['title'],
              detail: item['detail'],
              due: DateTime.parse(item['due']),
              createdAt: DateTime.parse(item['createdAt']),
              isDone: item['isDone'] == 0 ? true : false,
            ),
          )
          .toList();
      notifyListeners();
    }
  }

  Future<void> addTask(Task task) async {
    final newTask = Task(
      id: task.id,
      title: task.title,
      detail: task.detail,
      due: task.due,
      createdAt: task.createdAt,
    );
    _items.add(newTask);
    notifyListeners();
    DBHelper.insert('tasks', {
      'id': task.id,
      'title': task.title,
      'detail': task.detail,
      'due': task.due.toString(),
      'createdAt': task.createdAt.toString(),
      'isDone': task.isDone ? 0 : 1,
    });
  }

  Future<void> updateTask(String id, Task newTask) async {
    final taskIndex = _items.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      _items[taskIndex] = newTask;
      DBHelper.update('tasks', {
        'id': newTask.id,
        'title': newTask.title,
        'detail': newTask.detail,
        'due': newTask.due.toString(),
        'createdAt': newTask.createdAt.toString(),
        'isDone': newTask.isDone ? 0 : 1,
      });
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteTask(String id) async {
    final existingTaskIndex = _items.indexWhere((product) => product.id == id);
    _items.removeAt(existingTaskIndex);
    DBHelper.delete('tasks', id);
    notifyListeners();
  }
}
