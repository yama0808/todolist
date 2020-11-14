import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('tasks').get();
    snapshot.docs.forEach((data) {
      Timestamp createdAt = data.data()['createdAt'];
      Timestamp due = data.data()['due'];
      final task = Task(
        id: data.id,
        title: data.data()['title'],
        detail: data.data()['detail'],
        due: due.toDate(),
        createdAt: createdAt.toDate(),
      );
      _items.add(task);
    });
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('tasks').doc();
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(documentReference.id)
        .set({
      'id': documentReference.id,
      'title': task.title,
      'detail': task.detail,
      'due': task.due,
      'createdAt': task.createdAt,
    }).then((value) {
      final newTask = Task(
        id: documentReference.id,
        title: task.title,
        detail: task.detail,
        due: task.due,
        createdAt: task.createdAt,
      );
      _items.add(newTask);
      notifyListeners();
    });
  }

  Future<void> updateTask(String id, Task newTask) async {
    final taskIndex = _items.indexWhere((task) => task.id == id);
    if (taskIndex >= 0) {
      FirebaseFirestore.instance.collection('tasks').doc(id).update({
        'id': newTask.id,
        'title': newTask.title,
        'detail': newTask.detail,
        'due': newTask.due,
        'createdAt': newTask.createdAt,
      }).then((_) {
        _items[taskIndex] = newTask;
        notifyListeners();
      });
    } else {
      print('...');
    }
  }

  Future<void> deleteTask(String id) async {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(id)
        .delete()
        .then((value) {
      final existingTaskIndex =
          _items.indexWhere((product) => product.id == id);
      _items.removeAt(existingTaskIndex);
      notifyListeners();
    });
  }
}
