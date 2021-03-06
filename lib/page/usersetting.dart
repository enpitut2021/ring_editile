import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/api/cupyAPI.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ring_sns/page/login.dart';

class Usersetting extends StatefulWidget {
  //ここにイニシャライザを書く
  Usersetting(@required this.auth, this.reload);
  Auth auth;
  final Function reload;
  @override
  State<StatefulWidget> createState() => _Usersetting();
}

class _Usersetting extends State<Usersetting> {
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();
  // Auth auth;
  // Auth auth = new Auth();
  String nickname = '';
  String profile_text = '';
  String hobby = '';
  String _imageUrl;
  String _nickname = '';
  String _profile_text = '';
  String _hobby = '';
  String test;
  List<Widget> post_own = [];
  bool _loading = false;

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

  // getImage() async {
  //   PickedFile pickedFile = await ImagePicker().getImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  void initState() {
    _accountAPI = AccountAPI(widget.auth.getBearer());
    _accountAPI.getUserPostMyList().then((posts) {
      posts.forEach((Post p) { 
        
        post_own.add(
          Column(children: [
             Image.network(
                p.imageUrl,
                errorBuilder: (c, o, s) {
                  return Text(p.text);
                },
              ),
              
          ],)
        );
        setState(() {
          
        });
        
        
      });
    }
    );
    
    //for sen
    setState(() {
      _nickname = widget.auth.getNickname();
      _profile_text = widget.auth.getDescription();
      _hobby = widget.auth.getHobby();
      nickname = _nickname;
      profile_text = _profile_text;
      hobby = _hobby;
    });
    
      
    print(widget.auth.getUserBackgroundURL());
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(widget.auth.getUserId() + "のユーザー設定")),
      body: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
                width: 150,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.only(top: 30),
                child: widget.auth.getUserIcon()),
            Container(
              width: 130,
              height: 40,
              margin: const EdgeInsets.only(top: 47),
              decoration: BoxDecoration(
                color: const Color(0xfffa4269),
                border: Border.all(
                  width: 2,
                  color: const Color(0xfffa4269),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlatButton(
                onPressed: () => _uploadUserIcon(),
                child: const Text(
                  '写真を選ぶ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    height: 1.2,
                  ),
                ),
              ),
            ),
            Text(""),
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
            // Text(''),
            // TextField(
            //   controller: TextEditingController(text: _profile_text),
            //   decoration: InputDecoration(
            //     hintText: 'ひとこと',
            //     labelText: 'ひとこと',
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //         borderSide: BorderSide(
            //           color: Colors.blueGrey[200],
            //         )),
            //     focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //         borderSide: BorderSide(
            //           color: Colors.blue,
            //         )),
            //   ),
            //   onChanged: (text) {
            //     profile_text = text;
            //     print('profile_text:$profile_text');
            //   },
            // ),
            // Text(''),
            // TextField(
            //   controller: TextEditingController(text: _hobby),
            //   decoration: InputDecoration(
            //     hintText: '趣味をスペース区切りで入力',
            //     labelText: '趣味をスペースで区切りで入力',
            //     enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //         borderSide: BorderSide(
            //           color: Colors.blueGrey[200],
            //         )),
            //     focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //         borderSide: BorderSide(
            //           color: Colors.blue,
            //         )),
            //   ),
            //   onChanged: (text) {
            //     hobby = text;
            //     print('hobby:$hobby');
            //   },
            // ),
            // Text(''),
            // Text(''),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 40),
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
            Container(
              width: 150,
                height: 10,
            ),
             ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 40),
              child: ElevatedButton(
                  child: Text('logout'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => LoginPage(widget.auth),
                     ),
                   );
                  },
                  ),
            ),
            Container(
          height: size.height*0.3,
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: post_own.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildButtonTileView(post_own[index], index),
          ),
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

  Widget _buildButtonTileView(Widget title, int index) {
    return Card(
      color: Colors.brown[100],
      child: InkWell(
        //onTap: (){},
        onDoubleTap: (){},

        child: Column(
        children: <Widget>[
          title,
          
        ],
      ),
      ),
      
      
     
    )
    ;
  }


  Widget _displaySelectionImageOrGrayImage() {
    if (_imageUrl == null) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xffdfdfdf),
          border: Border.all(
            width: 2,
            color: const Color(0xff000000),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: const Color(0xff000000),
          ),
        ),
        child: ClipRRect(
          child: Image.network(
            _imageUrl,
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }

  Widget _displayInSelectedImage() {
    if (_imageUrl == null) {
      return Column();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20, right: 20),
              child: InkWell(
                child: Image.asset(
                  'assets/images/ic_send.png',
                ),
              ),
            ),
          )
        ]);
    }
  }
  Future<File> _imageCrop(PickedFile image) async {
    return ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }

  void _uploadUserIcon() async {
    // final PickedFile image =
    //     await ImagePicker().getImage(source: ImageSource.gallery);
    // if (image == null) return;
    // File croppedImage = await _imageCrop(image);
    // final String code = await _accountAPI.uploadUserIcon(croppedImage.path);
    // if (code == 'ok') {
    //   _scaffoldstate.currentState.showSnackBar(
    //       SnackBar(content: Text('画像をアップロードしました\n(反映には時間がかかることがあります)')));
    //   if (widget.reload != null) widget.reload();
    // } else {
    //   _scaffoldstate.currentState
    //       .showSnackBar(SnackBar(content: Text('画像のアップロードに失敗しました')));
    // }

    CupyAPI b = new CupyAPI(widget.auth.getBearer());
    String imageUrl = await b.callImagePicker();
    AccountAPI a = new AccountAPI(widget.auth.getBearer());
    a.uploadUserIcon(imageUrl).then((value) => {
      widget.auth.reloadUser().then((value) => {
        setState(() => {})
      })
    });
    

    // Widget _displaySelectionImageOrGrayImage() {
    //   if (_imageUrl == null) {
    //     return Container(
    //       decoration: BoxDecoration(
    //         color: const Color(0xffdfdfdf),
    //         border: Border.all(
    //           width: 2,
    //           color: const Color(0xff000000),
    //         ),
    //       ),
    //     );
    //   } else {
    //     return Container(
    //       decoration: BoxDecoration(
    //         border: Border.all(
    //           width: 2,
    //           color: const Color(0xff000000),
    //         ),
    //       ),
    //       child: ClipRRect(
    //         child: Image.network(
    //           _imageUrl,
    //           fit: BoxFit.fill,
    //         ),
    //       ),
    //     );
    //   }
    // }

    // Widget _displayInSelectedImage() {
    //   if (_imageUrl == null) {
    //     return Column();
    //   } else {
    //     return Column(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: <Widget>[
    //         Align(
    //           alignment: Alignment.topRight,
    //           child: Container(
    //             margin: const EdgeInsets.only(bottom: 20, right: 20),
    //             child: InkWell(
    //               child: Image.asset(
    //                 'assets/images/ic_send.png',
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     );
    //   }
    // }

    // Future _getImageFromGallery() async {
    //   AccountAPI b = new AccountAPI(widget.auth.getBearer());
    //   String imageUrl = await b.uploadUserIcon();
    //   setState(() => _imageUrl = imageUrl);
    // }
  }
}
