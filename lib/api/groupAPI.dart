import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/accountAPI.dart';

class GroupAPI extends API {
  GroupAPI(String bearer) : super(bearer);

  String getThumbnailURL(int groupId) =>
      'https://restapi-editile.p0x0q.com/api/images/group/thumbnail/group_id/${groupId.toString()}/show?i';

  Future<List<User>> getMemberList(int groupId) async {
    String url = 'group/member/manage/${groupId.toString()}';
    dynamic response = await getRequest(url);
    List<User> userList = [];
    response.forEach((userdata) {
      userList.add(User(userdata));
    });
    return userList;
  }

  Future<dynamic> joinGroup(int groupId) async {
    String url = 'group/member/manage';
    Map<String, dynamic> queryParameters = {
      'group_id': groupId.toString(),
    };
    return await postRequest(url, queryParameters);
  }

  Future<dynamic> exitGroup(int groupId) async {
    String url = 'group/member/manage/${groupId.toString()}';
    return await deleteRequest(url);
  }

  Future<String> uploadGroupImage(int groupId, String imageFilePath) async {
    String url = 'images/upload/group';
    FormData formData = FormData.fromMap({
      'group_id': groupId.toString(),
      'type_id': 'thumbnail',
      'name': 'image_file',
      'image_file': await MultipartFile.fromFile(imageFilePath,
          contentType: MediaType('multipart', 'form-data')),
    });
    await postImageRequest(url, formData);
    return 'ok';
  }

  Future<List<dynamic>> controlInvite(int inviteId, int control) async {
    String url = 'group/invite/receive/' + inviteId.toString();
    Map<String, dynamic> queryParameters = {
      'control': control,
    };
    await putRequest(url, queryParameters);
    return [];
  }

  Future<List<dynamic>> getGroupList() async {
    String url = 'group/member/joined';
    return await getRequest(url);
  }

  Future<List<dynamic>> getRecommendedGroupList() async {
    String url = 'group/member/recommended';
    return await getRequest(url);
  }

  Future<List<dynamic>> getInvitedGroupList() async {
    String url = 'group/invite/receive';
    return await getRequest(url);
  }

  Future<List<dynamic>> searchGroups(String query) async {
    String url = 'search/group/$query';
    dynamic response = await getRequest(url);
    return response['data'];
  }

  Future<dynamic> getGroupInfo(int groupId) async {
    String url = 'group/manage/${groupId.toString()}';
    return await getRequest(url);
  }

  Future<int> makeGroup(String name) async {
    String url = 'group/manage';
    Map<String, dynamic> queryParameters = {
      'name': name,
      'is_confirm': 0,
      'confirm_type': 'auto',
    };
    dynamic response = await postRequest(url, queryParameters);
    return response['group']['group_id'];
  }

  Future<dynamic> setGroupInfo(
      {@required int groupId, String name, String description}) async {
    String url = 'group/manage/${groupId.toString()}';
    Map<String, dynamic> queryParameters = {
      'name': name,
      'description': description,
      'is_confirm': 0,
      'confirm_type': 'auto',
    };
    return await putRequest(url, queryParameters);
  }

  Future<List<dynamic>> getFriends() async {
    String url = 'friend/manage';
    dynamic response = await getRequest(url);
    return response;
  }

  Future<List<dynamic>> fetchRecentlyGroup([int limit = 10]) async {
    String url = 'group/recently/list';
    dynamic response = await getRequest(url);
    return response['data'];
  }

  Future<dynamic> searchGroupTag(String tag) async {
    String url = 'search/group_tag/$tag';
    dynamic response = await getRequest(url);
    return response['data'];
  }

  Future<dynamic> favoriteGroup(int groupId) async {
    String url = 'group/favorite';
    Map<String, dynamic> queryParameters = {
      'group_id': groupId.toString(),
    };
    return await postRequest(url, queryParameters);
  }

  Future<bool> favoriteGroupShow(int groupId) async {
    String url = 'group/favorite/${groupId.toString()}';
    dynamic response = await getRequest(url);
    return response['response'];
  }

  Future<dynamic> favoriteGroupDelete(int groupId) async {
    String url = 'group/favorite/${groupId.toString()}';
    return await deleteRequest(url);
  }

  Future<dynamic> getFavoriteGroupList() async {
    String url = 'group/favorite';
    return await getRequest(url);
  }
}
