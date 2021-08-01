import 'package:flutter/material.dart';
//import 'package:html_unescape/html_unescape_small.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

class ChatHistory extends StatefulWidget{
  ChatHistory (this.auth);
  Auth auth;
  @override
  State<StatefulWidget> createState() => _ChatHistory();

}

class _ChatHistory extends State<ChatHistory>{
  @override
  List<Text>  chathis=[
    
  ];

  void chathistory_update(String chatoom_id){
    setState(() {
      chathis.add(Text(chatoom_id));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("チャット"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 600,
              width: double.infinity,
              child: ListView.builder(
                itemCount: chathis.length,
                itemBuilder: (BuildContext context, int index) {
                  return chathis[index];
                },
              ),
            ),
            Row(
              children: [
                RaisedButton(onPressed: (){
                  chathistory_update("new_room");
                })
               
                
              ],
            )
          ],
        ));
  }
  
}