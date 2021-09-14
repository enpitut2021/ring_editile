import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/regist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  //ここにイニシャライザを追加する
  LoginPage(this.auth);
  Auth auth;
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

  void savePassword(String userId, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login page'),
        automaticallyImplyLeading: false,
      ),
      body: 
      Center(
        child:
      Container(
        width: 300,
        child: Column(
          children: <Widget>[
            Text(""),
            Text(""),
            Text(""),
            TextField(
              decoration: InputDecoration(
                
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blueGrey[200],
                    )),
                labelText: 'ID',
              ),
              onChanged: (text) {
                id = text;
              },
            ),
            Text(""),
            TextField(
              obscureText: !_showPassword,
              controller: _passwordTextController,
              decoration: InputDecoration(
                
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
                pass = text;
              },
            ),
            new CheckboxListTile(
              activeColor: Colors.blue,
              title: Text('remember login'),
              value: _flag,
              onChanged: _handleCheckbox,
            ),
            Text(
              errormsg,
              style: TextStyle(color: Colors.red),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 50),
              child: ElevatedButton(
                  child: Text('Login'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    final hobbyText = myController.text;
                Auth auth = new Auth();
                LoginErrorMessage res = await auth.signIn(id, pass);
                if (res.userId == "" && res.password == "") {
                  if (_flag) {
                    savePassword(id, pass);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home(auth)),
                  );
                } else {
                  setState(() {
                    errormsg += res.password;
                  });
                }
                  }),
            ),
             TextButton(
        onPressed: (){
          Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountSignUp(new Auth())),
                  );
        },
        child:Text("Sign up")
      ),
            // RaisedButton(
            //   child: Text('Login now'),
            //   onPressed: () async {
            //     //ここにログインを行うコードを追加する
            //     final hobbyText = myController.text;
            //     Auth auth = new Auth();
            //     LoginErrorMessage res = await auth.signIn(id, pass);
            //     if (res.userId == "" && res.password == "") {
            //       if (_flag) {
            //         savePassword(id, pass);
            //       }
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Home(auth)),
            //       );
            //     } else {
            //       setState(() {
            //         errormsg += res.password;
            //       });
            //     }
            //   },
            // ),
          ],
        ),
      ),)
    );
  }
}
