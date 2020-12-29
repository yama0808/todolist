import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task.dart';
import 'package:todo_app/providers/tasks.dart';
import 'package:todo_app/widgets/date_chip.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends StatefulWidget {
  static const routeName = '/add-task';

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  bool _isShowAddDetailTextField = false;
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  DateTime _date;
  FocusNode myFocusNode;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date != null ? _date : DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    if (picked != null) setState(() => _date = picked);
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: '新しいタスク',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _titleController.text = value;
                    },
                  ),
                  (_isShowAddDetailTextField)
                      ? TextFormField(
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          maxLines: null,
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            hintText: '詳細を追加',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            _detailController.text = value;
                          },
                        )
                      : SizedBox.shrink()
                ],
              ),
              (_date == null)
                  ? SizedBox.shrink()
                  : DateChip(
                      date: _date,
                    ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        _isShowAddDetailTextField = true;
                        myFocusNode.requestFocus();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      // カレンダー表示
                      _selectDate(context);
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      final newTask = Task(
                        id: Uuid().v4(),
                        title: _titleController.text,
                        detail: _detailController.text,
                        due: _date,
                        createdAt: DateTime.now(),
                      );
                      Provider.of<Tasks>(context, listen: false)
                          .addTask(newTask)
                          .then(
                            (_) => Navigator.pop(context),
                          );
                    },
                    child: Text(
                      '保存',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
