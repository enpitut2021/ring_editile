import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/test.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/page/chat.dart';
import 'package:ring_sns/page/chathistory.dart';
import 'package:ring_sns/page/usersetting.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class test_result extends StatefulWidget {
  test_result(this.auth);
  Auth auth;

  @override
  State<StatefulWidget> createState() => _testresult();
}

class _testresult extends State<test_result> {
  List<Widget> post_test = [];
  Color _iconcolor = Colors.black;
  List<int> postIds = [];
  List<bool> post_press = [];
  List<int> post_like = [];
  List<String> roomid = [];
  List<String> post_msg = [];
  List<String> _gps = [];
  String _gps_latitude = '35.6812362';
  String _gps_longitude = '139.7649361';
  int _likeCount = 0;

  bool Press = false;
  int checker = -1;
  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // print("緯度: " + position.latitude.toString());
    // print("経度: " + position.longitude.toString());
    _gps_latitude = position.latitude.toString();
    _gps_longitude = position.longitude.toString();
  }

  double distanceBetween(
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
    final double d = 2 * r * asin(sqrt(a + b));
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
    print("gps:" + _gps_latitude.toString() + _gps_longitude.toString());
    Color icon_color = Colors.black;
    Press = false;
    // print("data");
    bool temp_p = this.Press;
    print(widget.auth.getBearer());
    AccountAPI a = new AccountAPI(widget.auth.getBearer());
    String u_id;
    a.getUserLikeList().then((p_likes) {
      p_likes.forEach((PostLike p) {
        print("p_like is");
        print(p.postId);
        post_like.add(p.postId);
      });
      print(post_like);
    });
    print("p_likes");
    print(post_like);
    // print(post_like);
    a.getUserPostList().then((posts) {
      posts.forEach((Post post) {
        print(post.imageUrl);
        a.getUserNumInfo(post.user).then((User user) {
          u_id = user.userId;
          if (post.imageUrl != "") {
            post_test.add(Column(
              children: <Widget>[
                FittedBox(
                  child: Container(
                    width: 1000.0,
                    height: 800.0,
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
                Text(u_id + ": " + post.text),
              ],
            ));
          } else {
            post_test.add(Column(
              children: <Widget>[
                Container(
                  height: 400,
                  alignment: Alignment.center,
                  child: Text(u_id + ": " + post.text),
                ),
              ],
            ));
          }
          postIds.add(post.postId);
          _gps.add(post.gps_latitude.toString() +
              "," +
              post.gps_longitude.toString());
          post_msg.add(post.text);
          print("roomid is");
          print(post.roomId);
          // print("a");
          // print(post_like);
          post_press.add(false);
          print(post_press);
          roomid.add(post.roomId);
          post_like.forEach((int p_l) {
            if (postIds.indexOf(p_l) != -1) {
              post_press[postIds.indexOf(p_l)] = true;
            }
          });
          print(post_press);

          setState(() {});
        });
      });
      a.getUserLikeList().then((p_like) {
        p_like.forEach((PostLike p) {
          print(p.postId);
          if (postIds.indexOf(p.postId) != -1) {
            post_press[postIds.indexOf(p.postId)] = true;
          }
          setState(() {});
        });
      });
      // print(a.getUserLikeList());
      //   a.getUserLikeList().then((p_like) {
      //   p_like.forEach((PostLike posts) {
      //     print(posts.postId);
      //     // post_press[postIds.indexOf(posts.postId).toInt()]=true;
      //   });
      // });
      //print(post_press);
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
    return Scaffold(
      backgroundColor: Colors.lime[100],
      appBar: AppBar(
          title: Text("投稿一覧画面"),
          automaticallyImplyLeading: false,
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
      //       MaterialPageRoute(builder: (context) => test(widget.auth)),
      //     );
      //   },
      // ),
      body: Column(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //children: <Widget>[Text("test")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.article_rounded),
              iconSize: 50,
              color: Colors.black,
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatHistory(widget.auth)),
                  );
                },
                icon: Icon(Icons.chat),
                iconSize: 50,
                color: Colors.grey),
          ],
        ),
        Container(
          height: 400,
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: post_test.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildButtonTileView(post_test[index], index),
          ),
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
              children: [],
            ),
            FloatingActionButton(
              heroTag: "3",
              backgroundColor: Colors.black87,
              child: Icon(
                Icons.border_color_outlined,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => test(widget.auth)),
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
      //         MaterialPageRoute(builder: (context) => test(widget.auth)),
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

  Widget _buildButtonTileView(Widget title, int index) {
    return Card(
      color: Colors.brown[100],
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            title,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChatDemo(roomid[index], widget.auth)),
                    );
                  },
                ),
                
                IconButton(
                  onPressed: () {
                    AccountAPI a = new AccountAPI(widget.auth.getBearer());

                    a.getUserNumInfo(1).then((User user) {
                      print("1");
                      print(user.nickname);
                    });
                    setState(() {
                      //print(postIds[index]);
                      post_press[index] = !post_press[index];
                    });
                    a.postUserLikePost(postIds[index], post_press[index]);
                    _likeCount += 1;
                  },
                  icon: Icon(Icons.favorite,
                      color: _likeCount == 0 ? Colors.black : Colors.red),
                ),
                Text(
                  '$_likeCount'
                ),
                IconButton(
                  onPressed: () {
                    _launchURL(_gps[index]);
                  },
                  icon: Icon(Icons.add_location_rounded, color: Colors.black),
                )
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
