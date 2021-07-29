// import 'dart:html';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/api/auth.dart';

class ChatDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatDemo();
}

class _ChatDemo extends State<ChatDemo> {
  ChatAPI chatapi;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    // final _channel = WebSocket(url)
  }
}

class NextPage extends StatelessWidget {
  // ここにイニシャライザを書く
  NextPage(this.name, this.auth);
  String name;
  Auth auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
      ),
      body: Center(
        child: Text("Receive Message: "+ name + "\r\nLogin NickName: " + auth.getNickname()),
      ),
    );
  }
}
