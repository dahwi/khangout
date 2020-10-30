import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import './src/models/_hangout.dart';
import './src/db/main.dart';

Future<void> main() async {
  runApp(MyApp());
  var db = await connectToDB();
  final info = Hangout(
      id: 0,
      title: 'test',
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final info1 = Hangout(
      id: 1,
      title: 'test1',
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  await insertHangout(db, info);
  await insertHangout(db, info1);

  print(await showHangouts(db));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KHangout',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'KHangout'),
    );
  }
}

class HangoutInfo {
  final String title;
  final String description;

  HangoutInfo(this.title, this.description);
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<HangoutInfo> hangouts = [];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Image.asset(
            "assets/images/KalamazooCollege.png",
          ),
        ),
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: hangouts.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  title: Text(hangouts[index].title),
                  subtitle: Text(
                      'A sufficiently long subtitle warrants three lines.'),
                  trailing: Icon(Icons.more_vert)));
        },
      ),
      floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
                onPressed: () {
                  _navigateAndDisplaySelection(context);
                },
                tooltip: 'Add',
                child: Icon(Icons.add),
              )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // A method that launches the FillOutScreen and awaits the
  // result from Navigator.pop.
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the FillOutScreen in the next step.
      MaterialPageRoute(builder: (context) => FillOutPage()),
    );

    // After the FillOut Screen returns a result, hide any previous snackbars
    // and show the new result.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text("$result"),
        duration: Duration(seconds: 3),
      ));

    setState(() {
      if (result != null) {
        var i = hangouts.length;
        hangouts.add(new HangoutInfo('test $i', '$result'));
      }
    });
  }
}

class FillOutPage extends StatefulWidget {
  @override
  _FillOutPageState createState() => _FillOutPageState();
}

class _FillOutPageState extends State<FillOutPage> {
  @override
  Widget build(BuildContext context) {
    return FilloutForm();
  }
}

// Define a custom Form widget.
class FilloutForm extends StatefulWidget {
  @override
  FilloutFormState createState() {
    return FilloutFormState();
  }
}

TextEditingController dateCtl = TextEditingController();
TextEditingController timeCtl0 = TextEditingController(); //start time
TextEditingController timeCtl1 = TextEditingController(); //end time
TextEditingController onlineStatus =
    TextEditingController(); // online/offline status
TextEditingController category = TextEditingController(); // category 'list'

// Define a corresponding State class.
// This class holds data related to the form.
class FilloutFormState extends State<FilloutForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(new Duration(days: 365)));

    if (_datePicker != null) {
      dateCtl.text = DateFormat('yyyy-MM-dd').format(_datePicker);
    }
  }

  /* int timeline: 0 is startTime and 1 is endTime */
  Future<Null> _selectTime(BuildContext context, int timeline) async {
    TimeOfDay _timePicker = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.input);

    if (_timePicker != null) {
      if (timeline == 0) {
        timeCtl0.text = _timePicker.format(context);
      } else {
        timeCtl1.text = _timePicker.format(context);
      }
    }
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Category(s)'),
              content: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    child: CheckboxGroup(
                      labels: <String>[
                        "Exercise",
                        "Frisbee",
                        "Food",
                        "Games",
                        "Movies",
                        "Music",
                        "Rock Climbing",
                        "Sports",
                        "Studying",
                        "Performance",
                        "Other",
                      ],
                      onSelected: (List selected) => setState(() {
                        category.text = selected.toString();
                      }),
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      setState(() {
                        category.clear();
                      });
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  void _showOnlineStatusDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Status Type'),
              content: Container(
                height: 100,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CheckboxGroup(
                    labels: <String>[
                      "Online",
                      "Offline",
                    ],
                    onSelected: (List selected) => setState(() {
                      if (selected.length > 1) {
                        selected.removeAt(0);
                      }
                      onlineStatus.text = selected[0].toString();
                    }),
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      setState(() {
                        onlineStatus.clear();
                      });
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Create a Meeting"),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Add Title',
                    labelText: 'Title'),
                validator: (String value) {
                  return value.isEmpty ? 'Please enter the titile' : null;
                },
              ),
              TextFormField(
                  readOnly: true,
                  controller: dateCtl,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Date',
                  ),
                  validator: (String value) {
                    return value.isEmpty ? 'Please select date' : null;
                  }),
              TextFormField(
                  readOnly: true,
                  controller: timeCtl0,
                  onTap: () {
                    _selectTime(context, 0);
                  },
                  decoration: InputDecoration(
                    icon: Icon(Icons.timelapse),
                    labelText: 'Start Time',
                  ),
                  validator: (String value) {
                    return value.isEmpty ? 'Please select start time' : null;
                  }),
              TextFormField(
                readOnly: true,
                controller: timeCtl1,
                onTap: () {
                  _selectTime(context, 1);
                },
                decoration: InputDecoration(
                  icon: Icon(Icons.timelapse),
                  labelText: 'End Time',
                ),
                validator: (String value) {
                  return value.isEmpty ? 'Please select end time' : null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: onlineStatus,
                onTap: () {
                  _showOnlineStatusDialog(context);
                },
                decoration: const InputDecoration(
                    icon: Icon(Icons.laptop_mac),
                    hintText: 'Online or Offline',
                    labelText: 'Status Type'),
                validator: (String value) {
                  return value.isEmpty ? 'Please select Status Type' : null;
                },
              ),
              TextFormField(
                readOnly: true,
                controller: category,
                onTap: () {
                  _showCategoryDialog(context);
                },
                decoration: const InputDecoration(
                    icon: Icon(Icons.playlist_add_check),
                    hintText: 'Games, Sports...',
                    labelText: 'Category Type'),
                validator: (String value) {
                  return value.isEmpty
                      ? 'Please Select/Input Category Type'
                      : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.location_pin),
                    hintText: 'Add Location',
                    labelText: 'Location'),
                validator: (String value) {
                  return value.isEmpty ? 'Please enter the location' : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    icon: Icon(Icons.contact_phone),
                    hintText: 'Add contact info',
                    labelText: 'Contact Info'),
                validator: (String value) {
                  return value.isEmpty ? 'Please enter contact info' : null;
                },
              ),
              TextFormField(
                  decoration: const InputDecoration(
                      icon: Icon(Icons.description),
                      hintText: 'Add Description',
                      labelText: 'Description'),
                  // validator: (String value) {
                  //   return value.isEmpty
                  //       ? 'Please enter the description'
                  //       : null;
                  // },
                  maxLines: null)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                // Scaffold.of(context)
                //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                dateCtl.clear();
                timeCtl0.clear();
                timeCtl1.clear();
                onlineStatus.clear();
                category.clear();

                Navigator.pop(context, 'Saved!');
              }
            },
            tooltip: 'Save',
            child: Icon(Icons.save)));
  }
}
