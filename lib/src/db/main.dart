import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/_hangout.dart';

Future<Database> connectToDB() async {
  print(join(await getDatabasesPath(), 'hangout_database.db'));
// Avoid errors caused by flutter upgrade.
// Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
// Open the database and store the reference.
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'hangout_database.db'),

    // When the database is first created, create a table to store Hangouts.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        "CREATE TABLE hangouts(id INTEGER PRIMARY KEY, title TEXT, date TEXT, startTime TEXT, endTime TEXT, type TEXT, category TEXT, location TEXT, contact TEXT, description TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  return database;
}

// Define a function that inserts Hangouts into the database
Future<void> insertHangout(Database db, Hangout hangout) async {
  // Insert the Hangout into the correct table. You might also specify the
  // `conflictAlgorithm` to use in case the same Hangout is inserted twice.
  //s
  // In this case, replace any previous data.
  await db.insert(
    'hangouts',
    hangout.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// A method that retrieves all the Hangouts from the Hangouts table.
Future<List<Hangout>> showHangouts(Database db) async {
  // Query the table for all The Hangouts.
  final List<Map<String, dynamic>> maps = await db.query('hangouts');

  // Convert the List<Map<String, dynamic> into a List<Hangout>.
  return List.generate(maps.length, (i) {
    return Hangout(
        id: maps[i]['id'],
        title: maps[i]['title'],
        date: maps[i]['date'],
        startTime: maps[i]['startTime'],
        endTime: maps[i]['endTime'],
        type: maps[i]['type'],
        category: maps[i]['category'],
        location: maps[i]['location'],
        contact: maps[i]['contact'],
        description: maps[i]['description']);
  });
}

Future<void> updateHangout(Database db, Hangout hangout) async {
  // Update the given Hangout.
  await db.update(
    'Hangouts',
    hangout.toMap(),
    // Ensure that the Hangout has a matching id.
    where: "id = ?",
    // Pass the Hangout's id as a whereArg to prevent SQL injection.
    whereArgs: [hangout.id],
  );
}

Future<void> deleteHangout(Database db, int id) async {
  // Remove the Hangout from the database.
  await db.delete(
    'Hangouts',
    // Use a `where` clause to delete a specific Hangout.
    where: "id = ?",
    // Pass the Hangout's id as a whereArg to prevent SQL injection.
    whereArgs: [id],
  );
}
