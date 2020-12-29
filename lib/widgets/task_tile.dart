import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/task.dart';
import 'package:todo_app/providers/tasks.dart';
import 'package:todo_app/screens/edit_task_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  TaskTile({
    this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                task: task,
              ),
            ),
          );
          if (result != null)
            try {
              await Provider.of<Tasks>(context, listen: false)
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
                onChanged: (value) => task.toggleDoneStatus(),
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
    );
  }
}
