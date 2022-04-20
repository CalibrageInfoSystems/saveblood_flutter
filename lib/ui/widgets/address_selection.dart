import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/models/states_model.dart';

import 'package:http/http.dart';

import '../api_config.dart';

class AddressWidget extends StatefulWidget {
  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  List<AddressItemModel> statesListfromapi = new List<AddressItemModel>();

  // Future<List<AddressItemModel>> getStates() async {
  //   List<AddressItemModel> statelist = new List<AddressItemModel>();
  //   Response res = await get(baseUrl + getStatesByCountryComponentUrl);

  //   int statusCode = res.statusCode;
  //   String responseBody = res.body;

  //   if (statusCode == 200) {
  //     Map<String, dynamic> parsedMAP = json.decode(responseBody);

  //     var items = parsedMAP['listResult'] as List;
  //     for (int i = 0; i < items.length; i++) {
  //       print(items[i]['name']);
  //       statelist.add(
  //           new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
  //     }
  //     setState(() {
  //       statesListfromapi = statelist;
  //     });

  //     return statelist;
  //   } else {
  //     return null;
  //   }
  // }
  List<AddressItemModel> _stateslist;
  List<AddressItemModel> distlist;
  List<AddressItemModel> madalslist;
  List<AddressItemModel> villageslist;

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();

  String dropdownValue = 'One';

  AddressItemModel selectedvalue;

  @override
  void initState() {
    super.initState();
 
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Hospital Management"),
      ),
      body: new Center(
        child: addressform(),
      ),
    );
  }

  Widget addressform() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 20.0, right: _width / 20.0, top: _height / 50.0),
      child: Form(
        child: Column(
          children: <Widget>[
            //  addressTextRow(),

            // Text('state',style: TextStyle(color: Colors.black,),textAlign: TextAlign.left),
            //stateDropDown(),
            // Text('dist',
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //     textAlign: TextAlign.start),
            // distDropDown(),
            // Text('mandal',
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //     textAlign: TextAlign.start),
            // mandalDropDown(),
            // Text('village',
            //     style: TextStyle(
            //       color: Colors.black,
            //     ),
            //     textAlign: TextAlign.start),
            // villageDropDown(),
          ],
        ),
      ),
    );
  }

  Widget addressTextRow() {
    return Center(
      child: Text(
        "Address Details",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget button(BuildContext context) {
    return RaisedButton(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Please Check Your Internet Connection')));
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
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10))),
      ),
    );
  }

  Widget stateDropDown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: InputDecorator(
        child: Container(
          padding: EdgeInsets.only(left: 10),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(25.0),
          //   border: Border.all(
          //       color: Colors.grey, style: BorderStyle.solid, width: 0.80),

          // ),

          child: Column(children: <Widget>[
            DropdownButton<AddressItemModel>(
              hint: Text('choose state'),
              isExpanded: true,
              value: selectedvalue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 12,
              style: TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.transparent,
              ),
              // onChanged: (AddressItemModel newValue) {
              //   setState(() {
              //     selectedvalue = newValue;
              //   });
              // },

              items: statesListfromapi.map((AddressItemModel lang) {
                return DropdownMenuItem<AddressItemModel>(
                  value: lang,
                  child: Text(lang.name),
                );
              }).toList(),
            ),
          ]),
        ),
      ),
    );
  }

  Widget distDropDown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<String>(
            hint: Text('DropdownButton Hint'),
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String newValue) {
              // setState(() {
              //   dropdownValue = newValue;
              // });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget mandalDropDown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<String>(
            hint: Text('DropdownButton Hint'),
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['One', 'Two', 'Free', 'Four']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget villageDropDown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<String>(
            hint: Text('DropdownButton Hint'),
            isExpanded: true,
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            // items: statelist.map<DropdownMenuItem<String>>((String value) {
            //   return DropdownMenuItem<String>(
            //     value: value,
            //     child: Text(value),
            //   );
            // }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget ExpndableWiget() {
    return Card(
      child: ExpansionTile(
        title: Text('Birth of Universe'),
        children: <Widget>[
          Text('Big Bang'),
          Text('Birth of the Sun'),
          Text('Earth is Born'),
        ],
      ),
    );
  }

  Future<List<AddressItemModel>> getDisctlist(int stateid) async {
    List<AddressItemModel> dists = new List<AddressItemModel>();
    Response res = await get(
        baseUrl + getDistrictsByStateComponentUrl + '/' + stateid.toString());

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        dists.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      print('dists size :' + dists.length.toString());
      return dists;
    } else {
      return null;
    }
  }

  Future<List<AddressItemModel>> getmandalslist(int distid) async {
    List<AddressItemModel> mandals = new List<AddressItemModel>();
    Response res = await get(
        baseUrl + getMandalsByDistrictComponentUrl + '/' + distid.toString());

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        mandals.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      print('mandals size :' + mandals.length.toString());
      return mandals;
    } else {
      return null;
    }
  }

  Future<List<AddressItemModel>> getvillageslist(int mandalId) async {
    List<AddressItemModel> mandals = new List<AddressItemModel>();
    Response res = await get(
        baseUrl + getVillagesByMandalComponentUrl + '/' + mandalId.toString());

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        mandals.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      print('villages size :' + mandals.length.toString());
      return mandals;
    } else {
      return null;
    }
  }

  
}
