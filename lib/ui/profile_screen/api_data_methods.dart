import 'dart:convert';


import 'package:flutter_logindemo/ui/models/bloodgroup_model.dart';
import 'package:flutter_logindemo/ui/models/states_model.dart';
import 'package:http/http.dart';

import '../api_config.dart';

class ProfileData {
  
  Future<List<BloodGrop>> getbloodgroups() async {
    List<BloodGrop> bloodGroups = new List<BloodGrop>();
    var apiurl =baseUrl + getbloodgroupsUrl;
    print('API CALL :'+apiurl);
    Response res = await get(apiurl);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        bloodGroups.add(new BloodGrop(
            name: items[i]['name'], typeCdDmtId: items[i]['typeCdDmtId']));
      }
       return bloodGroups;
    } else {
      return null;
    }
  }
  Future<List<AddressItemModel>> getstates() async {
    List<AddressItemModel> statelist = new List<AddressItemModel>();
    Response res = await get(baseUrl + getStatesByCountryComponentUrl);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        statelist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
     return statelist;
    } else {
      return null;
    }
  }
  Future<List<AddressItemModel>> getDistsbystateid(int stateid) async {
    List<AddressItemModel> distslist = new List<AddressItemModel>();
    Response res = await get(
        baseUrl + getDistrictsByStateComponentUrl + '/' + stateid.toString());

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        distslist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
     return distslist;
    } else {
      return null;
    }
  }
  Future<List<AddressItemModel>> getMandalsbyDistid(int distid) async {
    List<AddressItemModel> mandalslist = new List<AddressItemModel>();

    var url =
        baseUrl + getMandalsByDistrictComponentUrl + '/' + distid.toString();
    print('API :' + url);
    Response res = await get(url);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        mandalslist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
    return mandalslist;
    } else {
      return null;
    }
  }
  Future<List<AddressItemModel>> getvillaagebyMandalid(int mandalis) async {
  List<AddressItemModel> villagelist = new List<AddressItemModel>();

    var url =
        baseUrl + getVillagesByMandalComponentUrl + '/' + mandalis.toString();
    print('API :' + url);
    Response res = await get(url);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        villagelist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      return villagelist;
    } else {
      return null;
    }
  }
  Future<Map<String,dynamic>> getProfileinfo(String _userid,String _token) async {
     Map<String,dynamic> userresponce= new Map();
          Response res = await get(baseUrl + getProfileComponentUrl + _userid,
              headers: {'authorization': _token});

          int statusCode = res.statusCode;
          String responseBody = res.body;

          if (statusCode == 200) {
            userresponce = json.decode(responseBody);
            print('::: _getprofile :::: Success : 200');
            print('User Profile Responce :'+userresponce.toString());
           return userresponce;
          } else if (statusCode == 401) {
             print('::: _getprofile :::: error : 401');
             userresponce= {'statusCode':401};
            return null;
          } else {
            print('::: _getprofile :::: error :'+statusCode.toString());
            userresponce= {'statusCode': statusCode};
            return null;
          }
       
     
   
  }
  
  
Future<int> postUserData(String _userid, String _token,int _id,String _fullname,String _email,String _mobilenumber,
BloodGrop bloodGrop,
bool isDiabetic,bool isAlcohalic,bool diseased,bool hivPositive,bool isAnyMajorSurgeries,
) async {
    final uri = baseUrl +updateProfileComponentUrl ;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _token
    };

 
   var updateprofileEntity =   {
  "id": _id,
  "userId": _userid,
  "firstName": null,
  "midddleName": null,
  "lastName": null,
  "mobileNumber":"7032214469",
  "email": _email,
  "fullName": _fullname,
  "addressId": 27,
  "genderTypeId": null,
  "dob": null,
  "bloodGroupTypeId": bloodGrop.typeCdDmtId,
  "height": null,
  "weight": null,
  "isDiabetic": null,
  "isAlcohalic": null,
  "diseased": null,
  "hivPositive": null,
  "isAnyMajorSurgeries": null,
  "emergencyContactId": null,
  "emergencyOptContactId": null,
  "address": null,
  "emergencyContact": null,
  "emergencyOptContact": null,
  "entity": {
    "listResult": [],
    "isSuccess": true,
    "affectedRecords": 0,
    "endUserMessage": "Get  Entity Details Successfull",
    "validationErrors": [],
    "exception": null
  },
  "createdBy": null,
  "updatedBy": null,
  "updatedDate": "2020-01-23T09:27:13.438996",
  "createdDate": "2020-01-23T09:27:13.438996"
};
// };
  
    String jsonBody = json.encode(updateprofileEntity);
    final encoding = Encoding.getByName('utf-8');
    print('---------------------------------------------------------');
    print('Post user profile API Request :  ' + jsonBody);
    print('---------------------------------------------------------');
    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );


    int statusCode = response.statusCode;

    String responseBody = response.body;
    print('---------------------------------------------------------');
    print('User profile Resoponce :' + responseBody);
    print('---------------------------------------------------------');
    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);
    }
    return statusCode;
  }
 
}