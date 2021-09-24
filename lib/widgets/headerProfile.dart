import 'package:dubizie/constants.dart';
import 'package:flutter/material.dart';

headerProfile(String headerTitle, bool leading) {
  return AppBar(
    automaticallyImplyLeading: leading,
    title: Text(
      headerTitle,
      style: TextStyle(color: Colors.white, fontSize: 22.0),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: kThemeData.accentColor,
  );
}
