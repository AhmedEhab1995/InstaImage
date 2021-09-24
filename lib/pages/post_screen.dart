import 'package:dubizie/pages/home.dart';
import 'package:dubizie/widgets/headerProfile.dart';
import 'package:flutter/material.dart';
import 'package:dubizie/widgets/post.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({required this.postId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.doc(userId).collection('userPosts').doc(postId).get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        Post post = Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: headerProfile(post.description, false),
            body: ListView(
              children: [
                Container(
                  child: post,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
