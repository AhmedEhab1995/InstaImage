import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubizie/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterShare',
      theme: kThemeData,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
