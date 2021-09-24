import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubizie/constants.dart';
import 'package:dubizie/models/user.dart';
import 'package:dubizie/pages/home.dart';
import 'package:dubizie/widgets/progress.dart';
import "package:flutter/material.dart";

class EditProfile extends StatefulWidget {
  final String? currentUserId;

  EditProfile(this.currentUserId);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displaynameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  User? user;
  bool _displaynameValid = true;
  bool _bioValid = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    isLoading = true;
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displaynameController.text = user!.displayName;
    bioController.text = user!.bio;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.done),
            iconSize: 30.0,
            color: Colors.green,
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              CachedNetworkImageProvider(user!.photoUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildDisplaynameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                          child: Text(
                            'Update Profile',
                            style: TextStyle(
                              color: kThemeData.primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: updateProfileData),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                          onPressed: logout,
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          label: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Column buildDisplaynameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Display Name',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: displaynameController,
          decoration: InputDecoration(
            errorText: _displaynameValid ? null : 'Display name too short',
            hintText: 'Update Display Name',
          ),
        ),
      ],
    );
  }

  buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Bio',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            errorText: _bioValid ? null : 'Bio too long',
            hintText: 'Update Bio',
          ),
        ),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      if (displaynameController.text.trim().length < 3 ||
          displaynameController.text.trim().isEmpty) {
        _displaynameValid = false;
      } else {
        _displaynameValid = true;
      }

      if (bioController.text.trim().length > 100) {
        _bioValid = false;
      } else {
        _bioValid = true;
      }
    });
    if (_displaynameValid && _bioValid) {
      usersRef.doc(widget.currentUserId).update({
        "displayName": displaynameController.text,
        "bio": bioController.text,
        // TODO Fix appearance of previous page (data isn't updating).
      });
      SnackBar snackBar = SnackBar(content: Text('Profile updated!'));
      _scaffoldkey.currentState!.showSnackBar(snackBar);
    }
  }

  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
}
