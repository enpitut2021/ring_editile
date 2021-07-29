import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/page/home.dart';

class AccountSignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountSignUp();
}

class _AccountSignUp extends State<AccountSignUp> {
  // Auth auth;
  Auth auth;
  String user_id = '';
  String password = '';
  String error_msg='';
  bool uid_error=false;
  bool ups_error=false;
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
                Text(error_msg,style: TextStyle(color: Colors.red),),
                RaisedButton(
                    onPressed: () async {
                      auth = new Auth();
                      LoginErrorMessage signupres =
                          await auth.signUp(user_id, password);
                      print(signupres.userId);
                      print(signupres.password);
                      if (signupres.userId=='ok'&&signupres.password=='ok'){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                );
                      }else{
                        
                        if(signupres.userId!='ok'&&uid_error==false){
                          setState(() {
                            error_msg+=signupres.userId;
                            uid_error=true;
                          })
                          ;
                        
                         
                        }
                        if (signupres.password!='ok'&&ups_error==false){
                          setState(() {
                            error_msg+=signupres.password;
                            ups_error=true;
                          });
                        }
                      }
                    },
                    child: Text('submit'))
              ],
            )));
  }
}
