import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task.dart';
import 'package:todo_app/providers/tasks.dart';

class EditTaskScreen extends StatefulWidget {
  static const routeName = '/edit-task';

  final Task task;

  EditTaskScreen({
    this.task,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  DateTime _date;

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
    _titleController.text = widget.task.title;
    _detailController.text = widget.task.detail;
    _date = widget.task.due;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60.0,
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 60.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                          ),
                          onPressed: () {
                            final task = Task(
                              id: widget.task.id,
                              title: _titleController.text,
                              detail: _detailController.text,
                              due: _date,
                              createdAt: DateTime.now(),
                            );
                            Provider.of<Tasks>(context, listen: false)
                                .updateTask(widget.task.id, task)
                                .then(
                                  (_) => Navigator.pop(context),
                                );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                          ),
                          onPressed: () {
                            Navigator.pop(context, widget.task.id);
                          },
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue: widget.task.title,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      hintText: 'タイトルを入力',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _titleController.text = value;
                    },
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.menu,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: widget.task.detail,
                          decoration: InputDecoration(
                            hintText: '詳細を追加',
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          onChanged: (value) {
                            _detailController.text = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Text(
                            _date == null
                                ? '日時を追加'
                                : DateFormat('MM月dd日').format(_date),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
