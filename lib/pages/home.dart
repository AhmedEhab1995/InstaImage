import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubizie/pages/activity_feed.dart';
import 'package:dubizie/pages/profile.dart';
import 'package:dubizie/pages/timeline.dart';
import 'package:dubizie/pages/search.dart';
import 'package:dubizie/pages/upload.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants.dart';
import 'create_account.dart';
import 'package:dubizie/models/user.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');

final DateTime timestamp = DateTime.now();
User? currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    SignInUsingGoogleInitState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  void SignInUsingGoogleInitState() {
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSigninLogic(account);
    }, onError: (err) {
      Fluttertoast.showToast(msg: 'error signing in: $err');
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSigninLogic(account!);
    }).catchError((err) {
      Fluttertoast.showToast(msg: 'Error sigining in: $err');
    });
  }

  void handleSigninLogic([GoogleSignInAccount? account]) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    final GoogleSignInAccount? user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user!.id).get();

    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
      });
      doc = await usersRef.doc(user.id).get();
    }
    setState(() {
      currentUser = User.fromDocument(doc);
    });
  }

  void login() {
    googleSignIn.signIn();
  }

  void logout() {
    googleSignIn.signOut();
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(currentUser: currentUser!),
          // RaisedButton(
          //   child: Text('Logout'),
          //   onPressed: () {
          //     logout();
          //   },
          // ),
          ActivityFeed(),
          Upload(currentUser!), // TODO fix this null value
          Search(),
          Profile(currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: (pageIndex) {
          setState(() {
            this.pageIndex = pageIndex;
          });
        },
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: (pageIndex) {
          pageController.animateToPage(
            pageIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        activeColor: kThemeData.primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_active,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
          ),
        ],
      ),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: () {
    //     logout();
    //   },
    // );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                kThemeData.accentColor,
                kThemeData.primaryColor,
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                // todo chage to text animated kit
                'InstaImage',
                style: TextStyle(
                  fontFamily: "Signatra",
                  fontSize: 90.0,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    //signInWithGoogle();
                    login();
                  });
                },
                child: Container(
                  width: 260.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/google_signin_button.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}

// Future<UserCredential> signInWithGoogle() async {
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   final GoogleSignInAuthentication googleAuth =
//       await googleUser!.authentication;
//   final OAuthCredential credential = GoogleAuthProvider.credential(
//     idToken: googleAuth.idToken,
//     accessToken: googleAuth.accessToken,
//   );
//   Fluttertoast.showToast(msg: "Account created");
//   isAuth = true;
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }

// TODO Fix sigining in and signing out
