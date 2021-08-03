import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/accountAPI.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class Auth extends API {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  User _user;

  AuthStatus getAuthStatus() => authStatus;

  User getUser() => _user;

  String getHobby() => _user.hobby;

  String getNickname() => _user.nickname;

  String getUserId() => _user.userId;

  String getDescription() => _user.profileText;

  String getUserBackgroundURL() =>
      'https://restapi-enpit.p0x0q.com/api/images/user/background/user/${_user.user.toString()}/show?i';
  String getUserIdBackgroundURL(String target_userid) =>
      'https://restapi-enpit.p0x0q.com/api/images/user/background/userid/${target_userid}/show?i';

  Widget getUserIcon({Widget child}) {
    return _user.icon(child);
  }

  Future<bool> autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userId') || !prefs.containsKey('password')) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return false;
    }
    await signIn(prefs.getString('userId'), prefs.getString('password'));
    if (bearer != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<LoginErrorMessage> signIn(String userId, String password) async {
    bearer = await getTokenWithLogin(userId, password);
    String errorMessage = '';

    if (bearer != null) {
      authStatus = AuthStatus.LOGGED_IN;
      _user = await getCurrentUser();
    } else {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      errorMessage = 'ユーザーIDまたはパスワードが間違っています';
    }

    return LoginErrorMessage(
      userId: '',
      password: errorMessage,
    );
  }

  void signOut() {
    print('SIGN OUT');
    authStatus = AuthStatus.NOT_LOGGED_IN;
  }

  Future<String> getToken() async {
    String url = 'tokens/register/create';
    dynamic response = await getRequest(url);
    return response['token'];
  }

  Future<LoginErrorMessage> signUp(String userId, String password) async {
    String token = await getToken();
    String url = 'user/create';
    Map<String, dynamic> queryParameters = {
      'userid': userId,
      'password': password,
      'verify': token,
    };
    dynamic response = await postRequest(url, queryParameters);

    if (response != null)
      authStatus = AuthStatus.LOGGED_IN;
    else
      authStatus = AuthStatus.NOT_LOGGED_IN;

    dynamic errors = response['errors'];
    if (errors == null)
      return LoginErrorMessage(
        userId: 'ok',
        password: 'ok',
      );
    List<dynamic> userIdError = errors['userid'] ?? [''];
    List<dynamic> passwordError = errors['password'] ?? [''];
    return LoginErrorMessage(
      userId: userIdError[0].toString(),
      password: passwordError[0].toString(),
    );
  }

  Future<String> getTokenWithLogin(String userId, String password) async {
    String url = 'tokens/login/create';

    Map<String, String> params = {
      'userid': userId,
      'password': password,
    };

    dynamic response = await getRequest(url, params);
    return response['token'];
  }

  Future<User> getCurrentUser() async {
    String url = 'userprofile';
    dynamic userdata = await getRequest(url);
    return User(userdata);
  }
}

class LoginErrorMessage {
  String userId = '';
  String password = '';

  LoginErrorMessage({this.userId, this.password});
}
