import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/chat.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/rendering.dart';
import 'package:ring_sns/page/postList.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ring_sns/api/cupyAPI.dart';
import 'package:geolocator/geolocator.dart';
import 'package:universal_platform/universal_platform.dart';

class postStore extends StatefulWidget {
  postStore(this.auth);
  Auth auth;
  String msg = "";
  String e_msg = "";

  @override
  State<StatefulWidget> createState() => _postStore();
}

class _postStore extends State<postStore> {
  // File _image;
  String _imageUrl;
  final _picker = ImagePicker();
  String _location = "nodata";
  //

  String _gps_latitude = "36.1106";
  String _gps_longitude = "140.1007";
  List<String> _distance = ["2", "4", "6", "8", "10", "10000"];
  List<String> _situation = ["カジュアル", "デート向け", "ひとり様歓迎", "団体様歓迎"];
  String _selecteddistance = "2";

  String _selectedsituation = "カジュアル";
  int _distanceindex = 0;
  int _situationindex = 0;

  // String _hinttext_food =
  //     'おしゃれな〇〇に行きました！\nとってもうまうまでした！\n今週中なら半額みたいなので、\n皆さんもぜひ行ってみてください！:\n場所は〇〇3丁目のセブンの角です！';
  // String _hinttext_info =
  //     "今月末〇〇公園で食材提供が実施されます！\nコロナ禍で困窮する学生へ〇〇様から500名分の支援物資が届きます。\nマイバック持参でお越しください！";
  // String _hinttext_climate =
  //     "今ちょうど〇〇を出たところなんだけど、\n急に雨が降ってきた！\n洗濯物取り込んだほうがいいかも...";

  List<String> placefolder = [
    "ジャンルを選んでください",
    'おしゃれな〇〇に行きました！\nとってもうまうまでした！\n今週中なら半額みたいなので、\n皆さんもぜひ行ってみてください！:\n場所は〇〇3丁目のセブンの角です！',
    "今月末〇〇公園で食材提供が実施されます！\nコロナ禍で困窮する学生へ〇〇様から500名分の支援物資が届きます。\nマイバック持参でお越しください！",
    "今ちょうど〇〇を出たところなんだけど、\n急に雨が降ってきた！\n洗濯物取り込んだほうがいいかも..."
  ];

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => postList(widget.auth)),
              );
            },
            icon: Icon(Icons.close)),
        title: Text("投稿画面"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Visibility(
            //     visible: !UniversalPlatform.isWeb,
            //     child: Container(
            //         width: 150,
            //         height: 150,
            //         // margin: const EdgeInsets.only(top: 90),
            //         child: _displaySelectionImageOrGrayImage())),
            // Visibility(
            //   visible: !UniversalPlatform.isWeb,
            //   child: InkWell(
            //     onTap: () {
            //       showDialog(
            //           context: context,
            //           builder: (context) {
            //             return AlertDialog(
            //               title: Text('Aの動作の確認'),
            //             );
            //           });
            //     },
            //     child: Container(
            //       width: 144,
            //       height: 50,
            //       margin: const EdgeInsets.only(top: 47),
            //       decoration: BoxDecoration(
            //         color: const Color(0xfffa4269),
            //         border: Border.all(
            //           width: 2,
            //           color: const Color(0xff000000),
            //         ),
            //         borderRadius: BorderRadius.circular(15),
            //       ),
            //       // child: FlatButton(
            //       //   onPressed: () => _getImageFromGallery(),
            //       //   child: const Text(
            //       //     '写真を選ぶ',
            //       //     textAlign: TextAlign.center,
            //       //     style: TextStyle(
            //       //       color: Color(0xffffffff),
            //       //       fontWeight: FontWeight.w400,
            //       //       fontSize: 15,
            //       //       height: 1.2,
            //       //     ),
            //       //   ),
            //       // ),
            //     ),
            //   ),
            // ),
            Visibility(
                visible: !UniversalPlatform.isWeb,
                child: Container(
                    // width: 180,
                    // height: 180,
                    color: Colors.grey[200],
                    margin: const EdgeInsets.only(bottom: 30),
                    child: _displaySelectionImageOrGrayImage())),
            Container(
              width: 370.0,
              child: TextField(
                maxLines: null,
                minLines: 7,
                decoration: InputDecoration(
                  //errorText: widget.e_msg,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.blueGrey[200],
                  )),
                  hintText: '投稿を書く',
                  hintMaxLines: 6,
                  alignLabelWithHint: true,
                ),
                autofocus: true,
                onChanged: (text) {
                  widget.msg = text;
                },
              ),
            ),
            Text(
              widget.e_msg,
              style: TextStyle(color: Colors.red),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  value: _selecteddistance,
                  onChanged: (String newValue) {
                    setState(() {
                      _selecteddistance = newValue;
                      _distanceindex = _distance.indexOf(_selecteddistance);
                    });
                  },
                  selectedItemBuilder: (context) {
                    return _distance.map((String item) {
                      return Text(
                        item + "km",
                        style: TextStyle(color: Colors.black),
                      );
                    }).toList();
                  },
                  items: _distance.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item + "km",
                      ),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  value: _selectedsituation,
                  onChanged: (String newValue) {
                    setState(() {
                      _selectedsituation = newValue;
                      _situationindex = _situation.indexOf(_selectedsituation);
                    });
                  },
                  selectedItemBuilder: (context) {
                    return _situation.map((String item) {
                      return Text(
                        item,
                        style: TextStyle(color: Colors.black),
                      );
                    }).toList();
                  },
                  items: _situation.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        // style: item == _selecteddistance
                        //     ? TextStyle(fontWeight: FontWeight.bold)
                        //     : TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            Text(""),
            ButtonTheme(
              minWidth: 100.0,
              height: 40.0,
              buttonColor: Colors.grey[200],
              child: RaisedButton(
                  child: Text('投稿'),
                  onPressed: () {
                    AccountAPI a = new AccountAPI(widget.auth.getBearer());
                    // a.postUserPost(widget.msg, '');
                    if (widget.msg != "") {
                      a
                          .postUserPost(
                              widget.msg,
                              _imageUrl,
                              _gps_latitude,
                              _gps_longitude,
                              _selectedsituation,
                              _selecteddistance)
                          .then((value) => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          postList(widget.auth)),
                                )
                              });
                    } else {
                      setState(() {
                        widget.e_msg = '文字を入力してください';
                      });
                    }
                  }),
            ),
            // RaisedButton(
            //     child: Text('投稿一覧画面へ'),
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => postList(widget.auth)),
            //       );
            //     }),
          ],
        ),
      )),
    );
  }

  Widget _displaySelectionImageOrGrayImage() {
    if (_imageUrl == null) {
      return InkWell(
          onTap: () {
            _getImageFromGallery();
          },
          child: Container(
            width: 370,
            height: 100,
            // color: Colors.grey[200],
            decoration: BoxDecoration(
                // border: Border.all(
                //   width: 2,
                //   color: const Color(0xff000000),
                // ),
                ),
            child: ClipRRect(
              child: Icon(Icons.photo_size_select_actual_outlined, size: 40),
              // child: Image.network(
              //   "https://cupy.p0x0q.com/l0edrn64.png",
              //   fit: BoxFit.fill,
              // ),
            ),
          ));
    } else {
      return InkWell(
          onTap: () {
            _getImageFromGallery();
          },
          child: Container(
            width: 360,
            height: 240,
            decoration: BoxDecoration(
                // border: Border.all(
                //   width: 2,
                //   color: const Color(0xff000000),
                // ),
                ),
            child: ClipRRect(
              child: Image.network(
                _imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ));
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
