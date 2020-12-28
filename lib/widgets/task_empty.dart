import 'package:flutter/material.dart';

class TaskEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'まだタスクはありません',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'タスクを追加してください',
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
