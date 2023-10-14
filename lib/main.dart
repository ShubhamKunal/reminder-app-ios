import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app_ios/models/reminder.dart';
import 'package:reminder_app_ios/repo/database_helpers.dart';
import 'package:reminder_app_ios/widgets/custom_small_button.dart';
import 'dart:developer' as developer;

import 'package:reminder_app_ios/widgets/text_form_field.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(showDebugLogs: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ReminderApp(),
    );
  }
}

class ReminderApp extends StatefulWidget {
  const ReminderApp({super.key});

  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final databaseHelper = DatabaseHelper();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _addReminder() async {
    final title = _titleController.text;
    final desc = _descController.text;
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final reminder = Reminder(title: title, desc: desc, dateTime: dateTime);

    setState(() {
      DatabaseHelper().insertReminder(reminder);
      _titleController.clear();
      _descController.clear();
    });

    final alarmSettings = AlarmSettings(
      id: await DatabaseHelper().getReminderID(reminder.dateTime),
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volumeMax: true,
      fadeDuration: 3.0,
      androidFullScreenIntent: true,
      notificationTitle: title,
      notificationBody: desc,
      enableNotificationOnKill: true,
      stopOnNotificationOpen: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  @override
  Widget build(BuildContext context) {
    var remindList = DatabaseHelper().getReminders();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Set a Reminder',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: <Widget>[
                CustomTextFormField(
                  controller: _titleController,
                  hintText: "Reminder Title",
                  obscureText: false,
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  controller: _descController,
                  hintText: "Reminder Description",
                  obscureText: false,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${_selectedDate.toLocal()}".split(' ')[0]),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(_selectedTime.format(context)),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomSmallButton(
                      text: 'Select date',
                      onPressed: () => _selectDate(context),
                    ),
                    CustomSmallButton(
                      text: 'Select time',
                      onPressed: () => _selectTime(context),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomSmallButton(
                  text: 'Add Reminder',
                  onPressed: _addReminder,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Reminders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: remindList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final reminder = snapshot.data![index];
                          return ListTile(
                            title: Text(reminder.title),
                            subtitle: Text(
                              DateFormat("MMM dd, yyyy - HH:mm")
                                  .format(reminder.dateTime),
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  await Alarm.stop(await DatabaseHelper()
                                      .getReminderID(reminder.dateTime));
                                  developer
                                      .log(reminder.dateTime.toIso8601String());
                                  setState(() {
                                    databaseHelper
                                        .deleteReminderByTime(
                                            reminder.dateTime.toIso8601String())
                                        .then((value) {
                                      developer.log(value.toString());
                                    });
                                  });
                                },
                                icon: const Icon(Icons.delete)),
                          );
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
