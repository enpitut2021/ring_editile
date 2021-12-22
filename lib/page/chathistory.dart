import 'package:flutter/material.dart';
//import 'package:html_unescape/html_unescape_small.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/page/chat.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/postList.dart';
import 'package:ring_sns/api/accountAPI.dart';

class ChatHistory extends StatefulWidget {
  ChatHistory(this.auth);
  Auth auth;
  IconData icon;
  String roomid;
  String msg;
  @override
  State<StatefulWidget> createState() => _ChatHistory();
}

class _ChatHistory extends State<ChatHistory> {
  @override
  List<ListTile> chathis = [];
  List<String> r_id = [];
  List<String> r_msg = [];
  ChatAPI chatapi;

  void chathistory_update(String chatroom_id) {
    setState(() {
      chathis.add(ListTile(
        title: Text(chatroom_id),
        onTap: () {},
      ));
    });
  }

  @override
  void initState() {
    chatapi = new ChatAPI(widget.auth.getBearer());
    AccountAPI a = new AccountAPI(widget.auth.getBearer());
    a.getUserPostList().then((posts) {
      posts.forEach((Post post) {
        r_id.add(post.roomId);
        r_msg.add(post.text);
      });
    });
    // print("ok");
    // print(widget.auth.getBearer());
    // chatapi.getChatHistory();

    chatapi.getChatHistory().then((Map history) => {
          history.forEach((roomId, value) {
            int d = -1;
            d = r_id.indexOf(roomId);
            if (d != -1) {
              setState(() {
                chathis.add(ListTile(
                  title: Text(r_msg[d]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatDemo(roomId, widget.auth)),
                    );
                  },
                ));
              });
            }
            // setState(() {
            //   chathis.add(ListTile(
            //     title: Text(widget.msg),
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => ChatDemo(roomId, widget.auth)),
            //       );
            //     },
            //   ));
            // });
          })
        });

    // setState(() {
    //   chathis.add(ListTile(
    //     title: Text(widget.msg),
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ChatDemo(widget.roomid, widget.auth)),
    //       );
    //     },
    //   ));
    // });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[100],
      appBar: AppBar(
        title: Text("チャット"),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => postList(widget.auth)),
                  );
                },
                icon: Icon(Icons.article_rounded),
                iconSize: 50,
                color: Colors.grey,
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
                  color: Colors.black),
            ],
          ),
          Container(
            color: Colors.lime[100],
            height: 550,
            width: double.infinity,
            child: ListView.builder(
              itemCount: chathis.length,
              itemBuilder: (BuildContext context, int index) {
                return chathis[index];
              },
            ),
          ),

          // Row(
          //   children: [
          //     RaisedButton(onPressed: () {
          //       chathistory_update("new_room");
          //     })
          //   ],
          // )
        ],
      ),
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
      //   currentIndex: 1,
      //   selectedItemColor: Colors.cyan[400],
      //   onTap: (int index) {
      //     //_selectedIndex=index;
      //     if (index == 0) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => postList(widget.auth)),
      //       );
      //       //go to home

      //     } else if (index == 1) {
      //       //go to chatlog
      //       // Navigator.push(
      //       //             context,
      //       //             MaterialPageRoute(
      //       //                 builder: (context) => ChatHistory(widget.auth)),
      //       //           );
      //     }
      //   },
      // ),
    );
  }
}
