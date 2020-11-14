import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/tasks.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/screens/edit_task_screen.dart';
import 'package:todo_app/screens/tasks_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Tasks(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.white,
        ),
        initialRoute: TasksScreen.routeName,
        routes: {
          TasksScreen.routeName: (context) => TasksScreen(),
          AddTaskScreen.routeName: (context) => AddTaskScreen(),
          EditTaskScreen.routeName: (context) => EditTaskScreen(),
        },
      ),
    );
  }
}
