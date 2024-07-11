import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Post extends StatelessWidget {
  final String postSeq;
  final String postTitle;
  final String postContents;
  final String category;
  final String viewed;
  final List<dynamic> tags;

  const Post({
    required this.postSeq,
    required this.postTitle,
    required this.postContents,
    required this.category,
    required this.viewed,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(postTitle),
          Text(category),
          Text(viewed.toString()),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tags.length,
              itemBuilder: (context, index) {
                return Text(tags[index]);
              }),
          Html(data: postContents),
        ],
      ),
    );
  }
}
