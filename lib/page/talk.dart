import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  // ここにイニシャライザを書く
  NextPage(this.name);
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("トーク"),
      ),
      body: Center(
        child: Text("トーク"),
        child: Text(name),
      ),
    );
  }
}
