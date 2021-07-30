// import 'dart:html';
// import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
//import 'package:html_unescape/html_unescape_small.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:html_unescape/html_unescape.dart';
// import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'dart:convert';

class ChatDemo extends StatefulWidget {
  ChatDemo(this.roomId, this.auth);
  String roomId;
  Auth auth;

  @override
  State<StatefulWidget> createState() => _ChatDemo();
}

class _ChatDemo extends State<ChatDemo> {
  String _roomId;

  // SocketIOManager _manager;
  Map<String, SocketIO> _sockets = {};

  // ignore: non_constant_identifier_names
  List<Text> messages_log = [];

  @override
  void initState() {
    super.initState();

    ChatAPI chatapi = new ChatAPI(widget.auth.getBearer());

    _roomId = widget.roomId;
    print("roomId:$_roomId");
    chatapi.getChatMessages(_roomId, 1).then((response) {
      print(response);
      List<Message> msgL = response.messageList;
      setState(() {
        msgL.forEach((message) {
          String text = HtmlUnescape().convert(message.text);
          messages_log.add(Text(text));
          print(message.text);
        });
      });
    });
    _initSocket(_roomId, widget.auth.getBearer());
  }

  SocketIO socketIO;

  void _initSocket(String roomId, String userSession) async {
    print("接続中: $roomId");

    print("Bearer: ${widget.auth.getBearer()}");
    socketIO = SocketIOManager().createSocketIO(
        "https://chat2.p0x0q.com:8443", "/",
        query:
            "chatid=${roomId}&user_session=571|NJYSGy11ZN1yTDM6M2J63Z43rYeVLHyRNpLHAqL8",
        socketStatusCallback: _socketStatus);

    //call init socket before doing anything
    socketIO.init();

    //subscribe event
    socketIO.subscribe("response", _onResponse);
    socketIO.subscribe("event", _onEvent);
    socketIO.subscribe("API", _onAPI);
    //connect socket
    socketIO.connect();

    print("CONNECT");
    emit("connected", jsonEncode([]));
    await Future.delayed(Duration(milliseconds: 1000));
    print("SEND!");
    emit(
        'API',
        jsonEncode([
          {"apiid": "ConnectCheck"}
        ]));

    // SocketIO socket = await _manager
    //     .createInstance(SocketOptions('https://chat2.p0x0q.com:8443',
    //         namespace: '/',
    //         query: {
    //           'chatid': roomId,
    //           'user_session': widget.auth.getBearer(),
    //         },
    //         enableLogging: false,
    //         transports: [Transports.webSocket]));
    // socket.onConnect.listen((data) async {
    //   print("接続完了");
    //   connectRoom(socket, roomId);
    //   // socket.emit('connected', []);
    //   // print('[socketIO] connect: $_roomId');
    //   // await Future.delayed(Duration(milliseconds: 500));
    //   // print('[socketIO] emit connected message');
    //   // socket.emit('API', [{'apiid': 'ConnectCheck'}]);
    // });
    // socket.onDisconnect.listen((data) => print('[socketIO] disconnect: $data'));
    // socket.onConnectError.listen((data) => print('[socketIO] connectError: $data'));
    // socket
    //     .onConnectTimeout((data) => print('[socketIO] connectTimeout: $data'));
    // socket.onError((data) => print('[socketIO] error: $data'));
    // socket.on('event', (data) => print('[socketIO] event: $data'));
    // socket.on('response', (data) {
    //   print('[socketIO] responce: $data');
    //   if (!mounted) return;
    //   Message message = Message({
    //     'chatid': 0,
    //     'uuid': data['uuid'],
    //     'roomid': _roomId,
    //     'userid': data['userid'],
    //     'nickname': data['nickname'],
    //     'text': data['text'],
    //     'goodsUsers': data['good'],
    //     'created': data['time'],
    //   });
    //   // MessageWidget messageWidget =
    //   //     MessageWidget(message, widget.auth.getUserId(), widget.auth);
    //   // setState(() => _messageWidgetList.insert(0, messageWidget));
    // });
    // socket.on('API', (data) {
    //   print('[socketIO] API: $data');
    //   if (data['apiid'] == 'RoomCheck' && !data['res']) {
    //     connectRoom(socket, roomId);
    //   }
    // });
    // socket.on('destroy', (data) => print('[socketIO] destroy: $data'));

    // socket.connect();
    // _sockets[roomId] = socket;
  }

