import 'package:flutter/material.dart';
import 'package:ring_sns/api/auth.dart';

class Match extends StatefulWidget {
  // Match({Key? key}) : super(key: key);
  Match(this.auth);
  Auth auth;
  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  @override
  void initState() {
    print("ok");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("マッチング中です"),
    );
  }
}
