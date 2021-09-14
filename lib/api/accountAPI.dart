import 'package:dio/dio.dart';
import 'dart:async';
import 'package:http_parser/http_parser.dart';
import 'package:ring_sns/api/API.dart';
import 'package:flutter/material.dart';

class AccountAPI extends API {
  AccountAPI(String bearer) : super(bearer);

  Future<List<Notification>> getNotificationList(
      {bool unreadOnly = false}) async {
    String url = 'notification';
    dynamic response = await getRequest(url);
    List<Notification> notificationList = [];
    response['data'].forEach((notification) {
      notificationList.add(Notification(notification));
    });
    return notificationList;
  }

  Future<int> getNotificationCount() async {
    String url = 'notification/unread_only_count';
    dynamic response = await getRequest(url);
    return int.parse(response);
  }

  Future<void> setAlreadyNotification() async {
    String url = 'notification/notification_set_already';
    putRequest(url);
  }

  Future<List<User>> searchUsers(String query) async {
    String url = 'search/userprofile/$query';
    dynamic response = await getRequest(url);
    List<User> userList = [];
    response['data'].forEach((userdata) {
      userList.add(User(userdata));
    });
    return userList;
  }

  Future<String> uploadUserIcon(String imageFilePath) async {
    String url = 'images/upload/user';
    FormData formData = FormData.fromMap({
      'type_id': 'thumbnail',
      'name': 'image_file',
      'image_file': await MultipartFile.fromFile(imageFilePath,
          contentType: MediaType('multipart', 'form-data')),
    });
    await postImageRequest(url, formData);
    return "ok";
  }

  Future<String> uploadUserHeader(String imageFilePath) async {
    String url = 'images/upload/user';
    FormData formData = FormData.fromMap({
      'type_id': 'background',
      'name': 'image_file',
      'image_file': await MultipartFile.fromFile(imageFilePath,
          contentType: MediaType('multipart', 'form-data')),
    });
    await postImageRequest(url, formData);
    return "ok";
  }

  String list2json(List<String> tags) {
    if (tags == null) return null;
    String tagsJson = '[';
    for (int i = 0; i < tags.length; i++) {
      tagsJson += ''' + tags[i] + ''';
      if (i != tags.length - 1) tagsJson += ',';
    }
    tagsJson += ']';
    return tagsJson;
  }

  Future<dynamic> updateUserProfile(
      {String nickname,
      String password,
      String birthday,
      List<String> tags,
      String profileText,
      String hobby,
      int enableConnectpp,
      int gender}) async {
    String url = 'userprofile';
    Map<String, dynamic> queryParameters = {
      'nickname': nickname,
      'password': password,
      'birthday': birthday,
      'tags': list2json(tags),
      'hobby': hobby,
      'profile_text': profileText,
      'enable_connectpp': enableConnectpp,
      'gender': gender
    };
    dynamic response = await postRequest(url, queryParameters);
    return response;
  }

  Future<void> registPushToken(String token) async {
    String url = 'tokens/push/fcm';
    Map<String, dynamic> queryParameters = {'token': token};
    await postRequest(url, queryParameters);
  }

  Future<void> friendRequest(String userId) async {
    String url = 'friend/manage';
    Map<String, dynamic> queryParameters = {
      'receive_userid': userId,
    };
    await postRequest(url, queryParameters);
  }

  Future<List<String>> getFriendList() async {
    String url = 'friend/manage';
    dynamic response = await getRequest(url);
    List<String> userIdList = [];
    response.forEach((userdata) {
      userIdList.add(userdata['userid']);
    });
    return userIdList;
  }

  Future<List<dynamic>> getFriendRequestList() async {
    String url = 'friend/request/receive';
    dynamic response = await getRequest(url);
    return response;
  }

  //フレンド申請の操作
  //第１引数にユーザーIDではなく，friend_request_idを指定するようにしてください。
  Future<dynamic> acceptFriendRequest(String userId, bool control) async {
    String url = 'friend/manage/' + userId;
    Map<String, dynamic> queryParameters = {
      'control': control ? '1' : '-1',
      'userid': userId, //一時的な対応として，useridを指定したらfriendidに変換するようにしてあります。
    };
    return await putRequest(url, queryParameters);
  }

  Future<User> getUserInfo(String userId) async {
    String url = 'userid/show/$userId';
    dynamic userdata = await getRequest(url);
    return User(userdata);
  }

  Future<User> getProfile() async {
    String url = 'userprofile';
    dynamic userdata = await getRequest(url);
    return User(userdata);
  }
}

class User extends API {
  int user;
  String userId;
  String nickname;
  int birthday;
  int gender;
  int point;
  int xp;
  String hobby;
  int limitConnectppGroup;
  int limitNichiclockTask;
  String profileText;
  int lastlogin;
  String lastloginstatus;
  String serviceid;
  int enableConnectpp;
  int notificationAlreadyTime;
  int createdate;
  int activityTime;
  int activityCount;
  String tags;
  String imageUrl;

  User(Map<String, dynamic> userdata) {
    user = userdata['user'];
    userId = userdata['userid'];
    nickname = userdata['nickname'];
    birthday = userdata['birthday'];
    gender = userdata['gender'];
    point = userdata['point'];
    xp = userdata['xp'];
    hobby = userdata['hobby'];
    limitConnectppGroup = userdata['limit_connectpp_group'];
    limitNichiclockTask = userdata['limit_nichiclock_task'];
    profileText = userdata['profile_text'];
    lastlogin = userdata['lastlogin'];
    lastloginstatus = userdata['lastloginstatus'];
    serviceid = userdata['serviceid'];
    enableConnectpp = userdata['enable_connectpp'];
    notificationAlreadyTime = userdata['notification_alreadyTime'];
    createdate = userdata['createdate'];
    activityTime = userdata['activity_time'];
    activityCount = userdata['activity_count'];
    tags = userdata['tags'];
    String baseUrl = 'https://restapi-enpit.p0x0q.com/api';
    imageUrl = '$baseUrl/images/user/thumbnail/userid/$userId/show?i';
  }

  Widget icon([Widget child]) {
    return FittedBox(
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          // border: Border.all(color: Colors.white30, width: 6),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }
}

class Notification {
  int id;
  String userid;
  String eventTypeId;
  String title;
  String description;
  String clickLinkUrl;
  String avaterType;
  String avaterValue;
  String dataJson;
  int isPush;
  int isPushed;
  String updated;
  String created;

  Notification(Map<String, dynamic> notification) {
    id = notification['id'];
    userid = notification['userid'];
    eventTypeId = notification['event_type_id'];
    title = notification['title'];
    description = notification['description'];
    clickLinkUrl = notification['click_link_url'];
    avaterType = notification['avater_type'];
    avaterValue = notification['avater_value'];
    dataJson = notification['data_json'];
    isPush = notification['is_push'];
    isPushed = notification['is_pushed'];
    updated = notification['updated'];
    created = notification['created'];
  }
}
