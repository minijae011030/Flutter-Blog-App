import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>>? pinnedPostList;

  @override
  void initState() {
    super.initState();
    pinnedPostList = _callAPI();
  }

  Future<List<dynamic>> _callAPI() async {
    var url = Uri.parse("${dotenv.env['BASE_URL']}/post/list");

    var result = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "blogId": dotenv.env['BLOG_ID'],
        }));

    if (result.statusCode == 200) {
      var res = await jsonDecode(result.body);

      return res['pinnedPostList'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: FutureBuilder<List<dynamic>>(
            future: pinnedPostList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No pinnedposts found');
              }
              print(snapshot.data);
              var posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  var post = posts[index];
                  return ListTile(
                      title: Text(post['postTitle']),
                      subtitle: Html(
                        data: post['postContents'],
                      ));
                },
              );
            }),
      ),
    );
  }
}
