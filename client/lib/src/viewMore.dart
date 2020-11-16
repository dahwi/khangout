import 'package:flutter/material.dart';
import 'homePage.dart';

class ViewMorePage extends StatelessWidget {
  final Hangout hangout;

  ViewMorePage({Key key, @required this.hangout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View More"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Title',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.title,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.title,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Start Time',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.startTime,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.timelapse,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('End Time',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.endTime,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.timelapse,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Event Type',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.hangout_type,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.laptop_mac,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Category',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.category,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.playlist_add_check,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Location',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.hangout_location,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.location_pin,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Contact',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.contact,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.contact_phone,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text('Description',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w200)),
                  subtitle: Text(hangout.hangout_description,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  leading: Icon(
                    Icons.description,
                    color: Colors.orange[500],
                  ),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        tooltip: 'Join',
        icon: Icon(Icons.add),
        label: Text("Join"),
      ),
    );
  }
}
