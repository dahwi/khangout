import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flushbar/flushbar.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import '../main.dart';
import 'signUpPage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './rsa.dart';

// status of any http request
enum HttpRequestStatus { NOT_DONE, DONE, ERROR }

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static const _usersUrl = 'http://localhost:8888/users';
  static final _headers = {'Content-Type': 'application/json'};

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _forgottenUsername = TextEditingController();
  bool _validateUsername = false;
  bool _validatePassword = false;
  static bool _validateForgottenUsername = false;
  bool _isSelected = false;
  bool _inauthEmail = false;
  bool _inauthPassword = false;

  void _radio() {
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
        child: isSelected
            ? Container(
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
              title: Text(
                'Enter your email address',
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
                    color: Colors.grey,
                    fontSize: 15.0,
                  ),
                  errorText: _validateForgottenUsername
                      ? 'Email Address Can\'t Be Empty'
                      : null,
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
                      _forgottenUsername.text.isEmpty
                          ? _validateForgottenUsername = true
                          : _validateForgottenUsername = false;
                    });
                    if (_forgottenUsername.text.isNotEmpty) {
                      var forgotEmail = _forgottenUsername.text;
                      Navigator.of(context).pop();
                      _forgottenUsername.clear();
                      Flushbar(
                        title: "Forgot Password",
                        message:
                            "Email send to recover password to: $forgotEmail",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future getUserByEmail(String email) async {
    var specificUrl = _usersUrl + '/' + email;
    final response = await http.get(specificUrl);
    if (response.statusCode == 200){
      return response;
    } else {
      this.setState(() {
        _username.clear();
        _password.clear();
        _inauthEmail = true;
      });
      return null;
    }
  }

  Future<void> _authenticateUserCred(String userEmail, String userPassword) async {
    final response = await getUserByEmail(userEmail);
    if (response != null) {
      keyPair = await futureKeyPair;
      var responseJson = json.decode(response.body);
      var responsePass = responseJson["user_password"];
      // var encryptedPass = responseJson["user_password"];
      // String decryptedPass = decrypt(encryptedPass, keyPair.privateKey);
      // print(decryptedPass);
      if(userPassword != responsePass){
        setState(() {
          _password.clear();
          _inauthPassword = true;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(title: 'KHangout')),
        );
      }
    }
  }

  Future createUser(Map<String, dynamic> userInfo) async {
    var httpRequestStatus = HttpRequestStatus.NOT_DONE;
    final response = await http.post(_usersUrl,
      headers: _headers, body: json.encode(userInfo));
    if (response.statusCode == 200) { 
      print(response.body.toString());
      httpRequestStatus = HttpRequestStatus.DONE;
    } else {
      print(response.statusCode);
      httpRequestStatus = HttpRequestStatus.ERROR;
    }
    return httpRequestStatus;
  }

  Future<void> _navigateAndDisplaySignUp(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
    if (result != null){
      // keyPair = await futureKeyPair;
      // result["user_password"] = encrypt(result["user_password"], keyPair.publicKey);
      // print(result["user_password"]);
      HttpRequestStatus httpRequestStatus = await createUser(result);
      if (httpRequestStatus == HttpRequestStatus.DONE) {
        setState(() {
          print('User created');
        });
        Flushbar(
          title: "Account Created!",
          message: "Thank you for joining KHangouts!",
          duration:   Duration(seconds: 3),
        )..show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(750, 1334), allowFontScaling: true);
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
                          offset: Offset(0.0, 5.0),
                          blurRadius: 5.0,
                        ),
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 5.0),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            Text(
                              "Username",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4.0,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            _inauthEmail ?
                              TextField(
                                controller: _username,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.red),   
                                  ),  
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: "Invalid Username, re-enter/signup",
                                  hintStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  errorText: _validateUsername 
                                    ? 'Username Can\'t Be Empty'
                                    : null,
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ), 
                                ),
                              )
                              : TextField(
                                controller: _username,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.deepPurple),   
                                  ),  
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  hintText: "Insert username..",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                  errorText: _validateUsername 
                                    ? 'Username Can\'t Be Empty'
                                    : null, 
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: ScreenUtil().setHeight(50),
                            ),
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4.0,
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            _inauthPassword ?
                              TextField(
                                controller: _password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.red),   
                                  ),  
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  hintText: "Invalid Password, please re-enter",
                                  hintStyle: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  errorText: _validatePassword
                                      ? 'Password Can\'t Be Empty'
                                      : null,
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : TextField(
                                controller: _password,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  ),
                                  enabledBorder: UnderlineInputBorder(      
                                    borderSide: BorderSide(color: Colors.deepPurple),   
                                  ),  
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  hintText: "Insert password..",
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                  errorText: _validatePassword
                                      ? 'Password Can\'t Be Empty'
                                      : null,
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: Colors.deepPurple,
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
                          Text(
                            "Remember me",
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
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.4),
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
                                  if (_username.text.isEmpty) {
                                    _validateUsername = true;
                                    _inauthEmail = false;
                                  } else {
                                    _validateUsername = false;
                                  }
                                  if (_password.text.isEmpty){
                                    _validatePassword = true;
                                    _inauthPassword = false;
                                  } else {
                                    _validatePassword = false;
                                  }
                                });
                                if (!_validateUsername && !_validatePassword) {
                                  _authenticateUserCred(_username.text, _password.text); 
                                }
                              },
                              child: Center(
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
                      Text(
                        "New User ?",
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
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.4),
                                offset: Offset(2.0, 2.0),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState((){
                                  _username.clear();
                                  _password.clear();
                                  _forgottenUsername.clear();
                                  _validateUsername = false;
                                  _validatePassword = false;
                                  _isSelected = false;
                                  _inauthEmail = false;
                                  _inauthPassword = false;
                                  _validateForgottenUsername = false;
                                });
                                _navigateAndDisplaySignUp(context);
                              },
                              child: Center(
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
