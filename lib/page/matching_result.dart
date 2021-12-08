import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/chat.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/rendering.dart';

class Match_Result extends StatefulWidget {
  Match_Result(this.auth, this.room_id, this.target_userid);
  Auth auth;
  String room_id;
  String target_userid;

  @override
  State<StatefulWidget> createState() => _Match_Result();
}

class _Match_Result extends State<Match_Result> {
  int sec = 5;
  String infomsg = "秒後チャットルームに入ります";
  //bool match_res=false;

  void initState() {
    nextpage();
  }

  void nextpage() async {
    while (sec > 0) {
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        sec -= 1;
      });
    }

    print("matching success");
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChatDemo(widget.room_id, widget.auth)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  widget.auth.getUserIdBackgroundURL(widget.target_userid)),
              radius: 100,
            ),
            Text(
              '${widget.target_userid}さんとマッチングしました',
              style: Theme.of(context).textTheme.headline6,
            ),

            Text(sec.toString() + infomsg),

            //Divider(),
            // Indeterminate
            //CircularProgressIndicator(),
            RaisedButton(
              child: Text('homeに戻る'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(widget.auth)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
