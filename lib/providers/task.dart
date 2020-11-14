import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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

  void toggleDoneStatus() async {
    final oldStatus = isDone;
    isDone = !isDone;
    notifyListeners();

    FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'isDone': isDone,
    });
  }
}
