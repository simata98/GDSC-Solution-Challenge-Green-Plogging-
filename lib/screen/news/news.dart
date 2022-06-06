import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/retry.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class News extends StatefulWidget {
  News() : super();
  final String title = 'Environment Feeds';
  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<News> {
  static const String FEED_URL = 'https://rss.app/feeds/tYsy9Ho3MZp2S7Ob.xml';
  RssFeed? _feed;
  String? _title;
  static const String loadingFeedMsg = 'Loading Feed...';
  static const String feedLoadErrorMsg = 'Error Loading Feed...';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg = 'assets/no_article_image.png';
  GlobalKey<RefreshIndicatorState>? _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed?.title);
    });
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    var string_subTitle =
        DateFormat('yyyy-MM-dd hh:mm:ss.SSS').format(subTitle);
    return Text(
      // Fri, 03 Jun 2022 11:00:00 GMT E, dd MMM yyyy HH:mm:ss zzz
      string_subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 80,
        width: 80,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
        itemCount: _feed?.items!.length,
        itemBuilder: (BuildContext context, int index) {
          final item = _feed?.items![index];
          return ListTile(
              title: title(item?.title!),
              subtitle: subtitle(item!.pubDate!),
              leading: thumbnail(item.enclosure!.url),
              trailing: rightIcon(),
              contentPadding: EdgeInsets.all(3.0),
              onTap: () => openFeed(item.link!));
        });
  }

  isFeedEmpty() {
    // ignore: unnecessary_null_comparison
    return null == _feed || null == _feed?.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
