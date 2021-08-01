import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/cupertino.dart';

class Usersetting extends StatefulWidget {
  //ここにイニシャライザを書く
  Usersetting(this.auth);
  Auth auth;
  @override
  State<StatefulWidget> createState() => _Usersetting();
}

class _Usersetting extends State<Usersetting> {
  // Auth auth;
  Auth auth = new Auth();
  String nickname = '';
  String profile_text = '';
  String hobby = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.auth.getUserId() + "のユーザー設定")),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://user-imgs.p0x0q.com/thumbnail/user/1.jpg'),
            ),
            //  以下、写真取り込み機能のためのフォーマット（実装時間があれば）
            //  Positioned(
            //  bottom: 0,
            //  right: -25,
            //  child: RawMaterialButton(
            //  onPressed: () {},
            //写真取り込み機能はここに
            //  elevation: 2.0,
            //  fillColor: Color(0xFFF5F6F9),
            //  child: Icon(
            //  Icons.camera_alt_outlined,
            //  color: Colors.blue,
            //  ),
            //  padding: EdgeInsets.all(15.0),
            //  shape: CircleBorder(),
            //  )),
            TextField(
              decoration: InputDecoration(hintText: 'ニックネーム'),
              onChanged: (text) {
                nickname = text;
                print('nickname:$nickname');
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: 'ひとこと'),
              onChanged: (text) {
                profile_text = text;
                print('profile_text:$profile_text');
              },
            ),
            TextField(
              decoration: InputDecoration(hintText: '趣味をスペース区切りで入力'),
              onChanged: (text) {
                hobby = text;
                print('hobby:$hobby');
              },
            ),
            RaisedButton(
                onPressed: () async {
                  AccountAPI account = new AccountAPI(auth.getBearer());
                  await account
                      .updateUserProfile(
                          nickname: nickname,
                          profileText: profile_text + "\r\n" + hobby)
                      .then((value) {
                    // print(signupres.nickname);
                    // print(signupres.profile_text);
                    print(value);
                  });
                },
                child: Text('save')),
          ],
        ),
      ),
    );
  }
}
