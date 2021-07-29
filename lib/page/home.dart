import 'package:flutter/material.dart';
import 'chat.dart';

class Home extends StatelessWidget {
  @override
  String privateID = "";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter a search ID',
              ),
              onChanged: (text) {
                // text = privateID;
                privateID = text;
              },
            ),
            RaisedButton(
              child: Text('ID情報渡す'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage(privateID)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
