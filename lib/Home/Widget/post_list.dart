import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  final int postSeq;
  final String postTitle;
  final String postContents;
  final String categoryName;
  final int viewed;

  const PostList({
    required this.postSeq,
    required this.postTitle,
    required this.postContents,
    required this.categoryName,
    required this.viewed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(postTitle),
          Text(categoryName),
          Text(viewed.toString()),
        ],
      ),
    );
  }
}
