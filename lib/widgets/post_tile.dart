import 'package:dubizie/pages/post_screen.dart';
import 'package:dubizie/widgets/custom_image.dart';
import 'package:dubizie/widgets/post.dart';
import 'package:flutter/material.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          userId: post.ownerId,
          postId: post.postId,
        ),
      ),
    );
  } // 6:27

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
