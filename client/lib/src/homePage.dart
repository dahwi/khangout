import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'filloutform.dart';
import 'viewMore.dart';

class Hangout {
  final String title;
  final String startTime;
  final String endTime;
  // ignore: non_constant_identifier_names
  final String hangout_type;
  final String category;
  final String contact;
  // ignore: non_constant_identifier_names
  final String hangout_location;
  // ignore: non_constant_identifier_names
  final String hangout_description;

  Hangout(
      this.title,
      this.startTime,
      this.endTime,
      this.hangout_type,
      this.category,
      this.contact,
      this.hangout_location,
      this.hangout_description);

  @override
  String toString() {
    return 'Hangout{title: $title, start: $startTime, end: $endTime, hangout_type: $hangout_type, category: $category, contact: $contact, hangout_location: $hangout_location, hangout_description: $hangout_description}';
  }

  // // Convert a Hangout into a Map. The keys must correspond to the names of the
  // // columns in the database.
  // Map<String, dynamic> toMap() {
  //   return {'id': id, 'title': title};
  // }
}

// status of any http request
enum HttpRequestStatus { NOT_DONE, DONE, ERROR }

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
  final List<Hangout> hangouts = [];

  static const _hangoutsUrl = 'http://localhost:8888/hangouts';
  static final _headers = {'Content-Type': 'application/json'};
  bool isSearching = false;
  var searchQuery = TextEditingController();

  List<Hangout> createHangoutList(List data) {
    List<Hangout> list = new List();

    for (int i = 0; i < data.length; i++) {
      String title = data[i]["title"];
      String startTime = data[i]["start_time"];
      String endTime = data[i]["end_time"];
      String hangoutType = data[i]["hangout_type"];
      String category = data[i]["category"];
      String contact = data[i]["contact"];
      String hangoutLocation = data[i]["hangout_location"];
      String hangoutDescription = data[i]["hangout_description"];

      Hangout hangout = new Hangout(title, startTime, endTime, hangoutType,
          category, contact, hangoutLocation, hangoutDescription);
      list.add(hangout);
    }

    return list;
  }

  Future<List<Hangout>> getAllHangouts() async {
    final response = await http.get(_hangoutsUrl);
    // print(response.body);
    List responseJson = json.decode(response.body.toString());
    List<Hangout> hangoutList = createHangoutList(responseJson);
    // print(hangoutList);
    return hangoutList;
  }

  String categorySearchHelper(val, item) {
    int categoryLength = 0;
    if (item != null) {
      for (var category in item['category'].toLowerCase().split(', ')) {
        categoryLength++;
        if (val == category) {
          return category;
        } else if (categoryLength == item['category'].split(', ').length) {
          return null;
        }
      }
    }
    return null;
  }

  Future<List<Hangout>> getSelectedHangouts(value) async {
    final response = await http.get(_hangoutsUrl);
    List responseJson = json.decode(response.body.toString());
    value.toLowerCase();

    responseJson.removeWhere((item) =>
        item['title'].toLowerCase() != value &&
        categorySearchHelper(value, item) != value &&
        item['hangout_type'].toLowerCase() != value);
    List<Hangout> selectedHangoutList = createHangoutList(responseJson);
    return selectedHangoutList;
  }

  Future createHangout(Map<String, dynamic> hangoutInfo) async {
    var httpRequestStatus = HttpRequestStatus.NOT_DONE;
    final response = await http.post(_hangoutsUrl,
        headers: _headers, body: json.encode(hangoutInfo));
    if (response.statusCode == 200) {
      print(response.body.toString());
      httpRequestStatus = HttpRequestStatus.DONE;
    } else {
      httpRequestStatus = HttpRequestStatus.ERROR;
    }

    return httpRequestStatus;
  }

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
        title: !isSearching
            ? Text(widget.title)
            : TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery.text = value;
                  });
                },
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins-Bold",
                ),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "Search Hangout..",
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
        centerTitle: true,
        actions: <Widget>[
          isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchQuery.clear();
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  }),
        ],
      ),
      body: isSearching
          ? FutureBuilder<List<Hangout>>(
              future: getSelectedHangouts(searchQuery.text),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Hangout>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 40,
                                ),
                                title: Text(snapshot.data[index].title ?? ""),
                                subtitle: Text(
                                    '${snapshot.data[index].startTime} - ${snapshot.data[index].endTime}'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('VIEW MORE'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewMorePage(
                                            hangout: snapshot.data[index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  TextButton(
                                    child: const Text('JOIN'),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}, this is error");
                }
                // by dafulat, show a loading spinner
                return Center(child: CircularProgressIndicator());
              },
            )
          : FutureBuilder<List<Hangout>>(
              future: getAllHangouts(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Hangout>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(Icons.chevron_right_rounded,
                                      size: 40),
                                  title: Text(snapshot.data[index].title ?? ""),
                                  subtitle: Text(
                                      '${snapshot.data[index].startTime} - ${snapshot.data[index].endTime}')),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: const Text('VIEW MORE'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ViewMorePage(
                                                hangout: snapshot.data[index])),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text('JOIN'),
                                    onPressed: () {/* ... */},
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return new Text("${snapshot.error}, this is error");
                }
                // by dafulat, show a loading spinner
                return Center(child: CircularProgressIndicator());
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
        content: Text("Saved!"),
        duration: Duration(seconds: 3),
      ));

    HttpRequestStatus httpRequestStatus = await createHangout(result);
    if (httpRequestStatus == HttpRequestStatus.DONE) {
      setState(() {});
    }
  }
}
