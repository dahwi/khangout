import '../server.dart';

// when we fetch Hangout from a database, it will be an instance of Hangout
class Hangout extends ManagedObject<_Hangout> implements _Hangout {}

// Hangout Table definition
class _Hangout {
  @primaryKey
  int id;

  @Column(nullable: false, indexed: true)
  String title;

  @Column(nullable: false, indexed: true)
  String start_time;

  @Column(nullable: false, indexed: true)
  String end_time;

  @Column(nullable: false, indexed: true)
  String hangout_type;

  @Column()
  String category;

  @Column()
  String contact;

  @Column()
  String hangout_location;

  @Column()
  String hangout_description;

  // // Convert a Hangout into a Map. The keys must correspond to the names of the
  // // columns in the database.
  // Map<String, dynamic> toMap() {
  //   return {'id': id, 'title': title};
  // }

  // @override
  // String toString() {
  //   return 'Hangout{id: $id, title: $title}';
  // }
}
