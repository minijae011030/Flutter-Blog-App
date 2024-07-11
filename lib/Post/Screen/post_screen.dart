import 'dart:convert';

import 'package:blog/Post/Widget/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PostScreen extends StatefulWidget {
  final String postSeq;
  PostScreen({required this.postSeq});
  _PostState createState() => _PostState();
}

class _PostState extends State<PostScreen> {
  Future<Map<String, dynamic>>? post;

  @override
  void initState() {
    super.initState();
    post = _postAPI();
  }

  Future<Map<String, dynamic>> _postAPI() async {
    var url = Uri.parse("${dotenv.env['BASE_URL']}/post/contents");

    var result = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "postSeq": widget.postSeq,
          "blogId": dotenv.env['BLOG_ID'],
        }));

    if (result.statusCode == 200) {
      var res = jsonDecode(result.body);

      return res['postList'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([post!]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No post found');
          }

          var postData = snapshot.data![0];

          return Scaffold(
              appBar: AppBar(
                title: Text("${postData['postTitle']}"),
              ),
              body: Post(
                postSeq: postData['postSeq'],
                postTitle: postData['postTitle'],
                postContents: postData['postContents'],
                category: postData['category'],
                tags: postData['tags'],
                viewed: postData['viewed'],
              ));
        });
  }
}
