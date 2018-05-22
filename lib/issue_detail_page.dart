import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import './service/issue_service.dart';
import './model/topic.dart';

class IssueDetailPage extends StatefulWidget {
  final int iid ;
  final String cover;

  IssueDetailPage({
    this.iid,
    this.cover,
  });

  @override
  _IssueDetailPageState createState() => new _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage> {
  bool _isLoading;
  String _title = "";
  List<Topic> _topics = [];
  final IssueService _issueService = new IssueService();
  final Widget _loadingWidget = new SliverFillRemaining(
    child: new Container(
      child: const Center(
        child: const CircularProgressIndicator(),
      )
    ),
  );

  @override
  void initState() {
    super.initState();
    _fetchIssue();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = new SliverAppBar(
      pinned: true,
      title: new Text(
        _title,
        style: new TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
//      brightness: Brightness.dark,
      expandedHeight: 200.0,
      leading: _buildBackButton(),
      backgroundColor: Colors.lightGreen.withAlpha(255),
      flexibleSpace: new FlexibleSpaceBar(background: _buildHeader(),),
    );

    var body = new NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: new CustomScrollView(
        // https://docs.flutter.io/flutter/widgets/ScrollPhysics-class.html
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          appBar,
          _topics.isEmpty ? _loadingWidget : new SliverList(
            delegate: new SliverChildListDelegate(
              _topics.map(_renderTopic).toList()
            )
          )
        ],
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      body: body,
    );
  }

  Widget _renderTopic(Topic topic) {
    return new Material(
      color: Colors.white,
      child: new Container(
        child: new Column(
          children: <Widget>[
            new _TopicHeader(topic.name),
            new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: topic.articles
                  .map((article) => new _ArticleTile(article))
                  .toList()
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildBackButton() {
    var platform = Theme.of(context).platform;
    final IconData backIcon = platform == TargetPlatform.android
        ? Icons.arrow_back
        : Icons.arrow_back_ios;
    return new IconButton(
      padding: EdgeInsets.zero,
      icon: new Icon(backIcon, color: Colors.white),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildHeader() {
    return new ConstrainedBox(
      constraints: new BoxConstraints.expand(height: 200.0),
      child: new Hero(
        tag: widget.cover,
        child: new FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: widget.cover,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _fetchIssue() async {
    setState(() {
      _isLoading = true;
    });

    var _list = await _issueService.getTopicList(widget.iid);
    setState(() {
      _topics = _list;
      _isLoading = false;
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    var visibleStatsHeight = notification.metrics.pixels;
    var screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    var visiblePercentage = visibleStatsHeight / screenHeight;
    setState(() {
      _title = visiblePercentage > 0.12 ? "第 ${widget.iid} 期" : "";
    });
    return false;
  }
}

class _ArticleTile extends StatelessWidget {
  _ArticleTile(this._article);

  final Article _article;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () {
         openURL(_article.url);
      },
      child: new Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
          left: 20.0,
          right: 20.0,
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Container(
              child: new Text(
                _article.title,
                style: new TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.0,
                  height: 1.4
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            new Container(
              child: new Text(
                _article.description,
                style: new TextStyle(
                  color: const Color(0xFF666666),
                  fontSize: 14.0,
                  height: 1.2
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}

class _TopicHeader extends StatelessWidget {
  _TopicHeader(this._topic);

  final String _topic;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 70.0,
      child: new Stack(
        children: <Widget>[
          new Center(
            child: new Image(
              image: new AssetImage("assets/bg_topic.png"),
            ),
          ),
          new Center(
            child: new Text(
              _topic,
              style: new TextStyle(
                color: const Color(0xFF649F0C),
                fontSize: 18.0
              ),
            ),
          )
        ],
      ),
    );
  }
}
