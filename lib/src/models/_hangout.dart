class Hangout {
  final int id;
  final String title;
  final String date;
  // final int startTime;
  // final int endTime;
  // final String type;
  // final String location;
  // final String contact;
  // final String description;

  Hangout({
    this.id,
    this.title,
    this.date,
  });
  // this.startTime,
  // this.endTime,
  // this.type,
  // this.location,
  // this.contact,
  // this.description});

  // Convert a Hangout into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Hangout{id: $id, title: $title, date: $date}';
  }
}
