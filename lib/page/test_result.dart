import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/test.dart';
import 'package:ring_sns/api/accountAPI.dart';

class test_result extends StatefulWidget {
  test_result(this.auth);
  Auth auth;
  

  @override
  State<StatefulWidget> createState() => _testresult();
}

class _testresult extends State<test_result> {
  List<Widget> post_test = [];
  Color _iconcolor = Colors.black;
  bool Press = false;

  @override
  void initState() {
    print("data");
    print(widget.auth.getBearer());
    AccountAPI a = new AccountAPI(widget.auth.getBearer());
    a.getUserPostList().then((posts) {
      posts.forEach((Post post) {
          post_test.add(
          Column(children: [
            Row(
              children: [
                Text(post.updated + ": " + post.text),
              ]
            ),
          ],));
      });
      setState(() {
              
            });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => test(widget.auth)),
              );
            },
            icon: Icon(Icons.west)),
        title: Text("投稿一覧画面"),
        automaticallyImplyLeading: false,
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
            itemCount: post_test.length,
            itemBuilder: (BuildContext context, int index) {
              return post_test[index];
            },
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
    );
  }
}
