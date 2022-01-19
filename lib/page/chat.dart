// import 'dart:html';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
//import 'package:html_unescape/html_unescape_small.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:speech_bubble/speech_bubble.dart';
import 'package:ring_sns/page/chathistory.dart';
import 'package:ring_sns/page/postList.dart';
import 'package:universal_platform/universal_platform.dart';
import 'dart:async';

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
  List<String> chatUUID = [];
  var current_count;
  String owner_id;
  int _isInitialized = 0;
  ChatAPI chatapi;

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
    chatapi = new ChatAPI(widget.auth.getBearer());
    _roomId = widget.roomId;
    _manager = SocketIOManager();

    print("roomId:$_roomId");
    chatapi.getRoomInfo(_roomId).then((response) {
      current_count = response.count;
      owner_id = response.ownerId;
      print("owner_id:" + owner_id);
      //print("warning");
      print("current_num:$current_count");
    });

    _reloadChat();

    if (UniversalPlatform.isWeb) {
      Timer.periodic(
        Duration(seconds: 5),
        _reloadChatTimer,
      );
    } else {
      _initSocket(_roomId, widget.auth.getBearer());
    }
  }

  void _adder(Widget data) {
    if (_isInitialized == 0) {
      messages_log.add(data);
    } else {
      messages_log.insert(0,data);
    }
  }

  void _initSocket(String roomId, String userSession) async {
    print("接続中: $roomId");
    SocketIO socket = await _manager
        .createInstance(SocketOptions('https://chat-editile.p0x0q.com:2053',
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
      // ChatRoomInfo chatroom = ChatRoomInfo({
      //   'owner_id': data[0]['owner_id'],
      // });

      // MessageWidget messageWidget =
      //     MessageWidget(message, widget.auth.getUserId(), widget.auth);
      String t = HtmlUnescape().convert(message.text);
      setState(() => {
            if (message.userId == widget.auth.getUserId())
              {
                _adder(Column(
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
                    ]))
              }
            else if (message.userId == owner_id)
              {
                print("ok"),
                _adder(Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SpeechBubble(
                          nipLocation: NipLocation.BOTTOM_LEFT,
                          color: Colors.orange[400],
                          child: Text(
                            "\r\n${message.userId}:\r\n" + t,
                            // style: TextStyle(color: Colors.green),
                            textAlign: TextAlign.left,
                          )),
                      Text(''),
                    ]))
              }
            else
              {
                _adder(Column(
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

  void _reloadChatTimer(Timer timer) {
    _reloadChat();
  }

  Future<void> _reloadChat() async {
    chatapi.getChatMessages(_roomId, 1).then((response) {
      //print(response);
      List<Message> msgL = response.messageList;
      msgL.forEach((message) {
        if (chatUUID.indexOf(message.uuid) == -1) {
          chatUUID.add(message.uuid);

          String text = HtmlUnescape().convert(message.text);

          if (message.userId == widget.auth.getUserId()) {
            _adder(
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
            ]));
          } else if (message.userId == owner_id) {
            print("ok");
            _adder(
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SpeechBubble(
                  nipLocation: NipLocation.BOTTOM_LEFT,
                  color: Colors.orange[400],
                  child: Text(
                    "\r\n${message.userId}:\r\n" + text,
                    // style: TextStyle(color: Colors.green),
                    textAlign: TextAlign.left,
                  )),
              Text(''),
            ]));
          } else {
            _adder(
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
            ]));
          }
          setState(() {});
        }
      });
      _isInitialized = 1;
    });
  }

  Future<void> _submitMessage(String text) async {
    if (text == '') return;
    if (!UniversalPlatform.isWeb) {
      _sockets[_roomId].emit('send', [
        {'value': text}
      ]);
    } else {
      chatapi.postLegacyChat(_roomId, text).then((res) => {_reloadChat()});
    }
  }

  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => postList(widget.auth)),
                );
              },
              icon: Icon(Icons.west)),
          title: Text("チャット"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 500,
              width: 400,
              child: ListView.builder(
                reverse: true,
                itemCount: messages_log.length,
                itemBuilder: (BuildContext context, int index) {
                  return messages_log[index];
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white60,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        side: BorderSide(color: Colors.black26)),
                    onPressed: () {
                      setState(() {
                        chatupdate("オススメなに？", widget.auth.getUserId());
                      });
                    },
                    child: Text("オススメなに？",
                        style: TextStyle(color: Colors.black45)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white60,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        side: BorderSide(color: Colors.black26)),
                    onPressed: () {
                      setState(() {
                        chatupdate("混んでました？", widget.auth.getUserId());
                      });
                    },
                    child: Text("混んでました？",
                        style: TextStyle(color: Colors.black45)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white60,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        side: BorderSide(color: Colors.black26)),
                    onPressed: () {
                      setState(() {
                        chatupdate("いつまで？", widget.auth.getUserId());
                      });
                    },
                    child:
                        Text("いつまで？", style: TextStyle(color: Colors.black45)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white60,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        side: BorderSide(color: Colors.black26)),
                    onPressed: () {
                      setState(() {
                        chatupdate("予算どのくらいですか？", widget.auth.getUserId());
                      });
                    },
                    child: Text("予算どのくらいですか？",
                        style: TextStyle(color: Colors.black45)),
                  ),
                ],
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
                  icon: Icon(Icons.arrow_right, size: 40),
                )
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
