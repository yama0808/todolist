import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChip extends StatelessWidget {
  final DateTime date;

  DateChip({
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        DateFormat('MM月dd日').format(date),
      ),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      deleteIcon: Icon(
        Icons.clear,
        color: Colors.grey,
        size: 18.0,
      ),
      deleteIconColor: Colors.grey,
      onDeleted: () {},
    );
  }
}
