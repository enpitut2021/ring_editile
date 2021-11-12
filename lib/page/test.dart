import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/chat.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/rendering.dart';
import 'package:ring_sns/page/test_result.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ring_sns/api/cupyAPI.dart';
import 'package:geolocator/geolocator.dart';

class test extends StatefulWidget {
  test(this.auth);
  Auth auth;
  String msg = "";
  String e_msg = "";

  @override
  State<StatefulWidget> createState() => _test();
}

class _test extends State<test> {
  // File _image;
  String _imageUrl;
  final _picker = ImagePicker();
  String _location = "nodata";
  String _gps_latitude = "";
  String _gps_longitude = "";
  List<String> _genre = ["--","飲食","お知らせ","気候"];
  String _selectedgenre = "--";

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print("緯度: " + position.latitude.toString());
    print("経度: " + position.longitude.toString());
    _gps_latitude = position.latitude.toString();
    _gps_longitude = position.longitude.toString();

    print(position);
    setState(() {
      _location = position.toString();
    });
  }

  void initState() {
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => test_result(widget.auth)),
              );
            },
            icon: Icon(Icons.close)),
        title: Text("投稿画面"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.only(top: 90),
                child: _displaySelectionImageOrGrayImage()),
            Container(
              width: 144,
              height: 50,
              margin: const EdgeInsets.only(top: 47),
              decoration: BoxDecoration(
                color: const Color(0xfffa4269),
                border: Border.all(
                  width: 2,
                  color: const Color(0xff000000),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlatButton(
                onPressed: () => _getImageFromGallery(),
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
            DropdownButton<String>(
              value: _selectedgenre,
              onChanged: (String newValue){
                setState(() {
                  _selectedgenre = newValue;
                });
              }
            ),
            TextField(
              decoration: InputDecoration(
                //errorText: widget.e_msg,

                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blueGrey[200],
                )),
                labelText: '投稿',
              ),
              autofocus: true,
              onChanged: (text) {
                widget.msg = text;
              },
            ),
            Text(
              widget.e_msg,
              style: TextStyle(color: Colors.red),
            ),
            Text("$_location,"),
            RaisedButton(
                child: Text('投稿'),
                onPressed: () {
                  AccountAPI a = new AccountAPI(widget.auth.getBearer());
                  // a.postUserPost(widget.msg, '');
                  if (widget.msg != "") {
                    a.postUserPost(widget.msg, _imageUrl, _gps_latitude, _gps_longitude).then((value) => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => test_result(widget.auth)),
                          )
                        });
                  } else {
                    setState(() {
                      widget.e_msg = '文字を入力してください';
                    });
                  }
                }),
            // RaisedButton(
            //     child: Text('投稿一覧画面へ'),
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => test_result(widget.auth)),
            //       );
            //     }),
          ],
        ),
      ),
    );
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
          ),
        ],
      );
    }
  }

  Future _getImageFromGallery() async {
    CupyAPI b = new CupyAPI(widget.auth.getBearer());
    String imageUrl = await b.uploadImageWithPicker();
    setState(() => _imageUrl = imageUrl);
  }
}
