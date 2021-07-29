import 'package:flutter/material.dart';
//import 'package:ring_sns/api/auth.dart';


class AccountSignUp extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => _AccountSignUp();

}

class _AccountSignUp extends State<AccountSignUp>{
  String user_id='';
  String password='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー登録')
      ),
      body:Container(
        width: double.infinity,
        child:Column(children: [
          TextField(
            decoration: InputDecoration(
              
              hintText: 'ユーザー名'
            ),
            onChanged: (text){
              user_id=text;
              print('user_id:$user_id');

            },
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              
              hintText: 'ユーザー名'
            ),
            onChanged: (text){
              password=text;
              print('password:$password');
            },
          ),
          RaisedButton(
            onPressed: (){
              //LoginErrorMessage signupres =  signUp(user_id,password);
            },
            child:Text('submit')
            )
        ],)
      ) 

    );
  }
  
}