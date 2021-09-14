import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'package:ring_sns/api/API.dart';
import 'package:ring_sns/api/accountAPI.dart';

class ChatAPI extends API {
  ChatAPI(String bearer) : super(bearer);

  Future<int> getCommentcount(String roomId) async {
    String url = 'chat/comment/count/$roomId';
    dynamic response = await getRequest(url);
    return response;
  }

  Future<MessageList> getChatMessages(String roomId, int page) async {
    String url = 'chat/comment/roomid/$roomId';
    Map<String, dynamic> queryParameters = {'page': page};
    dynamic response = await getRequest(url, queryParameters);
    return MessageList(response);
  }

  Future<String> uploadImage(String imageFilePath) async {
    String url = 'images/upload/cupy';
    FormData formData = FormData.fromMap({
      'name': 'image_file',
      'image_file': await MultipartFile.fromFile(imageFilePath,
          contentType: MediaType('multipart', 'form-data')),
    });
    dynamic response = await postImageRequest(url, formData);
    String filename = response['file_name'];
    return 'https://restapi-enpit.p0x0q.com/api/images/cupy/$filename';
  }

  Future<List<dynamic>> searchThreads(String query) async {
    String url = 'search/room/group_chat';
    Map<String, String> payload = {'q': query};
    dynamic response = await getRequest(url, payload);
    return response['data'];
  }

  Future<String> createRoom(
      int groupId, String name, String description) async {
    String url = 'chat/room/roomid';
    Map<String, dynamic> queryParameters = {
      'name': name,
      'description': description,
      'auth_type': 'group',
      'group_id': groupId.toString()
    };
    dynamic response = await postRequest(url, queryParameters);
    return response['roomid'];
  }

  Future<ChatRoomInfo> getRoomInfo(String roomId) async {
    String url = 'chat/room/roomid/$roomId';
    dynamic response = await getRequest(url);
    return ChatRoomInfo(response);
  }

  //ユーザーチャットの作成
  Future<String> createRoomUser(
      int groupId, String name, String description) async {
    String url = 'chat/room/roomid';
    Map<String, dynamic> queryParameters = {
      'name': name,
      'description': description,
      'auth_type': 'public',
    };
    await postRequest(url, queryParameters);

    return "ok";
  }

  Future<List<ChatRoomInfo>> getThreads(int groupId) async {
    String url = 'chat/mychat/group_id';
    Map<String, dynamic> queryParameters = {'group_id': groupId.toString()};
    dynamic response = await getRequest(url, queryParameters);
    List<ChatRoomInfo> chatRoomList = [];
    if (response == null) return [];
    response.forEach((chatRoom) {
      chatRoomList.add(ChatRoomInfo(chatRoom));
    });
    return chatRoomList;
  }

  Future<List<User>> getMainlyMembers(String roomId) async {
    String url = 'chat/room/members/$roomId';
    dynamic response = await getRequest(url);
    List<User> userList = [];
    if (response == null) return [];
    response.forEach((userdata) {
      userList.add(User(userdata));
    });
    return userList;
  }

  Future<String> uploadThreadImage(String imageFilePath, String roomid) async {
    String url = 'images/upload/room';
    FormData formData = FormData.fromMap({
      'roomid': roomid,
      'type_id': 'background',
      'name': 'image_file',
      'image_file': await MultipartFile.fromFile(imageFilePath,
          contentType: MediaType('multipart', 'form-data')),
    });
    await postImageRequest(url, formData);
    return "ok";
  }

  Future<String> getRoomIdFriendChat(String targetUserid) async {
    String url = 'friend/chat/show/$targetUserid';
    dynamic response = await getRequest(url);
    return response['roomid'];
  }

  Future<Map<String, dynamic>> getChatHistory() async {
    String url = 'chat/history';
    dynamic response = await getRequest(url);
    return response;
  }

  String chatRoomImageUrl(String roomId) {
    return 'https://restapi-enpit.p0x0q.com/api/images/room/background/roomid/$roomId/show?i';
  }
}

class Message {
  int chatId;
  String uuid;
  String roomId;
  String userId;
  String nickname;
  String text;
  String goodsUsers;
  String created;

  Message(Map<String, dynamic> message) {
    chatId = message['chatid'];
    uuid = message['uuid'];
    roomId = message['roomid'];
    userId = message['userid'];
    nickname = message['nickname'];
    text = message['text'];
    goodsUsers = message['goods_users'];
    created = message['created'];
  }
}

class MessageList {
  List<Message> messageList;
  String nextUrl;
  int currentPage;

  MessageList(Map<String, dynamic> response) {
    messageList = [];
    response['data'].forEach((comment) {
      messageList.add(Message(comment));
    });
    nextUrl = response['next_page_url'];
    currentPage = response['current_page'];
  }
}

class ChatRoomInfo {
  String roomId;
  int uid;
  String label;
  String authType;
  String authValue;
  int count;
  String name;
  String description;
  String ownerIdDelete;
  String ownerId;
  String image;
  String lastdateOld;
  String updated;
  String color;

  ChatRoomInfo(Map<String, dynamic> chatRoom) {
    roomId = chatRoom['roomid'];
    uid = chatRoom['uid'];
    label = chatRoom['label'];
    authType = chatRoom['auth_type'];
    authValue = chatRoom['auth_value'];
    count = chatRoom['count'];
    name = chatRoom['name'];
    description = chatRoom['description'];
    ownerIdDelete = chatRoom['owner_id_delete'];
    ownerId = chatRoom['owner_id'];
    image = chatRoom['image'];
    lastdateOld = chatRoom['lastdate_old'];
    updated = chatRoom['updated'];
    color = chatRoom['color'];
  }
}
