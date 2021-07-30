import 'package:flutter/material.dart';
import 'chat.dart';
import 'package:ring_sns/api/auth.dart';

class Home extends StatefulWidget {
  Home(this.auth);
  Auth auth;
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Chat',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //ここにイニシャライザを書く

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
                  MaterialPageRoute(
                      builder: (context) => NextPage(privateID, auth)),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan[400],
        onTap: _onItemTapped,
      ),
    );
  }
}
