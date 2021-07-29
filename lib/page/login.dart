import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ring_sns/api/auth.dart';

class LoginPage extends StatelessWidget {
  bool _showPassword = false;
  final _passwordTextController = TextEditingController();
  String id;
  String pass;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login page'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'ID',
              ),
              onChanged: (text) {
                id = text;
              },
            ),
            TextField(
              obscureText: !_showPassword,
              controller: _passwordTextController,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(_showPassword
                      ? FontAwesomeIcons.solidEye
                      : FontAwesomeIcons.solidEyeSlash),
                  onPressed: () {
                    _showPassword = !_showPassword;
                  },
                ),
              ),
              onChanged: (text) {
                pass = text;
              },
            ),
            RaisedButton(
              child: Text('Login now'),
              onPressed: () async {
                //ここにログインを行うコードを追加する
                final hobbyText = myController.text;
                print("id: $id");
                print("pass: $pass");
                Auth auth = new Auth();
                LoginErrorMessage res = await auth.signIn(id, pass);
                print("res[id] = $res.userId");
                print("res[pass] = $res.password");
              },
            ),
          ],
        ),
      ),
    );
  }
}
