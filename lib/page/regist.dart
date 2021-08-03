import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/login.dart';

class AccountSignUp extends StatefulWidget {
  //ここにイニシャライザを書く
  //AccountSignUp(this.auth);
  //Auth auth;

  @override
  State<StatefulWidget> createState() => _AccountSignUp();
}

class _AccountSignUp extends State<AccountSignUp> {
  // Auth auth;
  Auth auth = new Auth();
  String user_id = '';
  String password = '';
  String error_msg = '';
  bool uid_error = false;
  bool ups_error = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('ユーザー登録')),
        body: Container(
            width: double.infinity,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'ユーザー名'),
                  onChanged: (text) {
                    user_id = text;
                    print('user_id:$user_id');
                  },
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'パスワード'),
                  onChanged: (text) {
                    password = text;
                    print('password:$password');
                  },
                ),
                Text(
                  error_msg,
                  style: TextStyle(color: Colors.red),
                ),
                RaisedButton(
                    onPressed: () async {
                      LoginErrorMessage signupres =
                          await auth.signUp(user_id, password);
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
                    child: Text('submit'))
              ],
            )));
  }
}
