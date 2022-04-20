import 'dart:io';



class Validator {
 
 static String validateemptyString(String _inputvalue)
 {
   if(_inputvalue.length <2)
   {
     return 'input value is very small';
   }else{
return null;
   } 

 }
 static String validateName(String value) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

 static String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if (value.length != 10) {
      return "Mobile number must 10 digits";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  static String validatePasswordLength(String value) {
    if (value.length == 0) {
      return "Password can't be empty";
    } else if (value.length < 5) {
      return "Password must be longer than 5 characters";
    }
    return null;
  }
  static String validateusernameLength(String value) {
    if (value.length == 0) {
      return "userName can't be empty";
    } else if (value.length < 5) {
      return "userName must be longer than 5 characters";
    }
    return null;
  }

  static String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  static Future<bool> isNetAvailable() async {
    try {
      final result = await  InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         return true;
      }
    } on SocketException catch (_) {
       return false;
    }
  }


}
