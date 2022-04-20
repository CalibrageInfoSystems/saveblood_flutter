import 'package:shared_preferences/shared_preferences.dart';

class LocalData {

 static const String isLogin = 'isLogin';
  static const String isProfileUpdated = 'isprofileUpdated';
 static const String USER_ID = 'userId';
 static const String accessToken = 'accessToken';

Future<bool> getBoolValuesSF(String keyBool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(keyBool);
    return boolValue;
  }

Future<void>  addBoolToSF(String keyBool, bool istrue) async{
    SharedPreferences prefs =await  SharedPreferences.getInstance();
    prefs.setBool(keyBool, istrue);

    print(':: SHARED PREF:: isLogin :: '+prefs.getBool(isLogin).toString());
  }

 Future<void>  addStringToSF(String keySting, String inputValue) async{
    SharedPreferences prefs =await  SharedPreferences.getInstance();
    prefs.setString(keySting, inputValue);

  } 

  Future<String>  getStringValueSF(String keyBool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String boolValue = prefs.getString(keyBool);
    return boolValue;
  }
}
