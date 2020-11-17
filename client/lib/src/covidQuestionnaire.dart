import 'package:flutter/material.dart';

class CovidCheck extends StatefulWidget {
  @override
  _CovidCheckState createState() => _CovidCheckState();
}

class _CovidCheckState extends State<CovidCheck> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool monVal = false;
  bool tuVal = false;
  bool wedVal = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("COVID Questionnarie"),
          centerTitle: true,
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // [Monday] checkbox
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("YES"),
                  Checkbox(
                    value: monVal,
                    onChanged: (bool value) {
                      setState(() {
                        monVal = value;
                      });
                    },
                  ),
                ],
              ),
              // [Tuesday] checkbox
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("NO"),
                  Checkbox(
                    value: tuVal,
                    onChanged: (bool value) {
                      setState(() {
                        tuVal = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
