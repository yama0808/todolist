import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/widgets/task_empty.dart';
import 'package:todo_app/widgets/task_tile.dart';

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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                tasks.isEmpty
                    ? TaskEmpty()
                    : CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final task = tasks[index];
                                return ChangeNotifierProvider.value(
                                  value: task,
                                  child: TaskTile(
                                    task: task,
                                  ),
                                );
                              },
                              childCount: tasks.length,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
    );
  }
}
