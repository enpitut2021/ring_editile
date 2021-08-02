import 'package:flutter/material.dart';
import 'package:ring_sns/api/accountAPI.dart';
import 'package:ring_sns/main.dart';
import 'package:ring_sns/page/chathistory.dart';
import 'chat.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ring_sns/page/mattinngmaker.dart';
import 'package:ring_sns/page/usersetting.dart';

class Home extends StatefulWidget {
  Home(this.auth);
  Auth auth;
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  void deletePassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    prefs.remove("password");
  }

  int _selectedIndex = 0;

  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
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

  @override
  void initState() {
    print("ok");
    print("user_session:${widget.auth.getBearer()}");
  }

  @override
  String privateID = "";

  

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム"),
      ),
      body: Center(
        //width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(""),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 250, height: 100),
                 child:ElevatedButton(
              child: Text('マッチングを開始します'),
              style: ElevatedButton.styleFrom(
                
                primary: Colors.white,
                onPrimary: Colors.green,
                shape: const StadiumBorder(),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MattingPage(widget.auth)),
                );
              }
              ),
            ),
            
            
            
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  widget.auth.getUserBackgroundURL()),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 250, height: 50),
              child:
              ElevatedButton(
              child: Text('プロフィールを編集します'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: const StadiumBorder(),
              ),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Usersetting(widget.auth)),
                );
              }
              ),
            ),
                
              ],),
              Text(""),
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: 'Enter a search ID',
            //   ),
            //   onChanged: (text) {
            //     // text = privateID;
            //     privateID = text;
            //     print(privateID);
            //   },
            // ),
            // RaisedButton(
            //   child: Text('ID情報渡す'),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ChatDemo(privateID, widget.auth)),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.verified_user),
            //   title: Text('マッチングを開始する'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MattingPage(widget.auth)),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.verified_user),
            //   title: Text('全体交流広場へ'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ChatDemo('public', widget.auth)),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.verified_user),
            //   title: Text('チャット履歴'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ChatHistory(widget.auth)),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue[900],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
            backgroundColor: Colors.blue[900],
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan[400],
        onTap: (int index){
          _selectedIndex=index;
          if(index==0){
      //go to home

    }else if(index==1){
      //go to chatlog
      Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatHistory(widget.auth)),
                );
    }
        },        
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Ring',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setting'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Usersetting(widget.auth)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                deletePassword();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}

