import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/page/home.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
// class LoginPage extends StatefulWidget {
  bool _showPassword = false;
  final _passwordTextController = TextEditingController();
  String id;
  String pass;
  final myController = TextEditingController();
  String errormsg = '';
  bool _flag = false;

  void _handleCheckbox(bool e) {
    setState(() {
      _flag = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login page'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
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
                    this.setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              onChanged: (text) {
                pass = text;
              },
            ),
            new Checkbox(
              activeColor: Colors.blue,
              value: _flag,
              onChanged: _handleCheckbox,
            ),
            Text(
              errormsg,
              style: TextStyle(color: Colors.red),
            ),
            RaisedButton(
              child: Text('Login now'),
              onPressed: () async {
                //ここにログインを行うコードを追加する
                final hobbyText = myController.text;
                Auth auth = new Auth();
                LoginErrorMessage res = await auth.signIn(id, pass);
                if (res.userId == "" && res.password == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                } else {
                  setState(() {
                    errormsg += res.password;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
