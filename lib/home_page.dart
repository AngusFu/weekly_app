import 'dart:async';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import './service/issue_service.dart';
import './model/issue.dart';
import 'model/issue_list.dart';
import './issue_detail_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;
  int _totalPages = 1;
  List<Issue> _issues = [];
  bool _isLoading = false;

  final IssueService _issueService = new IssueService();
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPage(_currentPage);
    _scrollController.addListener(() {
      // SEE https://marcinszalek.pl/flutter/infinite-dynamic-listview/
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchPage(_currentPage + 1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        backgroundColor: Colors.lightGreen
      ),
      body: new RefreshIndicator(
        child: new ListView.builder(
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            if (index == _issues.length) {
              return new _MyCustomProgressIndicator();
            }

            return new IssueCard(_issues[index]);
          },
          itemCount: _issues.length + 1,
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 10.0
          ),
        ),
        onRefresh: _onRefresh,
      ),
    );
  }

  Future<Null> _onRefresh () async {
    if (_isLoading == false) {
      _currentPage = 1;
      _issues = [];
      await _fetchPage(_currentPage);
    }
  }

  _fetchPage (int page) async {
    if (_isLoading) {
      return;
    }

    if (page > _totalPages) {
      var edge = 52.0;
      var offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
      if (offsetFromBottom < edge) {
        _scrollController.animateTo(
          _scrollController.offset - (edge - offsetFromBottom),
          duration: new Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      var result = await _issueService.getIssueList(index: page);
      await _delay(3000);
      _applyNewPage(result);
    }
  }

  _applyNewPage(IssueList result) {
    setState(() {
      _issues.addAll(result.list);

      _currentPage = result.currentPage;
      _totalPages = result.totalPages;
      _isLoading = false;
    });
  }

  _delay(int milliseconds) {
    final completer = new Completer();
    var ms = new Duration(milliseconds: milliseconds);
    new Timer(ms, completer.complete);
    return completer;
  }
}


class IssueCard extends StatelessWidget {
  final Issue _issue;

  IssueCard(this._issue);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new IssueDetailPage(
            iid: _issue.iid,
            cover: _issue.cover,
          );
        }));
      },
      child: new Column(
        children: <Widget>[
          new Container(
            color: Colors.lightGreen.withAlpha(100),
            child: new Hero(
              tag: _issue.cover,
              child: new AspectRatio(
                aspectRatio: 9 / 5,
                child: new FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: _issue.cover,
                ),
              ),
            ),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            decoration: new BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                new BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 5.0),
                  blurRadius: 6.0,
                )
              ]
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            margin: const EdgeInsets.only(bottom: 30.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "奇舞周刊第 ${_issue.iid} 期",
                  style: new TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                new Text(
                  _issue.date,
                  style: new TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyCustomProgressIndicator extends StatefulWidget {
  @override
  _MyCustomProgressIndicatorState createState() => new _MyCustomProgressIndicatorState();
}

class _MyCustomProgressIndicatorState extends State<_MyCustomProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
          child: new Opacity(
            opacity: 1.0,
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
      onTap: () {
        print('Height is ${context.size.height}');
      },
    );
  }
}
