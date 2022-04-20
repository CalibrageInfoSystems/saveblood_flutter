import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/constants.dart';
import '../utils/localdata.dart';





class SplashScreen extends StatefulWidget {
 
  static const rootname = 'SplashScreen';
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
 //bool isLogin = LocalData.getBoolValuesSF(LocalData.isLogin);
   LocalData localData =new LocalData();
  AnimationController animationController;
  Animation<double> animation;
 
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async{
   
    var data =await localData.getBoolValuesSF(LocalData.isLogin);
    var profileupdated =await localData.getBoolValuesSF(LocalData.isProfileUpdated);
    
    print('shared pref value :'+ data.toString());

    if (data != null && data ) {
      if(profileupdated != null && profileupdated)
      {
Navigator.of(context).pushReplacementNamed(Constants.HOME_SCREEN);
      }else{
Navigator.of(context).pushReplacementNamed(Constants.PROFILE_SCREEN_NEW);
      }
        
    } else {
      Navigator.of(context).pushReplacementNamed(Constants.SelectLanguage_Screen);
    }
   
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  //child:new Image.asset('assets/images/app_logo.png',height: 25.0,fit: BoxFit.scaleDown,))

                  child: new Text('http://saveblood.org/',
                      style: TextStyle(color: Colors.redAccent))),
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/app_logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
