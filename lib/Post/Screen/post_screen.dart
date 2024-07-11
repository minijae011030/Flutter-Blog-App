import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PostScreen extends StatefulWidget {
  final String postSeq;
  PostScreen({required this.postSeq});
  _PostState createState() => _PostState();
}

class _PostState extends State<PostScreen> {
  Future<Object>? post;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('post'),
      ),
      body: Container(child: Text("post")),
    );
  }
}
