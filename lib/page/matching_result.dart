import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:ring_sns/api/auth.dart';
import 'package:flutter/material.dart';
import 'package:ring_sns/page/chat.dart';
import 'package:ring_sns/page/home.dart';
import 'package:flutter/rendering.dart';

class Match_Result extends StatefulWidget{
  Match_Result(this.auth);
  Auth auth;


  @override
  State<StatefulWidget> createState() => _Match_Result();
  
}

class _Match_Result extends State<Match_Result>{
  int sec=5;
  String infomsg = "秒後チャットルームに入ります";
  //bool match_res=false;

  void initState(){
    nextpage();
  }

  void nextpage() async{
    while(sec>0){
      await Future.delayed(Duration(milliseconds: 1000));
      setState(() {
        sec -= 1;
      });
    }
    
    print("matching success");
      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatDemo("public",widget.auth)),
                );
  }

  @override
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
              'OOさんとマッチングしました',
              style: Theme.of(context).textTheme.headline6,
            ),

            Text(sec.toString()+infomsg),
            
            //Divider(),
            // Indeterminate
            //CircularProgressIndicator(),
            RaisedButton(
              child: Text('homeに戻る'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home(widget.auth)),
                );
              },
            ),
            
            
           
          ],
        ),
      ),
    );
    
  }
  
}
  