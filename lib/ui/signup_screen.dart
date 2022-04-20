import 'dart:async';
import 'dart:convert';
import 'dart:ffi';


import 'package:flutter/material.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:flutter_logindemo/utils/validator.dart';
import 'package:http/http.dart';
import '../ui/widgets/custom_shape.dart';
import '../ui/widgets/responsive_ui.dart';
import '../ui/widgets/textformfield.dart';

import 'package:progress_dialog/progress_dialog.dart';
import '../ui/api_config.dart';
import 'widgets/customappbar.dart';

ProgressDialog pr;
LocalData localData;

class SignupScreenNew extends StatelessWidget {
  static const rootname = 'SignInPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController confirmPassWordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    localData = new LocalData();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.black54,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInCubic,
      progressTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w600),
    );

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Opacity(opacity: 0.88, child: CustomAppBar()),
            clipShape(),
            form(),
            // acceptTermsTextRow(),
            SizedBox(
              height: _height / 35,
            ),
            button(),

            //signInTextRow(),
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.pinkAccent],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
              onTap: () {
                print('Adding photo');
              },
              child: Image.asset(
                'assets/images/app_logo.png',
              )),
        ),

      ],
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
            SizedBox(height: _height / 60.0),
            confirmpasswordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: firstNameController,
      icon: Icons.person,
      hint: "First Name",
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: userNameController,
      icon: Icons.person,
      hint: "User Name",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: contactNumberController,
      icon: Icons.phone,
      hint: "Contact Number",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      textEditingController: passWordController,
      icon: Icons.lock,
      hint: "Password",
    );
  }

  Widget confirmpasswordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: confirmPassWordController,
      obscureText: true,
      icon: Icons.lock,
      hint: "Confirm Password",
    );
  }

  Widget acceptTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        bool isNetworkavailable = await Validator.isNetAvailable();
        if (isNetworkavailable) {
          if (validateData()) {
            print('--- analysis ----- signup validation completed ');
            await makeSignupPostRequest();
          }
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Please Check Your Internet Connection')));
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        //        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Future<Void> makeSignupPostRequest() async {
    pr.show();

    final uri = baseUrl + signUpComponentUrl;
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'newPassword': passWordController.value.text,
      'id': null,
      'userName': userNameController.value.text,
      'fullName': userNameController.value.text,
      'email': emailController.value.text,
      'phoneNumber': contactNumberController.value.text,
      'configuration': null,
      'isEnabled': true
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    int statusCode = response.statusCode;
    String responseBody = response.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);
      pr.dismiss();

      bool isSuccess = parsedMAP['isSuccess'];
      if (isSuccess) {
        // do some oparation
        // Save Data in Local
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('user Created successFully')));
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(parsedMAP['endUserMessage'])));
      }
      print('Login Responce value:' + isSuccess.toString());
    } else {
      pr.dismiss();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Username OR')));
    }
  }

  bool validateData() {
    if (Validator.validateusernameLength(firstNameController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateusernameLength(
              firstNameController.value.text))));
      return false;
    } else if (Validator.validateusernameLength(
            userNameController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateusernameLength(
              firstNameController.value.text))));
      return false;
    } else if (Validator.validateMobile(passWordController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateusernameLength(
              Validator.validateMobile(passWordController.value.text)))));
      return false;
    } else if (Validator.validateEmail(emailController.value.text) != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateEmail(emailController.value.text))));
      return false;
    } else if (Validator.validatePasswordLength(
            passWordController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validatePasswordLength(
              passWordController.value.text))));
      return false;
    } else if (Validator.validatePasswordLength(
            confirmPassWordController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validatePasswordLength(
              passWordController.value.text))));

      return false;
    } else if (passWordController.value.text !=
        confirmPassWordController.value.text) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Password And Confirm Password Must Match')));
      return false;
    } else {
      return true;
    }
  }
}
