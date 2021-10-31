import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  String test;

  AccountAPI _accountAPI;

  File _image;
  final picker = ImagePicker();

  Future n_getImage() async {
    print("b");
    final PickedFile _image =
        await ImagePicker().getImage(source: ImageSource.gallery);
    print("a");
    if (_image == null) return;
    final String code = await _accountAPI.uploadUserHeader(_image.path);
    print("a");
  }

  getImage() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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
    _accountAPI = AccountAPI(widget.auth.getBearer());
    print(widget.auth.getUserBackgroundURL());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.auth.getUserId() + "のユーザー設定")),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Text(''),
            CircleAvatar(
              radius: 60,
              // child: _image == null ? NetworkImage(widget.auth.getUserBackgroundURL()) : Image.file(_image),
              backgroundImage: _image == null
                  ? NetworkImage(widget.auth.getUserBackgroundURL())
                  : Image.file(_image),
              // NetworkImage(
              //     widget.auth.getUserBackgroundURL()),
            ),
            //  以下、写真取り込み機能のためのフォーマット（実装時間があれば）
            // Positioned(
            //     bottom: 0,
            //     right: -25,
            //     child:
            Text(''),
            RawMaterialButton(
              onPressed: () {
                n_getImage();
                //getImage();
                print("click");
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
            )
            //)
            ,
            Text(''),
            Text(''),
            TextField(
              controller: TextEditingController(text: _nickname),
              decoration: InputDecoration(
                  hintText: 'ニックネーム',
                  labelText: 'ニックネーム',
                  // filled: true,
                  // fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey[100],
                      ))),
              onChanged: (text) {
                nickname = text;
                print('nickname:$nickname');
              },
            ),
            Text(''),
            TextField(
              controller: TextEditingController(text: _profile_text),
              decoration: InputDecoration(
                hintText: 'ひとこと',
                labelText: 'ひとこと',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blueGrey[200],
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    )),
              ),
              onChanged: (text) {
                profile_text = text;
                print('profile_text:$profile_text');
              },
            ),
            Text(''),
            TextField(
              controller: TextEditingController(text: _hobby),
              decoration: InputDecoration(
                hintText: '趣味をスペース区切りで入力',
                labelText: '趣味をスペースで区切りで入力',
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blueGrey[200],
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.blue,
                    )),
              ),
              onChanged: (text) {
                hobby = text;
                print('hobby:$hobby');
              },
            ),
            Text(''),
            Text(''),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 50),
              child: ElevatedButton(
                  child: Text('save'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () async {
                    AccountAPI account =
                        new AccountAPI(widget.auth.getBearer());
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
                  }),
            ),
            // RaisedButton(
            //     onPressed: () async {
            //       AccountAPI account = new AccountAPI(widget.auth.getBearer());
            //       await account
            //           .updateUserProfile(
            //               nickname: nickname,
            //               profileText: profile_text,
            //               hobby: hobby)
            //           .then((value) {
            //         // print(signupres.nickname);
            //         // print(signupres.profile_text);
            //         //更新されたユーザー情報を再取得する
            //         widget.auth.getCurrentUser();
            //         print(value);
            //       });
            //     },
            //     child: Text('save')),
          ],
        ),
      ),
    );
  }
}
