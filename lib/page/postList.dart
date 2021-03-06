import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/postStore.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/page/chat.dart';
import 'package:ring_sns/page/chathistory.dart';
import 'package:ring_sns/page/usersetting.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class postList extends StatefulWidget {
  postList(this.auth);
  Auth auth;
  @override
  State<StatefulWidget> createState() => _testresult();
}

class _testresult extends State<postList> {
  List<Widget> post_test = [];
  Color _iconcolor = Colors.black;
  List<int> postIds = [];
  List<bool> post_press = [];
  List<int> post_like = [];
  List<String> roomid = [];
  List<String> post_msg = [];
  List<String> _gps = [];
  List<String> create_time = [];
  List<String> _postDistance = [];
  List<String> _distanceList = [];

  var endDate = new DateTime.now();

  List<String> tag = [];
  String gps_state = "nodata";

  List<double> _gps_la = [];
  List<double> _gps_lo = [];

  String _gps_latitude = "36.1106";
  String _gps_longitude = "140.1007";

  String _toukouDistance = '';
  List<int> _commentCount = [];

  List<int> _likeUserCount = [];
  List<int> _likeAPICount = [];

  bool Press = false;
  int checker = -1;
  List<String> _genre = ["ラーメン", "定食", "カフェ", "その他"];
  List<String> _situation = ["全て", "カジュアル", "デート向け", "ひとり様歓迎", "団体様歓迎"];
  String _selectedgenre = "全て";
  String _selectedsituation = "全て";
  int _genreindex = 0;
  int _situationindex = 0;
  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // print("緯度: " + position.latitude.toString());
    // print("経度: " + position.longitude.toString());
    _gps_latitude = position.latitude.toString();
    _gps_longitude = position.longitude.toString();

