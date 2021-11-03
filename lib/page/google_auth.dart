import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';//Firebaseでログインするのに必要
import 'package:google_sign_in/google_sign_in.dart';//このパッケージを使うと簡単にGoogle認証を実装できる
import 'package:flutter_signin_button/flutter_signin_button.dart';//Googleのロゴのついたボタン(これはなくてもよい)


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("ログインしてください"),
            const SizedBox(
              height: 16,
            ),
            SignInButton(
              Buttons.Google,
              text: 'Sign up with Google',
              onPressed: () async {
                await login(); //下にあるFuture login() ・・・を呼び出す
		//ここにログイン後の処理
		//ex)ホーム画面に画面遷移、dialog表示など
              },
            ),
          ],
        ),
      ),
    );
  }

  Future login() async {
    GoogleSignInAccount? signInAccount = await googleLogin.signIn();
    if (signInAccount == null) return;

    GoogleSignInAuthentication auth = await signInAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    final result = await _auth.signInWithCredential(credential);
    
    //下記はコンソルに表示される(書かなくてもよい)
    print(result.user!.uid.toString());//uid
    print(result.user!.email.toString());//メールアドレス
    print(result.user!.displayName.toString());//アカウント名
    
  }
}
