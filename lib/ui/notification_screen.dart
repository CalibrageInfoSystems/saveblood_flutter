import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../utils/localdata.dart';
import 'widgets/app_drawer.dart';

import '../ui/api_config.dart';

LocalData localData ;
String userID='';
ProgressDialog pr;

List<String> notificationsArray = [];

class NotificationScreen extends StatefulWidget {


  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int page = 1;
  List<String> items = ['item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2', 'item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2','item 1', 'item 2',];
  bool isLoading = false;


  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 2));

    await  getAllNotifications();

print("load more");
    // update data and loading status
    setState(() {
      items.addAll( ['item 1']);
      print('items: '+ items.toString());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mahesh'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading && scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  _loadData();
                  // start loading data
                  setState(() {
                    isLoading = true;
                  });
                }
              },
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${notificationsArray[index]}'),
                  );
                },
              ),
            ),
          ),
          Container(
            height: isLoading ? 50.0 : 0,
            color: Colors.transparent,
            child: Center(
              child: new CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }


   Future<Void> getAllNotifications() async {
      
      userID = await localData.getStringValueSF(LocalData.USER_ID);

        print('UserID -->> ' + userID);
      
                  pr.show();
                  final uri =  baseUrl + getAllNotificationsUrl; 
                  final headers = {'Content-Type': 'application/json'};
                  Map<String, dynamic> body = {
                        "userId": userID,
                        "pageIndex": 0,
                        "pageSize": 10
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
            
                  if (statusCode == 200){
                    Map<String, dynamic> parsedMAP = json.decode(responseBody);

                   //notificationsArray = parsedMAP["result"];

                    for (var name in parsedMAP["listResult"]) {

                      notificationsArray.add(name["text"]);                     
                    }
                      pr.dismiss();
                      print(parsedMAP.keys);
                  }
                  else{
                    pr.dismiss();
            
            
                  }
            
                  
            
                 
               }
}