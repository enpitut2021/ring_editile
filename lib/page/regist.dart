import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountSignUp extends StatefulWidget {
  //ここにイニシャライザを書く
  AccountSignUp(this.auth);
  Auth auth;

  @override
  State<StatefulWidget> createState() => _AccountSignUp();
}

class _AccountSignUp extends State<AccountSignUp> {
  // Auth auth;
  String user_id = '';
  String password = '';
  String error_msg = '';
  bool uid_error = false;
  bool ups_error = false;
  bool _showPassword = false;
  bool _flag=false;

  void _handleCheckbox(bool e) {
    setState(() {
      _flag = e;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ユーザー登録')),
        body: 
        Center(
          child:
        Container(
            width: 300,
            child: Column(
              children: [
                Text(""),
                Text(""),
                Text(""),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'ユーザー名',
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blueGrey[200],
                    )),
                labelText: 'ID',),
                  onChanged: (text) {
                    user_id = text;
                    print('user_id:$user_id');
                  },
                ),
                Text(""),
                TextField(
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: 'パスワード',
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blueGrey[200],
                    )),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(_showPassword
                      ? FontAwesomeIcons.solidEye
                      : FontAwesomeIcons.solidEyeSlash),
                  onPressed: () {
                    this.setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
                  ),
                  onChanged: (text) {
                    password = text;
                    print('password:$password');
                  },
                ),
                
                Text(
                  error_msg,
                  style: TextStyle(color: Colors.red),
                ),
                Text(""),Text(""),
                ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 50),
              child: ElevatedButton(
                  child: Text('Sign up'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                      LoginErrorMessage signupres =
                          await widget.auth.signUp(user_id, password);
                      print(signupres.userId);
                      print(signupres.password);
                      if (signupres.userId == 'ok' &&
                          signupres.password == 'ok') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage(new Auth())),
                        );
                      } else {
                        if (signupres.userId != 'ok' && uid_error == false) {
                          setState(() {
                            error_msg += signupres.userId;
                            uid_error = true;
                          });
                        }
                        if (signupres.password != 'ok' && ups_error == false) {
                          setState(() {
                            error_msg += signupres.password;
                            ups_error = true;
                          });
                        }
                      }
                    },
                  ),
            ),
                // RaisedButton(
                //     onPressed: () async {
                //       LoginErrorMessage signupres =
                //           await widget.auth.signUp(user_id, password);
                //       print(signupres.userId);
                //       print(signupres.password);
                //       if (signupres.userId == 'ok' &&
                //           signupres.password == 'ok') {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(builder: (context) => LoginPage(new Auth())),
                //         );
                //       } else {
                //         if (signupres.userId != 'ok' && uid_error == false) {
                //           setState(() {
                //             error_msg += signupres.userId;
                //             uid_error = true;
                //           });
                //         }
                //         if (signupres.password != 'ok' && ups_error == false) {
                //           setState(() {
                //             error_msg += signupres.password;
                //             ups_error = true;
                //           });
                //         }
                //       }
                //     },
                //     child: Text('submit'))
              ],
            ))));
  }
}
