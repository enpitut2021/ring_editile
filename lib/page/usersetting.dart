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

// 以下作業
//  @override
//  Widget build(BuildContext context) {
//   return SizedBox(
//      height: 115,
//      width: 115,
//      child: Stack(
//        clipBehavior: Clip.none,
//        fit: StackFit.expand,
//        children: [
//          CircleAvatar(
//            backgroundImage: AssetImage("assets/images/Profile Image.png"),
//          ),
//          Positioned(
//              bottom: 0,
//              right: -25,
//              child: RawMaterialButton(
//                onPressed: () {},
//               elevation: 2.0,
//                fillColor: Color(0xFFF5F6F9),
//                child: Icon(
//                  Icons.camera_alt_outlined,
//                  color: Colors.blue,
//                ),
//                padding: EdgeInsets.all(15.0),
//                shape: CircleBorder(),
//              )),
//        ],
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("のユーザー設定")),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
//            CircleAvatar(
//             radius: 60,
//              backgroundImage: AssetImage("assets/images/Profile Image.png"),
//             child: Stack(children: [
//                Align(
//                  alignment: Alignment.bottomRight,
//                  child: CircleAvatar(
//                    radius: 18,
//                    backgroundColor: Colors.white70,
//                    child: Icon(CupertinoIcons.camera),
//                  ),
//                ),
//              ]),
//            ),
            TextField(
              decoration: InputDecoration(hintText: 'ニックネーム'),
              onChanged: (text) {
                nickname = text;
                print('nickname:$nickname');
              },
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'ひとこと'),
              onChanged: (text) {
                profile_text = text;
                print('profile_text:$profile_text');
              },
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: '趣味をスペース区切りで入力'),
              onChanged: (text) {
                hobby = text;
                print('hobby:$hobby');
              },
            ),
            RaisedButton(
                onPressed: () async {
                  AccountAPI account = new AccountAPI(auth.getBearer());
                  dynamic signupres = await account.updateUserProfile(
                      nickname: nickname,
                      profileText: profile_text + "\r\n" + hobby);
                  print(signupres.nickname);
                  print(signupres.profile_text);
                },
                child: Text('save')),
          ],
        ),
      ),
    );
  }
}
