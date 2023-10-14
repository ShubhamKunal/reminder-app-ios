// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app_ios/models/reminder.dart';
import 'package:reminder_app_ios/repo/database_helpers.dart';

class ReminderList extends StatefulWidget {
  dynamic reminderList;
  ReminderList({
    Key? key,
    required this.reminderList,
  }) : super(key: key);

  @override
  State<ReminderList> createState() => _ReminderListState();
}

class _ReminderListState extends State<ReminderList> {
  List<Reminder> _reminders = [];
  final databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() async {
    final reminders = await widget.reminderList;
    setState(() {
      _reminders = reminders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _reminders.length,
      itemBuilder: (context, index) {
        final reminder = _reminders[index];
        return ListTile(
          title: Text(reminder.title),
          subtitle: Text(
            DateFormat("MMM dd, yyyy - HH:mm").format(reminder.dateTime),
          ),
          trailing: IconButton(
              onPressed: () {
                developer.log(reminder.dateTime.toIso8601String());
                setState(() {
                  databaseHelper
                      .deleteReminderByTime(reminder.dateTime.toIso8601String())
                      .then((value) {
                    developer.log(value.toString());
                  });
                });
              },
              icon: const Icon(Icons.delete)),
        );
      },
    );
  }
}