    gps_state = position.toString();
  }

  // Future<void> getDistance()

  String distanceBetween(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    final toRadians = (double degree) => degree * pi / 180;
    final double r = 6378137.0; // 地球の半径
    final double f1 = toRadians(latitude1);
    final double f2 = toRadians(latitude2);
    final double l1 = toRadians(longitude1);
    final double l2 = toRadians(longitude2);
    final num a = pow(sin((f2 - f1) / 2), 2);
    final double b = cos(f1) * cos(f2) * pow(sin((l2 - l1) / 2), 2);
    final String d = (2 * r * asin(sqrt(a + b)) / 1000).toStringAsFixed(1);
    return d;
  }

  void _launchURL(String url_suffix) async {
    String url =
        "https://www.google.com/maps/dir/Current+Location/" + url_suffix;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not Launch $url';
    }
  }

  @override
  void initState() {
    getLocation();
    //print("gps:" + _gps_latitude.toString() + _gps_longitude.toString());
    Color icon_color = Colors.black;
    Press = false;
    // print("data");
    bool temp_p = this.Press;
    //print(widget.auth.getBearer());
    AccountAPI a = new AccountAPI(widget.auth.getBearer());
    ChatAPI c = new ChatAPI(widget.auth.getBearer());
    // String u_id;

    a.getUserLikeList().then((p_likes) {
      p_likes.forEach((PostLike p) {
        //print("p_like is");
        //print(p.postId);
        post_like.add(p.postId);
      });
      //print(post_like);
    });
    //print("p_likes");
    //print(post_like);
    // print(post_like);
    a.getUserPostList().then((posts) {
      posts.forEach((Post post) async {
        //print(post.imageUrl);
        //print(post.likes);
        _likeAPICount.add(post.likes);
        _likeUserCount.add(0);
        _commentCount.add(post.count);

        // a.getUserNumInfo(post.user).then((User user) {
        //   u_id = user.userId;
        //   });
        if (post.imageUrl != "") {
          post_test.add(Column(
            children: <Widget>[
              FittedBox(
                child: Container(
                  width: 600.0,
                  height: 400.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(post.imageUrl),
                    ),
                  ),
                ),
              ),
              // Image.network(
              //   post.imageUrl,
              //   errorBuilder: (c, o, s) {
              //     return Text("[画像がありません]");
              //   },
              // ),
              Text(post.text),
            ],
          ));
        } else {
          post_test.add(Column(
            children: <Widget>[
              Container(
                height: 150,
                alignment: Alignment.center,
                child: Text(post.text),
              ),
            ],
          ));
        }
        _distanceList.add(distanceBetween(
            double.parse(_gps_latitude),
            double.parse(_gps_longitude),
            // 0.0,
            // 0.0,
            post.gps_latitude,
            post.gps_longitude));
        postIds.add(post.postId);
        tag.add(post.category);
        create_time.add(post.created);
        _gps_la.add(post.gps_latitude);
        _gps_lo.add(post.gps_longitude);
        _postDistance.add(post.subCategory);
        _gps.add(
            post.gps_latitude.toString() + "," + post.gps_longitude.toString());
        post_msg.add(post.text);
        //print("roomid is");
        //print(post.roomId);
        // print("a");
        // print(post_like);
        post_press.add(false);
        //print(post_press);
        roomid.add(post.roomId);

        post_like.forEach((int p_l) {
          if (postIds.indexOf(p_l) != -1) {
            post_press[postIds.indexOf(p_l)] = true;
          }
        });
        //print(post_press);
      });
      a.getUserLikeList().then((p_like) {
        p_like.forEach((PostLike p) {
          //print(p.postId);
          if (postIds.indexOf(p.postId) != -1) {
            post_press[postIds.indexOf(p.postId)] = true;
          }
        });
      });
      if (gps_state == "nodata") {
        _gps_latitude = "36.1106";
        _gps_longitude = "140.1007";
      }
      // print(a.getUserLikeList());
      //   a.getUserLikeList().then((p_like) {
      //   p_like.forEach((PostLike posts) {
      //     print(posts.postId);
      //     // post_press[postIds.indexOf(posts.postId).toInt()]=true;
      //   });
      // });
      //print(post_press);
      setState(() {});
    });
    // print("a");
    // print(post_press);
    // a.getUserLikeList().then((p_like){
    //   p_like.forEach((PostLike p) {
    //     print("a");
    //     // print(p.postId);
    //     post_like.add(p.postId);
    //     print(p.postId);
    //     if(postIds.indexOf(p.postId)!=-1){
    //       post_press[postIds.indexOf(p.postId)]=true;
    //     }

    //   });
    // });
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lime[100],
      appBar: AppBar(
          title: Text("投稿一覧画面"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => setState(() {
                post_test = [];
                postIds = [];
                post_press = [];
                post_like = [];
                roomid = [];
                post_msg = [];
                _gps = [];
                create_time = [];
                _postDistance = [];
                _distanceList = [];

                tag = [];
                _gps_la = [];
                _gps_lo = [];

                _commentCount = [];

                _likeUserCount = [];
                _likeAPICount = [];

                Press = false;
                checker = -1;
                _selectedgenre = "全て";
                _selectedsituation = "全て";
                _genreindex = 0;
                _situationindex = 0;

                initState();
              }),
            ),
          ],
          leading: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: 27.0,
                backgroundImage:
                    NetworkImage(widget.auth.getUserBackgroundURL()),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Usersetting(widget.auth, null)),
                  );
                },
                child: Container(
                  width: 54.0,
                  height: 54.0,
                ),
                shape: new CircleBorder(),
                elevation: 0.0,
              ),
            ],
          )
          // RaisedButton(
          //   color: Colors.white,
          //   shape: const CircleBorder(
          //     side: BorderSide(
          //       color: Colors.black,
          //       width: 1,
          //       style: BorderStyle.solid,
          //     ),
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Usersetting(widget.auth, null)),
          //     );
          //   },
          // ),
          ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => postStorewidget.auth)),
      //     );
      //   },
      // ),
      body: Column(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //children: <Widget>[Text("test")],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(Icons.article_rounded),
        //       iconSize: 50,
        //       color: Colors.black,
        //     ),
        //     IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => ChatHistory(widget.auth)),
        //           );
        //         },
        //         icon: Icon(Icons.chat),
        //         iconSize: 50,
        //         color: Colors.grey),
        //   ],
        // ),
        Container(
          height: size.height * 0.72,
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: post_test.length,
              itemBuilder: (BuildContext context, int index) =>
                  ((tag[index] == _selectedsituation ||
                              _selectedsituation == "全て") &&
                          double.parse(_distanceList[index]) <=
                              double.parse(_postDistance[index]))
                      ? _buildButtonTileView(post_test[index], index)
                      : Column()),
        ),
        Text(""),
        Text(""),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // FloatingActionButton(
            //   heroTag: "1",
            //   backgroundColor: Colors.white,
            //   child: Icon(
            //     Icons.add_location_rounded,
            //     size: 30,
            //     color: Colors.black,
            //   ),
            //   onPressed: () {},
            // )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // FloatingActionButton(
            //   heroTag: "2",
            //   backgroundColor: Colors.black87,
            //   child: Icon(
            //     Icons.auto_stories_rounded,
            //     size: 40,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {},
            // ),
            Column(
              children: [
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
                        // style: item == _selectedgenre
                        //     ? TextStyle(fontWeight: FontWeight.bold)
                        //     : TextStyle(fontWeight: FontWeight.normal),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            FloatingActionButton(
              heroTag: "3",
              backgroundColor: Colors.black87,
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => postStore(widget.auth)),
                );
              },
            ),
          ],
        )
      ]),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       backgroundColor: Colors.blue[900],
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat),
      //       label: 'Chat',
      //       backgroundColor: Colors.blue[900],
      //     ),
      //   ],
      //   currentIndex: 0,
      //   selectedItemColor: Colors.cyan[400],
      //   onTap: (int index) {
      //     //_selectedIndex=index;
      //     if (index == 0) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => postStorewidget.auth)),
      //       );
      //       //go to home

      //     } else if (index == 1) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => ChatHistory(widget.auth)),
      //       );
      //     }
      //   },
      // ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      labelPadding: EdgeInsets.all(1.0),
      avatar: CircleAvatar(
        backgroundColor: Colors.white70,
        child: Icon(
          Icons.label_important,
          color: Colors.white,
        ),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      backgroundColor: color,
      elevation: 6.0, // 影の大きさ
      shadowColor: Colors.grey[60], // 影の色
      padding: EdgeInsets.all(3.0),
    );
  }

  String showTime(int index) {
    // final calcDays = endDate.difference(DateTime.parse(create_time[index]));
    // final Duration difference = DateTime.now().difference(date);
    final Duration difference =
        endDate.difference(DateTime.parse(create_time[index]));

    final int sec = difference.inSeconds;

    if (sec >= 60 * 60 * 24) {
      return '${difference.inDays.toString()}日前';
    } else if (sec >= 60 * 60) {
      return '${difference.inHours.toString()}時間前';
    } else if (sec >= 60) {
      return '${difference.inMinutes.toString()}分前';
    } else if (sec > 10) {
      return '$sec秒前';
    } else {
      return '現在';
    }
  }

  Widget _buildButtonTileView(Widget title, int index) {
    return Card(
      color: Color(0xFFFFFFFE),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            title,
            // _buildChip(tag[index], Colors.black),
            // Text(endDate.difference(DateTime.parse(create_time[index])).inDays.toString()+"日前"),
            // Text(endDate.difference(DateTime.parse(create_time[index])).inHours.toString()+"時間前"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Row(
                  children: [
                    Text(showTime(index),
                        style: TextStyle(color: Colors.black45)),
                    Text('  # ' + tag[index],
                        style: TextStyle(color: Colors.black45)),
                    // IconButton(
                    // onPressed: () {
                    //   _launchURL(_gps[index]);
                    // },
                    Icon(Icons.add_location_rounded, color: Colors.black45),
                    // ),
                    Text(
                        distanceBetween(
                                double.parse(_gps_latitude),
                                double.parse(_gps_longitude),
                                // 0.0,
                                // 0.0,
                                _gps_la[index],
                                _gps_lo[index]) +
                            "km",
                        style: TextStyle(color: Colors.black45)),
                  ],
                )),
                Container(
                    child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        AccountAPI a = new AccountAPI(widget.auth.getBearer());

                        // a.getUserNumInfo(1).then((User user) {
                        //   print("1");
                        //   print(user.nickname);
                        // });
                        setState(() {
                          //print(postIds[index]);
                          post_press[index] = !post_press[index];
                        });
                        a.postUserLikePost(postIds[index], true);
                        _likeUserCount[index] += 1;
                        _likeAPICount[index] += 1;
                      },
                      icon: Icon(Icons.favorite,
                          color: _likeUserCount[index] == 0
                              ? Colors.black
                              : Colors.red),
                    ),
                    Text(_likeAPICount[index].toString()),
                  ],
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text('ルートを確認'),
                  onPressed: () {
                    _launchURL(_gps[index]);
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "会話に参加",
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: '(' +
                                (_commentCount.length > 0
                                    ? (_commentCount[index]).toString()
                                    : "0") +
                                ')',
                            style: TextStyle(color: Colors.blueGrey)),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatDemo(roomid[index], widget.auth)),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      // child: Column(
      //   children: <Widget>[
      //     title,
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         IconButton(
      //           icon: Icon(Icons.chat),
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) =>
      //                       ChatDemo(roomid[index], widget.auth)),
      //             );
      //           },
      //         ),
      //         IconButton(
      //           onPressed: () {
      //             AccountAPI a = new AccountAPI(widget.auth.getBearer());

      //             a.getUserNumInfo(1).then((User user) {
      //               print("1");
      //               print(user.nickname);
      //             });

      //             setState(() {
      //               //print(postIds[index]);
      //               post_press[index] = !post_press[index];
      //             });
      //             a.postUserLikePost(postIds[index], post_press[index]);
      //           },
      //           icon: Icon(Icons.favorite,
      //               color: post_press[index] ? Colors.red : Colors.black),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
