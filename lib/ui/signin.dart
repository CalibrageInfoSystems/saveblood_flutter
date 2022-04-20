import 'dart:convert';
import 'dart:ffi';


import 'package:flutter/material.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:http/http.dart';
import '../ui/widgets/custom_shape.dart';
import '../ui/widgets/responsive_ui.dart';
import '../ui/widgets/textformfield.dart';

import '../utils/validator.dart';
import 'constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../ui/api_config.dart';

ProgressDialog pr;
LocalData localData ;

class SignInPage extends StatelessWidget {
  
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
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
   localData =new LocalData();
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
      child: Container(
        
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgotpasswprdUpTextRow(),
              button(),
              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.5 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.redAccent],
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
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange[200], Colors.redAccent],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.5, top: 90.0),
          child: Container(
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
              child: Image.asset(
                'assets/images/app_logo.png',
              )),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("key_Welcome"),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("key_Sign_in_to_your_account"),
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: emailController,
      
      icon: Icons.person,
      hint: AppTranslations.of(context).text("key_user_name"),
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.visiblePassword,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: AppTranslations.of(context).text("key_password"),
    );

  }

 

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        bool isnetavailable = await Validator.isNetAvailable();
        if(isnetavailable){
        if (validate()) {
          
            await  makePostRequest();
        }
        }else{
          Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Please Check Your Internet Connection')));
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(AppTranslations.of(context).text("Key_sign_in"),
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  bool validate() {
    if (Validator.validateusernameLength(emailController.value.text) != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateusernameLength(emailController.value.text))));
      return false;
    } else if (Validator.validatePasswordLength(
            passwordController.value.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validatePasswordLength(
              passwordController.value.text))));
      return false;
    } else {
      
      return true;
    }
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("key_Dont_have_an_account?"),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Constants.SIGN_UP);
              print("Routing to Sign up screen");
            },
            child: Text(
              AppTranslations.of(context).text("key_sign_up"),
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }
 Widget forgotpasswprdUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppTranslations.of(context).text("key_forgot_password"),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(Constants.FORGOTPASSWORD);
              print("Routing to Sign up screen");
            },
            child: Text(
              "Forgot Password ?",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: _large ? 15 : (_medium ? 17 : 12)),
            ),
          )
        ],
      ),
    );
  }
 Future<Void> makePostRequest() async {
    pr.show();
        // 'userName': emailController.value.text,
        // 'password': passwordController.value.text,

      final uri =  baseUrl+loginComponentUrl; 
      final headers = {'Content-Type': 'application/json'};
      Map<String, dynamic> body = {

        'userName': emailController.value.text,
        'password': passwordController.value.text,
        'clientId': 'saveblood_spa',
        'clientSecret': null,
        'scope': 'saveblood_api'
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
          await saveLoginData(parsedMAP['result']);
        } else {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(parsedMAP['endUserMessage'])));
        }
        print('Login Responce value:' + isSuccess.toString());
      } else {
        pr.dismiss();
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Username OR')));
      }
    
  }

  Future<void> saveLoginData(Map<String, dynamic> parsedMAP) async {

       print('---- analysis------ Login Data Saving in Local :'+parsedMAP.toString());
          
      
       await localData.addStringToSF(LocalData.USER_ID, parsedMAP['userId']);

        String token =parsedMAP['accessToken'];
        print('access Token ::'+token);
       await localData.addStringToSF(LocalData.accessToken, 'Bearer '+token);
       
      await localData.addBoolToSF(LocalData.isLogin, true);
       Navigator.of(context).pushReplacementNamed(Constants.PROFILE_SCREEN_NEW);

  }
}
