import 'dart:async';
import 'package:ring_sns/api/API.dart';

class BlockAPI extends API {
  BlockAPI(String bearer) : super(bearer);

  Future<dynamic> blockGroup(int groupId) async {
    String url = 'block/group_id';
    Map<String, dynamic> queryParameters = {
      'group_id': groupId,
      'state': 1,
    };
    return await putRequest(url, queryParameters);
  }

  Future<dynamic> blockUser(String userId) async {
    String url = 'block/userid';
    Map<String, dynamic> queryParameters = {
      'userid': userId,
      'state': 1,
    };
    return await putRequest(url, queryParameters);
  }
}
