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
  var current_count;
  ChatAPI nChatapi;

  void chatupdate(String msg,String uid){
    
    setState(() {
        if(uid==widget.auth.getUserId()){
            messages_log.insert(0,Text("\r\n${uid}:\r\n"+msg,style: TextStyle(color: Colors.green),textAlign: TextAlign.right,));
          }else{
          messages_log.insert(0,Text("\r\n${uid}:\r\n"+msg,style: TextStyle(color: Colors.blue),textAlign: TextAlign.left,));
          }
      }

    );}
  
  @override
  void initState(){
    //super.initState();
    ChatAPI chatapi = new ChatAPI('571|NJYSGy11ZN1yTDM6M2J63Z43rYeVLHyRNpLHAqL8');
    
    
    _roomId=widget.roomId;
    print("roomId:$_roomId");
    chatapi.getRoomInfo(_roomId).then((response){
       current_count=response.count;
       //print("warning");
       print("current_num:$current_count");
     });
    chatapi.getChatMessages(_roomId, 1).then((response){
      //print(response);
      List<Message> msgL=response.messageList;
      setState(() {
        
        msgL.forEach((message) { 
          String text = HtmlUnescape().convert(message.text);
          
          if(message.userId==widget.auth.getUserId()){
            messages_log.add(Text("\r\n${message.userId}:\r\n"+text,style: TextStyle(color: Colors.green),textAlign: TextAlign.right,));
          }else{
          messages_log.add(Text("\r\n${message.userId}:\r\n"+text,style: TextStyle(color: Colors.blue),textAlign: TextAlign.left,));
          }
          //print(message.text);
        });
      });
    });

  }
  
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
        
      ),
      floatingActionButton: 
      FloatingActionButton(
        onPressed: (){
          chatupdate("test", "chatdemo2");
          print("update roomID:$_roomId");
        },
        child: Icon(Icons.add)
      ),
      
      body: Container(
        width:double.infinity,
        child:ListView.builder(
          itemCount:  messages_log.length,
          itemBuilder: (BuildContext context,int index){
            return messages_log[index];
          },
          )
        
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
