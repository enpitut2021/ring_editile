// import 'dart:html';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
//import 'package:html_unescape/html_unescape_small.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:html_unescape/html_unescape.dart';


class ChatDemo extends StatefulWidget{
  ChatDemo(this.roomId,this.auth);
  String roomId;
  Auth auth;
  
  @override
  State<StatefulWidget> createState() => _ChatDemo();
  

}

class _ChatDemo extends State<ChatDemo>{
  String _roomId;
  // ignore: non_constant_identifier_names
  List<Text> messages_log = [
    
  ];
  
  @override
  void initState(){
    //super.initState();
    ChatAPI chatapi = new ChatAPI(widget.auth.getBearer());
    
    _roomId=widget.roomId;
    print("roomId:$_roomId");
    chatapi.getChatMessages(_roomId, 1).then((response){
      print(response);
      List<Message> msgL=response.messageList;
      setState(() {
        
        msgL.forEach((message) { 
          String text = HtmlUnescape().convert(message.text);
          messages_log.add(Text(text));
          print(message.text);
        });
      });
    });

  }
  
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
      ),
      body: Container(
        width:double.infinity,
        child:ListView.builder(
          itemCount:  messages_log.length,
          itemBuilder: (BuildContext context,int index){
            return messages_log[index];
          })
        
      ),
    );
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
