import 'dart:convert';

import 'package:blog/Post/Screen/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>>? pinnedPostList;
  Future<List<dynamic>>? postList;

  @override
  void initState() {
    super.initState();
    pinnedPostList = _pinnedPostListAPI();
    postList = _postListAPI();
  }

  Future<List<dynamic>> _pinnedPostListAPI() async {
    var url = Uri.parse("${dotenv.env['BASE_URL']}/post/list?page=1&size=3");

    var result = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "blogId": dotenv.env['BLOG_ID'],
        }));

    if (result.statusCode == 200) {
      var res = jsonDecode(result.body);
      return res['pinnedPostList'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> _postListAPI() async {
    var url = Uri.parse("${dotenv.env['BASE_URL']}/post/list?page=1&size=5");

    var result = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "blogId": dotenv.env['BLOG_ID'],
        }));

    if (result.statusCode == 200) {
      var res = jsonDecode(result.body);
      return res['unpinnedPostList'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([pinnedPostList!, postList!]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No posts found');
          }

          var pinnedPosts = snapshot.data![0];
          var posts = snapshot.data![1];

          return ListView(
            children: [
              if (pinnedPosts.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        "고정글 >",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...pinnedPosts.map<Widget>((post) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                            title: Text(post['postTitle']),
                            subtitle: Text(post['categoryName']),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) {
                                    return PostScreen(postSeq: post['postSeq']);
                                  }));
                            },
                          ),
                          HorizontalLine(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              if (posts.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                      child: Text(
                        "최신글 >",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...posts.map<Widget>((post) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                            title: Text(post['postTitle']),
                            subtitle: Text(post['categoryName']),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) {
                                    return PostScreen(postSeq: post['postSeq']);
                                  }));
                            },
                          ),
                          HorizontalLine(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, width: 370, color: Colors.black45);
  }
}