  _onSocketInfo(dynamic data) {
    print("Socket info: " + data);
  }

  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }

  _onEvent(dynamic data) {
    print('[socketIO] event: $data');
  }

  _onAPI(dynamic data) async {
    print('[onAPI] event: $data');

    if (data['apiid'] == 'RoomCheck' && !data['res']) {
      emit("connected", jsonEncode([]));
      await Future.delayed(Duration(milliseconds: 500));
      emit(
          'API',
          jsonEncode([
            {"apiid": "ConnectCheck"}
          ]));
    }
  }

  _onResponse(dynamic data) {
    print("receive!!");
    // print(data["text"]);
    // Message message = Message({
    //   'chatid': 0,
    //   'uuid': data['uuid'],
    //   'roomid': _roomId,
    //   'userid': data['userid'],
    //   'nickname': data['nickname'],
    //   'text': data['text'],
    //   'goodsUsers': data['good'],
    //   'created': data['time'],
    // });
  }

  // _subscribes() {
  //   if (socketIO != null) {
  //     socketIO.subscribe("chat_direct", _onReceiveChatMessage);
  //   }
  // }

  // _unSubscribes() {
  //   if (socketIO != null) {
  //     socketIO.unSubscribe("chat_direct", _onReceiveChatMessage);
  //   }
  // }

  // _reconnectSocket() {
  //   if (socketIO == null) {
  //     _connectSocket01();
  //   } else {
  //     socketIO.connect();
  //   }
  // }

  // _disconnectSocket() {
  //   if (socketIO != null) {
  //     socketIO.disconnect();
  //   }
  // }

  // _destroySocket() {
  //   if (socketIO != null) {
  //     SocketIOManager().destroySocket(socketIO);
  //   }
  // }

  void emit(String event, String message) async {
    if (socketIO != null) {
      // String jsonData =
      //     '{"message":{"type":"Text","content": ${(msg != null && msg.isNotEmpty) ? '"${msg}"' : '"Hello SOCKET IO PLUGIN :))"'},"owner":"589f10b9bbcd694aa570988d","avatar":"img/avatar-default.png"},"sender":{"userId":"589f10b9bbcd694aa570988d","first":"Ha","last":"Test 2","location":{"lat":10.792273999999999,"long":106.6430356,"accuracy":38,"regionId":null,"vendor":"gps","verticalAccuracy":null},"name":"Ha Test 2"},"receivers":["587e1147744c6260e2d3a4af"],"conversationId":"589f116612aa254aa4fef79f","name":null,"isAnonymous":null}';
      // String json = jsonEncode(message);
      socketIO.sendMessage(event, message, _onReceiveChatMessage);
    }
  }

  void socketInfo(dynamic message) {
    print("Socket Info: " + message);
  }

  void _onReceiveChatMessage(dynamic message) {
    print("Message from UFO: " + message);
  }

  // void connectRoom(SocketIO socket, String roomId) async {
  //   socket.emit('connected', []);
  //   print('[socketIO] connect: $roomId');
  //   await Future.delayed(Duration(milliseconds: 500));
  //   print('[socketIO] emit connected message');
  //   socket.emit('API', [
  //     {'apiid': 'ConnectCheck'}
  //   ]);
  // }

  // Future<void> _submitMessages(String text) async {
  //   if (text == '') return;
  //   _sockets[_roomId].emit('send', [
  //     {'value': text}
  //   ]);
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
      ),
      body: Container(
          width: double.infinity,
          child: ListView.builder(
              itemCount: messages_log.length,
              itemBuilder: (BuildContext context, int index) {
                return messages_log[index];
              })),
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
        child: Text("Receive Message: " +
            name +
            "\r\nLogin NickName: " +
            auth.getNickname()),
      ),
    );
  }
}
