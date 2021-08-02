import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/rendering.dart';
import 'package:ring_sns/page/matching_result.dart';


class MattingPage extends StatefulWidget {
  //ここにイニシャライザを追加1する
  MattingPage(this.auth);
  Auth auth;
  @override
  State<StatefulWidget> createState() => _MattingPage();
}

class _MattingPage extends State<MattingPage> {
  String _roomId = "public";
  String input_msg = "";

  SocketIOManager _manager;
  Map<String, SocketIO> _sockets = {};

  // ignore: non_constant_identifier_names
  List<Text> messages_log = [];
  var current_count;

  @override
  void initState() {
    _manager = SocketIOManager();
    _initSocket(_roomId, widget.auth.getBearer());
  }

  void _initSocket(String roomId, String userSession) async {
    print("接続中: $roomId");
    SocketIO socket = await _manager
        .createInstance(SocketOptions('https://restapi-enpit.p0x0q.com:2096',
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

    socket.on('response').listen((data) {
      print('[socketIO] responce: $data');
      if (!mounted) return;
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

  @override
  //final Auth auth = new Auth();
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
                  MaterialPageRoute(builder: (context) => Home(widget.auth)),
                );
              },
            ),
            RaisedButton(
              child: Text('マッチングが成功した'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Match_Result(widget.auth)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
