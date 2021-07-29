import 'dart:html';
import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:ring_sns/api/chatAPI.dart';

class ChatDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ChatDemo();

}

class _ChatDemo extends State<ChatDemo>{
  ChatAPI chatapi;
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    // final _channel = WebSocket(url)
  }

}

class NextPage extends StatelessWidget {
  // ここにイニシャライザを書く
  NextPage(this.name);
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
      ),
      body: Center(
        child: Text(name),
      ),
    );
  }
}
