// import 'dart:html';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
//import 'package:html_unescape/html_unescape_small.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:speech_bubble/speech_bubble.dart';

class ChatDemo extends StatefulWidget {
  ChatDemo(this.roomId, this.auth);
  String roomId;
  Auth auth;

  @override
  State<StatefulWidget> createState() => _ChatDemo();
}

class _ChatDemo extends State<ChatDemo> {
  String _roomId;
  String input_msg = "";

  SocketIOManager _manager;
  Map<String, SocketIO> _sockets = {};

  // ignore: non_constant_identifier_names
  List<Widget> messages_log = [];
  var current_count;
  ChatAPI nChatapi;

  void chatupdate(String msg, String uid) {
    _submitMessage(msg);
    // setState(() {
    //     if(uid==widget.auth.getUserId()){
    //         messages_log.add(Text("\r\n${uid}:\r\n"+msg,style: TextStyle(color: Colors.green),textAlign: TextAlign.right,));
    //       }else{
    //       messages_log.add(Text("\r\n${uid}:\r\n"+msg,style: TextStyle(color: Colors.blue),textAlign: TextAlign.left,));
    //       }
    //   }
    // );
  }

  @override
  void initState() {
    //super.initState();
    ChatAPI chatapi = new ChatAPI(widget.auth.getBearer());
    _roomId = widget.roomId;
    _manager = SocketIOManager();
    print("roomId:$_roomId");
    chatapi.getRoomInfo(_roomId).then((response) {
      current_count = response.count;
      //print("warning");
      print("current_num:$current_count");
    });
    chatapi.getChatMessages(_roomId, 1).then((response) {
      //print(response);
      List<Message> msgL = response.messageList;
      setState(() {
        msgL.forEach((message) {
          String text = HtmlUnescape().convert(message.text);
          if (message.userId == widget.auth.getUserId()) {
            messages_log.insert(
                0,
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  SpeechBubble(
                      nipLocation: NipLocation.BOTTOM_RIGHT,
                      color: Colors.green,
                      child: Text(
                        "\r\n${message.userId}:\r\n" + text,
                        // style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.right,
                      )),
                  Text(''),
                ])
                //  Text(
                //   "\r\n${message.userId}:\r\n" + text,
                //   style: TextStyle(color: Colors.green),

                //   textAlign: TextAlign.right,
                // )
                );
          } else {
            messages_log.insert(
                0,
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SpeechBubble(
                      nipLocation: NipLocation.BOTTOM_LEFT,
                      color: Colors.blueGrey[200],
                      child: Text(
                        "\r\n${message.userId}:\r\n" + text,
                        // style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.left,
                      )),
                  Text(''),
                ])
                //  Text(
                //   "\r\n${message.userId}:\r\n" + text,
                //   style: TextStyle(color: Colors.green),

                //   textAlign: TextAlign.right,
                // )
                );
            // SpeechBubble(
            //   "\r\n${message.userId}:\r\n" + text,
            //   style: TextStyle(color: Colors.blue),
            //   textAlign: TextAlign.left,
            // ));
          }
        });
      });
    });
    _initSocket(_roomId, widget.auth.getBearer());
  }

  void _initSocket(String roomId, String userSession) async {
    print("接続中: $roomId");
    SocketIO socket = await _manager
        .createInstance(SocketOptions('https://restapi-enpit.p0x0q.com:2053',
            namespace: '/',
            query: {
              'chatid': roomId,
              'user_session': widget.auth.getBearer(),
            },
            enableLogging: false,
            transports: [Transports.webSocket]));
    socket.onConnect.listen((data) async {
      print("接続完了");
      connectRoom(socket, roomId);
      // socket.emit('connected', []);
      // print('[socketIO] connect: $_roomId');
      // await Future.delayed(Duration(milliseconds: 500));
      // print('[socketIO] emit connected message');
      // socket.emit('API', [{'apiid': 'ConnectCheck'}]);
    });
    socket.onDisconnect.listen((data) => print('[socketIO] disconnect: $data'));
    socket.onConnectError
        .listen((data) => print('[socketIO] connectError: $data'));
    // socket
    //     .onConnectTimeout((data) => print('[socketIO] connectTimeout: $data'));
    // socket.onError((data) => print('[socketIO] error: $data'));
    // socket.on('event', (data) => print('[socketIO] event: $data'));

    socket.on('res').listen((data) {
      print('[socketIO] res: $data');
    });

    socket.on('response').listen((data) {
      print('[socketIO] responce: $data');
      if (!mounted) return;
      Message message = Message({
        'chatid': 0,
        'uuid': data[0]['uuid'],
        'roomid': _roomId,
        'userid': data[0]['userid'],
        'nickname': data[0]['nickname'],
        'text': data[0]['text'],
        'goodsUsers': data[0]['good'],
        'created': data[0]['time'],
      });
      // MessageWidget messageWidget =
      //     MessageWidget(message, widget.auth.getUserId(), widget.auth);
      String t = HtmlUnescape().convert(message.text);
      setState(() => {
            if (message.userId == widget.auth.getUserId())
              {
                messages_log.add(Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      SpeechBubble(
                          nipLocation: NipLocation.BOTTOM_RIGHT,
                          color: Colors.green,
                          child: Text(
                            "\r\n${message.userId}:\r\n" + t,
                            // style: TextStyle(color: Colors.green),
                            textAlign: TextAlign.right,
                          )),
                      Text(''),
                    ])
                    //  Text(
                    //   "\r\n${message.userId}:\r\n" + text,
                    //   style: TextStyle(color: Colors.green),

                    //   textAlign: TextAlign.right,
                    // )
                    // Text(
                    //   "\r\n${message.userId}:\r\n" + t,
                    //   style: TextStyle(color: Colors.green),
                    //   textAlign: TextAlign.right,
                    // )
                    )
              }
            else
              {
                messages_log.add(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpeechBubble(
                          nipLocation: NipLocation.BOTTOM_LEFT,
                          color: Colors.blueGrey[200],
                          child: Text(
                            "\r\n${message.userId}:\r\n" + t,
                            // style: TextStyle(color: Colors.green),
                            textAlign: TextAlign.left,
                          )),
                      Text(''),
                    ]))
              }
          });
    });
    // socket.onAPI.listen(data) async{
    //   print('[socketIO] API: $data');
    //   if (data['apiid'] == 'RoomCheck' && !data['res']) {
    //     connectRoom(socket, roomId);
    //   }
    // };
    // socket.on('destroy', (data) => print('[socketIO] destroy: $data'));

    socket.connect();
    _sockets[roomId] = socket;
  }

  void connectRoom(SocketIO socket, String roomId) async {
    await Future.delayed(Duration(milliseconds: 500));
    socket.emit('connected', []);
    print('[socketIO] connect: $roomId');
    await Future.delayed(Duration(milliseconds: 500));
    print('[socketIO] emit connected message');
    socket.emit('API', [
      {'apiid': 'ConnectCheck'}
    ]);
  }

  Future<void> _submitMessage(String text) async {
    if (text == '') return;
    _sockets[_roomId].emit('send', [
      {'value': text}
    ]);
  }

  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text("チャット"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 600,
              width: 400,
              child: ListView.builder(
                itemCount: messages_log.length,
                itemBuilder: (BuildContext context, int index) {
                  return messages_log[index];
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: new TextField(
                  controller: textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'メッセージを入力してください',
                  ),
                  // onChanged: (text) {
                  //   input_msg = text;
                  // },
                )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        input_msg = textController.text;
                        if (input_msg != "") {
                          chatupdate(input_msg, widget.auth.getUserId());
                          print(input_msg);
                          input_msg = "";
                        }
                      });
                    },
                    icon: Icon(Icons.add))
              ],
            )
          ],
        ));
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
        child: Text("Receive Message: " +
            name +
            "\r\nLogin NickName: " +
            auth.getNickname()),
      ),
    );
  }
}
