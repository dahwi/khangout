import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
} 

class SignUpPageState extends State<SignUpPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.orange,
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text('Sign Up',
                    style: TextStyle(
                      fontSize: 80.0, 
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins-Bold',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'EMAIL',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    errorText: _validateEmail ? 'Email Can\'t Be Empty' : null,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                    hintText: 'PASSWORD',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    errorText: _validatePassword ? 'Password Can\'t Be Empty' : null,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  height: 40.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.deepPurpleAccent,
                    color: Colors.deepPurple,
                    elevation: 7.0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _email.text.isEmpty ? _validateEmail = true : _validateEmail = false;
                          _password.text.isEmpty ? _validatePassword = true : _validatePassword = false;
                        });
                        if(!_validateEmail && !_validatePassword){
                          Map<String, dynamic> newUser = {
                            'email': _email.text,
                            'user_password': _password.text,
                          };
                          Navigator.pop(context, newUser);
                          Flushbar(
                            title: "Account Created!",
                            message: "Thank you for joining KHangouts!",
                            duration:   Duration(seconds: 3),
                          )..show(context);
                          _email.clear();
                          _password.clear();
                        }
                      },
                      child: Center(
                        child: Text("SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  height: 40.0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1.0,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        _email.clear();
                        _password.clear();
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text("Go Back",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}