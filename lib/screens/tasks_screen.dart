import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task.dart';
import 'package:todo_app/providers/tasks.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/screens/edit_task_screen.dart';

class TasksScreen extends StatefulWidget {
  static const routeName = '/tasks';

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void initState() {
    super.initState();

    // Firebase.initializeApp().whenComplete(() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Tasks>(context, listen: false).fetchAndSetTasks().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
    // });
  }

  void buildBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) => AddTaskScreen(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<Tasks>(context).items;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 32.0,
        ),
        onPressed: () {
          buildBottomSheet(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.only(
                          top: 80.0,
                          left: 60.0,
                          right: 60.0,
                        ),
                        child: Text(
                          'My Tasks',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: tasks[index],
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 5.0,
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTaskScreen(
                                    task: tasks[index],
                                  ),
                                ),
                              );
                              if (result != null)
                                try {
                                  await Provider.of<Tasks>(context,
                                          listen: false)
                                      .deleteTask(result)
                                      .then((_) {
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '１件のタスクを削除しました',
                                        ),
                                      ),
                                    );
                                  });
                                } catch (error) {
                                  print('error');
                                }
                            },
                            child: Consumer<Task>(
                              builder: (context, task, _) => Row(
                                children: [
                                  Checkbox(
                                    activeColor: Colors.blueAccent,
                                    value: task.isDone,
                                    onChanged: (value) =>
                                        task.toggleDoneStatus(),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: tasks.length,
                  ),
                ),
              ],
            ),
    );
  }
}
