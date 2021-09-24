import 'package:dubizie/constants.dart';
import 'package:flutter/material.dart';

header() {
  return AppBar(
    title: Text(
      'InstaImage',
      style: TextStyle(
          color: Colors.white, fontFamily: "Signatra", fontSize: 50.0),
    ),
    centerTitle: true,
    backgroundColor: kThemeData.accentColor,
  );
}
