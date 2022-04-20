import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/api_config.dart';

import 'package:flutter_logindemo/ui/widgets/custom_textForm.dart';
import 'package:flutter_logindemo/ui/widgets/gradient_appbar.dart';
import 'package:flutter_logindemo/ui/widgets/responsive_ui.dart';
import 'package:flutter_logindemo/ui/widgets/textformfield.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'models/states_model.dart';

ProgressDialog pr;
LocalData localData;
BuildContext ctx;

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  double _height;

  double _width;

  double _pixelRatio;

  bool _large;

  bool _medium;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  String dropdownValue = 'One';
  String _mySelection;
// List<AddressItemModel> data = new List<AddressItemModel>();
  @override
  void initState() {
    super.initState();
    // getSWData();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return new Scaffold(
      body: new Builder(

        builder: (BuildContext context) {
          return new Container(
            child: RaisedButton(
              child: Text('post profile info'),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
