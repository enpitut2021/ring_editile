import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/rendering.dart';

class MattingPage extends StatefulWidget {
  //ここにイニシャライザを追加する
  @override
  State<StatefulWidget> createState() => _MattingPage();
}

class _MattingPage extends State<MattingPage> {
  @override
  final Auth auth = new Auth();
  var _value = 0.0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://user-imgs.p0x0q.com/thumbnail/user/1.jpg'),
              radius: 100,
            ),
            Text(
              'マッチング相手を探しています',
              style: Theme.of(context).textTheme.headline6,
            ),
            CircularProgressIndicator(
              value: _value,
            ),
            Divider(),
            // Indeterminate
            CircularProgressIndicator(),
            RaisedButton(
              child: Text('マッチングをやめる'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(auth)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
