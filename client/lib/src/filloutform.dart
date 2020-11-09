import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';

class FillOutPage extends StatefulWidget {
  @override
  _FillOutPageState createState() => _FillOutPageState();
}

class _FillOutPageState extends State<FillOutPage> {
  TextEditingController titleCtl = TextEditingController();
  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl0 = TextEditingController(); //start time
  TextEditingController timeCtl1 = TextEditingController(); //end time
  TextEditingController onlineStatus =
      TextEditingController(); // online/offline status
  TextEditingController category = TextEditingController(); // category 'list'
  TextEditingController contact = TextEditingController();
  TextEditingController hangout_location = TextEditingController();
  TextEditingController hangout_description = TextEditingController();

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
                        category.text = selected
                            .toString()
                            .substring(1, selected.toString().length - 1);
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
                controller: titleCtl,
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
                controller: hangout_location,
                decoration: const InputDecoration(
                    icon: Icon(Icons.location_pin),
                    hintText: 'Add Location',
                    labelText: 'Location'),
                validator: (String value) {
                  return value.isEmpty ? 'Please enter the location' : null;
                },
              ),
              TextFormField(
                controller: contact,
                decoration: const InputDecoration(
                    icon: Icon(Icons.contact_phone),
                    hintText: 'Add contact info',
                    labelText: 'Contact Info'),
                validator: (String value) {
                  return value.isEmpty ? 'Please enter contact info' : null;
                },
              ),
              TextFormField(
                  controller: hangout_description,
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

                Map<String, dynamic> newHangout = {
                  'title': titleCtl.text,
                  'start_time': dateCtl.text + " " + timeCtl0.text,
                  'end_time': dateCtl.text + " " + timeCtl1.text,
                  'hangout_type': onlineStatus.text,
                  'category': category.text,
                  'contact': contact.text,
                  'hangout_location': hangout_location.text,
                  'hangout_description': hangout_description.text
                };
                print(newHangout);
                Navigator.pop(context, newHangout);
                titleCtl.clear();
                dateCtl.clear();
                timeCtl0.clear();
                timeCtl1.clear();
                onlineStatus.clear();
                category.clear();
                contact.clear();
                hangout_location.clear();
                hangout_description.clear();
              }
            },
            tooltip: 'Save',
            child: Icon(Icons.save)));
  }
}
