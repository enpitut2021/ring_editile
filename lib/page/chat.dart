// import 'dart:html';
// import 'package:flutter/foundation.dart';


import 'package:flutter/material.dart';
import 'package:ring_sns/api/chatAPI.dart';

class ChatDemo extends StatefulWidget{
  ChatDemo(this.roomId);
  String roomId;
  
  @override
  State<StatefulWidget> createState() => _ChatDemo();
  

}

class _ChatDemo extends State<ChatDemo>{
  String _roomId;
  List<Text> messages_log = [
    
  ];
  
  @override
  void initState(){
    //super.initState();
    ChatAPI chatapi = new ChatAPI("571|NJYSGy11ZN1yTDM6M2J63Z43rYeVLHyRNpLHAqL8");
    _roomId=widget.roomId;
    chatapi.getChatMessages(_roomId, 1).then((response){
      List<Message>msg=response.messageList;
      setState(() {
        
        msg.forEach((message) { 
          messages_log.add(Text(message.text));
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
  NextPage(this.name);
  String name;
  ChatAPI chatapi = new ChatAPI("571|NJYSGy11ZN1yTDM6M2J63Z43rYeVLHyRNpLHAqL8");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
      ),
      body: Container(
        width:double.infinity,
        
      ),
    );
  }
}
