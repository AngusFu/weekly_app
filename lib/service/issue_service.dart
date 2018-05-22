import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/issue_list.dart';
import '../model/topic.dart';

class IssueService {
  static final _jsonCodec = const JsonCodec();
  static final _api = "https://weeklyapi.75team.com/issue";

  Future<List<Topic>> getTopicList([_index = -1]) async {
    var url;

    if (_index is! int || _index <= 0) {
      url = "$_api/latest";
    } else {
      url = "$_api/detail/$_index";
    }

    var resp = await http.get(url);
    var json = _jsonCodec.decode(resp.body);
    print(url);
    var articles = json["article"] as List<dynamic>;

    return articles
      .map((topic) => new Topic.fromMap(topic))
      .toList();
  }

  Future<IssueList> getIssueList ({ int index = 1 }) async {
    var url = "$_api/list/$index";

    var resp = await http.get(url);
    var json = _jsonCodec.decode(resp.body);
    return new IssueList.fromMap(json as Map<String, dynamic>);
  }
}
