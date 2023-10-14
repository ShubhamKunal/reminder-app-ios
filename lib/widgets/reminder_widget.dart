// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ReminderForm extends StatefulWidget {
  final Function onReminderAdded;

  const ReminderForm({
    Key? key,
    required this.onReminderAdded,
  }) : super(key: key);
  @override
  State<ReminderForm> createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

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

  // void _addReminder() {
  //   final title = _titleController.text;
  //   final desc = _descController.text;
  //   final dateTime = DateTime(
  //     _selectedDate.year,
  //     _selectedDate.month,
  //     _selectedDate.day,
  //     _selectedTime.hour,
  //     _selectedTime.minute,
  //   );

  //   final reminder = Reminder(title: title, desc: desc, dateTime: dateTime);
  //   setState(() {
  //     DatabaseHelper().insertReminder(reminder);
  //     _titleController.clear();
  //     widget.onReminderAdded();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Reminder Title'),
        ),
        const SizedBox(height: 30),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select date'),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: const Text('Select time'),
            ),
          ],
        ),
        // ElevatedButton(
        //   onPressed: _addReminder,
        //   child: const Text('Add Reminder'),
        // ),
      ],
    );
  }
}
