import 'dart:async';
import 'package:ring_sns/api/API.dart';

class CalendarAPI extends API {
  CalendarAPI(String bearer) : super(bearer);

  Future<List<Event>> getEventList(String groupId) async {
    String url = 'group/event/list/$groupId';

    List<Event> eventList = [];
    List<dynamic> response = await getRequest(url);
    response.forEach((event) {
      eventList.add(Event(event));
    });
    return eventList;
  }

  Future<List<Event>> getEventListAll() async {
    String url = 'group/event';

    List<Event> eventList = [];
    List<dynamic> response = await getRequest(url);
    response.forEach((event) {
      eventList.add(Event(event));
    });
    return eventList;
  }
}

class Event {
  int id;
  int groupId;
  String title;
  String description;
  String start;
  String end;
  String groupName;
  String screenId;
  String ownerId;
  String ownerIdDelete;
  String ownerIds;
  int isConfirm;
  int isGroupChat;
  String confirmType;
  String isRecommendedImage;
  String tags;
  String created;
  String updated;

  Event(Map<String, dynamic> event) {
    id = event['id'];
    groupId = event['group_id'];
    title = event['event_title'];
    description = event['event_description'];
    start = event['start_at'] ?? '2021-01-01 00:00:00';
    end = event['end_at'];
    groupName = event['name'];
    screenId = event['screen_id'];
    ownerId = event['owner_id'];
    ownerIdDelete = event['owner_id_delete'];
    ownerIds = event['owner_ids'];
    isConfirm = event['is_confirm'];
    isGroupChat = event['is_group_chat'];
    confirmType = event['confirm_type'];
    isRecommendedImage = event['is_recommended_image'];
    tags = event['tags'];
    created = event['created'];
    updated = event['updated'];
  }
}
