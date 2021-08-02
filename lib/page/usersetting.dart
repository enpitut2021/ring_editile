import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'dart:html';

class Usersetting extends StatefulWidget {
  //ここにイニシャライザを書く
  Usersetting(this.auth);
  Auth auth;
  @override
  State<StatefulWidget> createState() => _Usersetting();
}

class _Usersetting extends State<Usersetting> {
  // Auth auth;
  // Auth auth = new Auth();
  String nickname = '';
  String profile_text = '';
  String hobby = '';

  String _nickname = '';
  String _profile_text = '';
  String _hobby = '';

  @override
  void initState() {
    //for sen
    setState(() {
      _nickname = widget.auth.getNickname();
      _profile_text = widget.auth.getDescription();
      _hobby = widget.auth.getHobby();
      nickname = _nickname;
      profile_text = _profile_text;
      hobby = _hobby;
    });
  }

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
            Positioned(
                bottom: 0,
                right: -25,
                child: RawMaterialButton(
                  onPressed: () {
                    void pickupImage() {
                      InputElement uploadInput = FileUploadInputElement()
                        ..accept = 'image/*';
                      uploadInput.click();

                      uploadInput.onChange.listen((event) {
                        final file = uploadInput.files.first;
                        final reader = FileReader();
                        reader.readAsDataUrl(file);
                        reader.onLoadEnd.listen((event) {
                          print('done');
                        });
                      });
                    }
                  },
                  //写真取り込み機能はここに
                  elevation: 2.0,
                  fillColor: Color(0xFFF5F6F9),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.blue,
                  ),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                )),
            TextField(
              controller: TextEditingController(text: _nickname),
              decoration: InputDecoration(hintText: 'ニックネーム'),
              onChanged: (text) {
                nickname = text;
                print('nickname:$nickname');
              },
            ),
            TextField(
              controller: TextEditingController(text: _profile_text),
              decoration: InputDecoration(hintText: 'ひとこと'),
              onChanged: (text) {
                profile_text = text;
                print('profile_text:$profile_text');
              },
            ),
            TextField(
              controller: TextEditingController(text: _hobby),
              decoration: InputDecoration(hintText: '趣味をスペース区切りで入力'),
              onChanged: (text) {
                hobby = text;
                print('hobby:$hobby');
              },
            ),
            RaisedButton(
                onPressed: () async {
                  AccountAPI account = new AccountAPI(widget.auth.getBearer());
                  await account
                      .updateUserProfile(
                          nickname: nickname,
                          profileText: profile_text,
                          hobby: hobby)
                      .then((value) {
                    // print(signupres.nickname);
                    // print(signupres.profile_text);
                    //更新されたユーザー情報を再取得する
                    widget.auth.getCurrentUser();
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
