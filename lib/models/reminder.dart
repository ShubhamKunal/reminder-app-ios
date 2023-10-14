class Reminder {
  String title;
  String desc;
  DateTime dateTime;

  Reminder({required this.title, required this.desc, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      title: map['title'],
      desc: map['desc'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
