import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/page/home.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Profile();
}

class _Profile extends State<Profile> {
// class Profile extends StatefulWidget {
  bool _showPassword = false;
  final _passwordTextController = TextEditingController();
  String nickname = "Aiueo";
  String userid = "userid";
  final myController = TextEditingController();
  String errormsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile page'),
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
                // id = text;
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
                    this.setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              onChanged: (text) {
                // pass = text;
              },
            ),
            Text(
              errormsg,
              style: TextStyle(color: Colors.red),
            ),
            RaisedButton(
              child: Text('Login now'),
              onPressed: () async {
                //ここにログインを行うコードを追加する
              },
            ),
          ],
        ),
      ),
    );
  }
}
