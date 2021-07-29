import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login page'),
      ),
      body: Container(
        width: double.infinity,
        child: TextField(
            decoration: InputDecoration(
          border: InputBorder.none,
        )),
      ),
    );
  }
}
