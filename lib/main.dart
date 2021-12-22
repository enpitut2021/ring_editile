import 'package:flutter/material.dart';
import 'package:ring_sns/page/regist.dart';
import 'package:ring_sns/page/login.dart';
import 'package:ring_sns/page/postList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/postStore.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:ring_sns/page/usersetting.dart';
import 'package:ring_sns/page/match-old.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final Auth auth = new Auth();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    print("mainを初期化します。");
    super.initState();
    //非同期処理(async await)はこうやって書くことで，関数の返戻値successを取得できる。
    auth.autoLogin().then((success) {
      setState(() {
        authStatus = auth.getAuthStatus();
        print('Auth Status: ${authStatus.toString()}');
      });
      // // print(authStatus.toString());
      // if (authStatus == AuthStatus.LOGGED_IN) {
      //   print("ログイン成功");

      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => postList(auth)),
      //   );
      // } else {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => LoginPage(auth)),
      //   );
      //   print("ログイン失敗");
      // }
    });
  }

  Future<void> getAutoLoginData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var myStringData = prefs.getString("userId");
    var myStringData2 = prefs.getString("password");
    print(myStringData);
    print(myStringData2);
  }

  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginPage(auth);
        break;
      case AuthStatus.LOGGED_IN:
        // return MainTabView(onLogout: onLogout, auth: widget.auth);
        return postList(auth);
        break;
      default:
        return buildWaitingScreen();
    }
  }

  Widget buildWaitingScreen() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Image.asset('assets/icon/ring-icon-color.png',
          height: 150, width: 150),
    );
  }
}
