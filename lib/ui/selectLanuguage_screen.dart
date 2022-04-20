
import 'package:flutter/material.dart';

import 'constants.dart';


void main() => runApp(SelectLanguagescreen());
 
class SelectLanguagescreen extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}
 
class _SelectLanguageState extends State {
  String msg = 'Pleae Select the Language';
 
   @override
   Widget build(BuildContext context) {

     return Material(

       child: Container(
         child: Column(

           children: [
             Text(
                msg,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),

           RaisedButton(
                child: Text("English"),
                onPressed: navigation(),
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              Divider(),
              RaisedButton(
                child: Text("Hindi"),
                onPressed: navigation(),
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              Divider(),
              RaisedButton(
                child: Text("Telugu"),
                onPressed: navigation(),
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
        
           ],
         ),
        ),
     );


   }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.yellow,
  //     appBar: AppBar(
  //       title: Text('Raised Button'),
  //     ),
  //     body: Container(
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               msg,
  //               style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
  //             ),
  //             RaisedButton(
  //               child: Text("Rock & Roll"),
  //               onPressed: _changeText,
  //               color: Colors.red,
  //               textColor: Colors.yellow,
  //               padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //               splashColor: Colors.grey,
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  navigation() {
    setState(() {
    //   if (msg.startsWith('F')) {
    //     msg = 'I have learned FlutterRaised example ';
    //   } else {
    //     msg = 'Flutter RaisedButton example';
    //   }
    // });
    Navigator.of(context).pushReplacementNamed(Constants.SIGN_IN);
     });
  }
}
