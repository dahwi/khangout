import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flushbar/flushbar.dart';
import '../main.dart';
import 'signUpPage.dart';

class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _forgottenUsername = TextEditingController();
  bool _validateUsername = false;
  bool _validatePassword = false;
  static bool _validateForgottenUsername = false;
  bool _isSelected = false;

  void _radio(){
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(width: 2.0, color: Colors.black),
    ),
    child: isSelected ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
    ) 
    : Container(),
  );

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Enter your email address',
              style: TextStyle(
                fontFamily: "Poppins-Bold",
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              controller: _forgottenUsername,
              decoration: InputDecoration(
                hintText: "Insert Email Address..",
                hintStyle: TextStyle(
                  color: Colors.grey, fontSize: 15.0,
                ),
                errorText: _validateForgottenUsername ? 'Email Address Can\'t Be Empty' : null,
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
                      _forgottenUsername.clear();
                    });
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  setState(() {
                    _forgottenUsername.text.isEmpty ? _validateForgottenUsername = true : _validateForgottenUsername = false;
                  });
                  if(_forgottenUsername.text.isNotEmpty){
                    var forgotEmail = _forgottenUsername.text;
                    Navigator.of(context).pop();
                    _forgottenUsername.clear();
                    Flushbar(
                      title: "Forgot Password",
                      message: "Email send to recover password to: $forgotEmail",
                      duration:   Duration(seconds: 3),
                    )..show(context);
                  }
                },
              ),
            ],
          );
        }
        );
      }
    );
  }

  @override 
  Widget build(BuildContext context){
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.orange,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Image.asset("assets/images/KalamazooCollege.png"),
              ),
            ],
          ),  
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 28.0, top: 160.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(150),
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(500),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 15.0,
                        ),
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text("Login",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(45),
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.w900,
                                letterSpacing: .6,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            Text("USERNAME",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                fontFamily: "Poppins-Medium",
                              ),
                            ),
                            TextField(
                              controller: _username,
                              decoration: InputDecoration(
                                hintText: "Insert username..",
                                hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 15.0,
                                ),
                                errorText: _validateUsername ? 'Username Can\'t Be Empty' : null,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            Text("PASSWORD",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                fontFamily: "Poppins-Medium",
                              ),
                            ),
                            TextField(
                              controller: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Insert password..",
                                hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 15.0,
                                ),
                                errorText: _validatePassword ? 'Password Can\'t Be Empty' : null,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(35),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new GestureDetector(
                                  onTap: () {
                                    _showForgotPasswordDialog(context);
                                  },
                                  child: Text("Forgot Password?",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: "Poppins-Medium",
                                      fontSize: ScreenUtil().setSp(28),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("Remember me",
                            style: TextStyle(
                              fontSize: 12, 
                              fontFamily: "Poppins-Medium",
                            ),
                          ), 
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil().setWidth(330),
                          height: ScreenUtil().setHeight(100),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.blue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff9800).withOpacity(.2),
                                offset: Offset(2.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _username.text.isEmpty ? _validateUsername = true : _validateUsername = false;
                                  _password.text.isEmpty ? _validatePassword = true : _validatePassword = false;
                                });
                                if(!_validateUsername && !_validatePassword){
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'KHangout')),
                                  );
                                  _username.clear();
                                  _password.clear();
                                }
                              },
                              child: Center(
                                child: Text("SIGN IN",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins-Bold",
                                    fontSize: 18,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],  
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("New User ?",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "Poppins-Medium",
                        ),
                      ),
                      horizontalLine(),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          width: ScreenUtil().setWidth(330),
                          height: ScreenUtil().setHeight(100),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.deepPurple,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff9800).withOpacity(.2),
                                offset: Offset(2.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => SignUpPage()),
                                  );
                              }, 
                              child: Center(
                                child: Text("SIGN UP",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins-Bold",
                                    fontSize: 18,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}