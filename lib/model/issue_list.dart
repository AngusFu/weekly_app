import 'dart:core';
import './issue.dart';

toIssue (List<dynamic> data) {
  return data
    .map((item) => new Issue.fromMap(item))
    .toList();
}

class IssueList {
  final int count;
  final int totalPages;
  final int numsPerPage;
  final int currentPage;

  List<Issue> list;

  IssueList({
    this.count,
    this.totalPages,
    this.numsPerPage,
    this.currentPage,
    this.list
  });

  IssueList.fromMap(Map<String, dynamic> map)
    : count = map['count'],
      totalPages = map['totalPages'],
      numsPerPage = map['numsPerPage'],
      currentPage = map['currentPage'],
      list = toIssue(map['data']);
}
