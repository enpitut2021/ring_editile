import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  // ここにイニシャライザを書く
  NextPage(this.name);
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット"),
      ),
      body: Center(
        child: Text(name),
      ),
    );
  }
}
