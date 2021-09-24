import 'package:dubizie/widgets/headerProfile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      Navigator.pop(context, username);
      Fluttertoast.showToast(msg: "Welcome $username");
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: headerProfile("Setup your profile", false),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      'Create a user name',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val!.trim().length < 3 || val.trim().isEmpty) {
                            return "username too short";
                          } else if (val.trim().length > 15) {
                            return "username too long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => username = val!,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "User name",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 3 characters"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    width: 350.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
