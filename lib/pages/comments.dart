import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubizie/pages/activity_feed.dart';
import 'package:dubizie/widgets/headerProfile.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'home.dart';

class Comments extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String mediaUrl;

  Comments(
      {required this.postId, required this.ownerId, required this.mediaUrl});

  @override
  CommentsState createState() => CommentsState(
      postId: this.postId, ownerId: this.ownerId, mediaUrl: this.mediaUrl);
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId;
  final String ownerId;
  final String mediaUrl;

  CommentsState(
      {required this.postId, required this.ownerId, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerProfile("Comments", true),
      body: Column(
        children: [
          Expanded(
            child: BuildComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: "Write a comment",
              ),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Post"),
            ),
          ),
        ],
      ),
    );
  }

  BuildComments() {
    return StreamBuilder(
      stream: commentsRef
          .doc(postId)
          .collection('comments')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Comment> comments = [];
        snapshot.data!.docs.forEach((doc) {
          comments.add(Comment.fromDocument(doc));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    commentsRef.doc(postId).collection('comments').add({
      "username": ownerId,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser!.photoUrl,
      "userId": currentUser!.id,
    });
    activityFeedRef.doc(ownerId).collection("feedItems").add({
      "type": "comment",
      "commentData": commentController.text,
      "timestamp": timestamp,
      "postId": postId,
      "userId": currentUser!.id,
      "username": currentUser!.username,
      "userProfileImg": currentUser!.photoUrl,
      "mediaUrl": mediaUrl
    }); //01:07
    commentController.clear();
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {required this.username,
      required this.userId,
      required this.avatarUrl,
      required this.comment,
      required this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      avatarUrl: doc['avatarUrl'],
      timestamp: doc['timestamp'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(comment),
          leading: GestureDetector(
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(avatarUrl),
            ),
            onTap: () => showProfile(context, profileId: userId),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider()
      ],
    );
  }
}
