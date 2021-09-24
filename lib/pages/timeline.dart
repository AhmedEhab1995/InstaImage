import 'package:dubizie/models/user.dart';
import 'package:dubizie/pages/home.dart';
import 'package:dubizie/widgets/header.dart';
import 'package:dubizie/widgets/post.dart';
import 'package:dubizie/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userRef =
    FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final User currentUser;

  Timeline({required this.currentUser});
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<Post> posts = [];

  @override
  void initState() {
    //createUser();
    //updateUser();
    //deleteUser();

    super.initState();
    getTimeline();
  }

  getTimeline() async {
    QuerySnapshot snapshot1 = await followersRef
        .doc(widget.currentUser.id)
        .collection('userFollowers')
        .get();

    List<Post> posts = [];
    for (QueryDocumentSnapshot myId in snapshot1.docs.toList()) {
      QuerySnapshot snapshot = await postsRef
          .doc(myId.id)
          .collection('userPosts')
          .orderBy('timestamp', descending: true)
          .get();
      posts.addAll(snapshot.docs.map((doc) => Post.fromDocument(doc)).toList());
    }
    QuerySnapshot snapshot = await postsRef
        .doc(widget.currentUser.id)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();

    posts.addAll(snapshot.docs.map((doc) => Post.fromDocument(doc)).toList());

    setState(() {
      this.posts = posts;
    });
  }

  // getTimeline() async {
  //   QuerySnapshot snapshot1 = await followersRef
  //       .doc(widget.currentUser.id)
  //       .collection('userFollowers')
  //       .get();
  //
  //   print(snapshot1.docs.first.id);
  //
  //   QuerySnapshot snapshot = await postsRef
  //       .doc(widget.currentUser.id)
  //       .collection('userPosts')
  //       .orderBy('timestamp', descending: true)
  //       .get();
  //
  //   List<Post> posts =
  //       snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
  //
  //   setState(() {
  //     this.posts = posts;
  //   });
  // }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(),
        body: RefreshIndicator(
          onRefresh: () => getTimeline(),
          child: buildTimeline(),
        ));
  }

  buildTimeline() {
    if (posts == null) {
      return CircularProgressIndicator();
    } else {
      return ListView(
        children: posts,
      );
    }
  }
}
