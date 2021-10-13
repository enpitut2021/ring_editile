import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/home.dart';
import 'package:ring_sns/page/test.dart';

class test_result extends StatefulWidget {
  test_result(this.auth, this.name);
  Auth auth;
  String name;

  @override
  State<StatefulWidget> createState() => _testresult();
}

class _testresult extends State<test_result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Text(widget.name)],
        ),
      ),
    );
  }
}
