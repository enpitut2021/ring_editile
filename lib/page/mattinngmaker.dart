import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/api/chatAPI.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/rendering.dart';
import 'package:ring_sns/page/matching_failed.dart';
import 'package:ring_sns/page/matching_result.dart';
import 'package:ring_sns/api/accountAPI.dart';

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
  int sec = 10;
  SocketIOManager _manager;
  Map<String, SocketIO> _sockets = {};
  bool match_res = false;
  bool cancel = false;

  // ignore: non_constant_identifier_names
  List<Text> messages_log = [];
  var current_count;

  @override
  void initState() {
    _manager = SocketIOManager();
    _initSocket(_roomId, widget.auth.getBearer());
    failed();
  }

  void success_navigator() {
    setState(() {
      match_res = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Match_Result(widget.auth, "public", "admin")),
    );
  }

  void failed() async {
    while (!match_res && sec > 0) {
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        sec -= 1;
      });
    }
    if (!match_res && !cancel) {
      print("matching failed");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Match_Failed(widget.auth)),
      );
    }
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

    socket.on('match').listen((data) async {
      // print("マッチングしました！");
      print('[socketIO] responce: ${data[0]}');

      String targetUserid = data[0]["userids"][0].toString();
      if (widget.auth.getUserId() == targetUserid) {
        targetUserid = data[0]["userids"][1].toString();
      }
      print("相手ユーザーは${targetUserid}です");
      ChatAPI chatapi = new ChatAPI(widget.auth.getBearer());
      AccountAPI account = new AccountAPI(widget.auth.getBearer());

      await account.friendRequest(targetUserid);
      await Future.delayed(Duration(milliseconds: 3000));

      List<dynamic> response = await account.getFriendRequestList();
      print("リクエストしました");
      print(response.runtimeType);
      response.forEach((friendRequest) {
        print(friendRequest['send_userid']);
        account.acceptFriendRequest(friendRequest['send_userid'], true);
      });

      await Future.delayed(Duration(milliseconds: 3000));

      String roomid = await chatapi.getRoomIdFriendChat(targetUserid);
      print("相手ユーザーとのRoomIDは${roomid}です");
      if(roomid == null){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Match_Failed(widget.auth)),
      );
      }else{
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Match_Result(widget.auth, roomid, targetUserid)),
      );
      }

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
              backgroundImage: NetworkImage(widget.auth.getUserBackgroundURL()),
              radius: 100,
            ),
            Text(
              'マッチング相手を探しています',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(sec.toString()),
            CircularProgressIndicator(
              value: _value,
            ),
            Divider(),
            // Indeterminate
            CircularProgressIndicator(),
            RaisedButton(
              child: Text('マッチングをやめる'),
              onPressed: () {
                cancel = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(widget.auth)),
                );
              },
            ),
            RaisedButton(
              child: Text('マッチングが成功した'),
              onPressed: () {
                success_navigator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
