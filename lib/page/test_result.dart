import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/test.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/page/chat.dart';

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

  bool Press = false;
  int checker = -1;

  @override
  void initState() {
    Color icon_color = Colors.black;
    Press = false;
    print("data");
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
          post_test.add(Column(
            children: [
              // Image.network('https://picsum.photos/250?image=9%27),
              Image.network(
                post.imageUrl,
                errorBuilder: (c, o, s) {
                  return Text("[画像がありません]");
                },
              ),
              Text(u_id + ": " + post.text),
            ],
          ));
          postIds.add(post.postId);
          // print("a");
          print(post_like);

          post_press.add(false);
          print(post_press);
          post_like.forEach((int p_l) {
            if (postIds.indexOf(p_l) != -1) {
              post_press[postIds.indexOf(p_l)] = true;
            }
          });
          print(post_press);

          setState(() {});
        });
      });
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
      appBar: AppBar(
        title: Text("投稿一覧画面"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => test(widget.auth)),
          );
        },
      ),
      body: Column(children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //children: <Widget>[Text("test")],
        ),
        Container(
          height: 600,
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: post_test.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildButtonTileView(post_test[index], index),
          ),
        ),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    this.Press = !this.Press;
                    this._iconcolor = this.Press ? Colors.red : Colors.black;
                  });
                },
                icon: Icon(Icons.favorite, color: this._iconcolor))
          ],
        )
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Colors.blue[900],
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.cyan[400],
        onTap: (int index) {
          //_selectedIndex=index;
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => test(widget.auth)),
            );
            //go to home

          } else if (index == 1) {
            //go to chatlog
            // Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => ChatHistory(widget.auth)),
            //           );
          }
        },
      ),
    );
  }

  Widget _buildButtonTileView(Widget title, int index) {
    return Card(
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
                        builder: (context) => ChatDemo("public", widget.auth)),
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
                },
                icon: Icon(Icons.favorite,
                    color: post_press[index] ? Colors.red : Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
