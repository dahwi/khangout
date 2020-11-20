import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'viewMore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'homePage.dart';

enum HttpRequestStatus { NOT_DONE, DONE, ERROR }

class UserKhangoutPage extends StatefulWidget {

  final int userId;

  UserKhangoutPage({Key key, this.userId}) : super(key: key);

  @override
  _UserKhangoutPage createState() => _UserKhangoutPage();
}

class _UserKhangoutPage extends State<UserKhangoutPage> {

  final List<Hangout> hangouts = [];
  final List<UserHangout> userHangouts = [];

  static const _hangoutsUrl = 'http://localhost:8888/hangouts';
  static const _userHangoutUrl = 'http://localhost:8888/userhangouts';

  bool isSearching = false;
  var searchQuery = TextEditingController();

  List<Hangout> createHangoutList(List data) {
    List<Hangout> list = new List();

    for (int i = 0; i < data.length; i++) {
      // print(data[i]["title"]);
      int id = data[i]["id"];
      String title = data[i]["title"];
      String startTime = data[i]["start_time"];
      String endTime = data[i]["end_time"];
      String hangoutType = data[i]["hangout_type"];
      String category = data[i]["category"];
      String contact = data[i]["contact"];
      String hangoutLocation = data[i]["hangout_location"];
      String hangoutDescription = data[i]["hangout_description"];

      Hangout hangout = new Hangout(id, title, startTime, endTime, hangoutType,
          category, contact, hangoutLocation, hangoutDescription);
      list.add(hangout);
    }

    return list;
  }

  List<UserHangout> createUserHangoutList(List data) {
    List<UserHangout> list = new List();
    for (int i =0; i < data.length; i++){
      int id = data[i]["id"];
      int user_id = data[i]["user_id"];
      int hangout_id = data[i]["hangout_id"];
      UserHangout userHangout = new UserHangout(id, user_id, hangout_id);
      list.add(userHangout);
    }
    return list;
  }

  Future<List<UserHangout>> getUserHangouts() async {
    final response = await http.get(_userHangoutUrl);
    List responseJson = json.decode(response.body.toString());
    responseJson.removeWhere((item) => 
      item['user_id'] != widget.userId
    );
    List<UserHangout> userHangoutList = createUserHangoutList(responseJson);
    return userHangoutList;
  }
  

  bool findUserHangouts(item, List<UserHangout> userHangouts){
    for(var hangout in userHangouts){
      if(hangout.hangout_id == item['id']){
        return true;
      }
    }
    return false;
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

  Future<List<Hangout>> getAllSelectedUserHangouts(value) async {
    final response = await http.get(_hangoutsUrl);
    final userResponse = await getUserHangouts();
    List responseJson = json.decode(response.body.toString());
    responseJson.removeWhere((item) => 
      findUserHangouts(item, userResponse) != true
    );
    value.toLowerCase();
    responseJson.removeWhere((item) =>
        item['title'].toLowerCase() != value &&
        categorySearchHelper(value, item) != value &&
        item['hangout_type'].toLowerCase() != value);
    List<Hangout> selectedHangoutList = createHangoutList(responseJson);
    return selectedHangoutList;
  }

  Future<List<Hangout>> getAllUserHangouts() async {
    final response = await http.get(_hangoutsUrl);
    final userResponse = await getUserHangouts();
    List responseJson = json.decode(response.body.toString());
    responseJson.removeWhere((item) => 
      findUserHangouts(item, userResponse) != true
    );
    responseJson.forEach((item) => print(item['title']));
    List<Hangout> hangoutList = createHangoutList(responseJson);
    // print(hangoutList);
    return hangoutList;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
      designSize: Size(750, 1334), allowFontScaling: true);
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: InkWell( 
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                "assets/images/KalamazooCollege.png",
                ),
              ),
            ),
            title: !isSearching
              ? Text('My Khangouts',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
              :TextField(
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
        future: getAllSelectedUserHangouts(searchQuery.text),
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
                            title: Text(snapshot.data[index].title ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                          hangout : snapshot.data[index])),
                                );
                              },
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
      )
      : FutureBuilder<List<Hangout>>(
              future: getAllUserHangouts(),
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
                                  title: Text(snapshot.data[index].title ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                                hangout : snapshot.data[index])),
                                      );
                                    },
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
                      Navigator.pop(context);
                    },
                    tooltip: 'Go back',
                    child: Icon(Icons.keyboard_arrow_right),
                  )), 
    );
  }
}