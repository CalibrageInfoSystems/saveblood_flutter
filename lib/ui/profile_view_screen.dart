import 'dart:convert';


import 'dart:wasm';
import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/models/bloodgroup_model.dart';
import 'package:flutter_logindemo/utils/localdata.dart';
import 'package:flutter_logindemo/utils/validator.dart';


import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'api_config.dart';
import 'models/states_model.dart';
import 'widgets/app_drawer.dart';
import 'widgets/textformfield.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'widgets/textformfield2.dart';

// enum Gender { male, female }

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

const String MIN_DATETIME = '2020-05-12';
const String MAX_DATETIME = '2021-11-25';
const String INIT_DATETIME = '2019-05-17';

class _UserProfileViewState extends State<UserProfileView> {
  TextEditingController fullnameControler =
      new TextEditingController(); // Fullname
  TextEditingController firstNameControler = new TextEditingController();
  TextEditingController midddleNameControler = new TextEditingController();
  TextEditingController lastNameControler = new TextEditingController();
  TextEditingController mobileNumberControler = new TextEditingController();
  TextEditingController emailControler = new TextEditingController();
  TextEditingController dobControler = new TextEditingController();
  TextEditingController heightControler = new TextEditingController();
  TextEditingController weightControler = new TextEditingController();
  
 TextEditingController address1Controler = new TextEditingController();
  TextEditingController address2Controler = new TextEditingController();
  bool _value1 = false;
  bool _value2 = false;

  var _firstValue = false;

  var _secValue = false;
  var valueradio = 'one';

  String selectedGender;

  String _valuegender;
  void _value1Changed(bool value) => setState(() => _value1 = value);
  void _value2Changed(bool value) => setState(() => _value2 = value);

  // Address
 
  TextEditingController landmarkControler = new TextEditingController();
  TextEditingController villageIdControler = new TextEditingController();

  //emergencyContact
  TextEditingController nameControler = new TextEditingController();
  TextEditingController contactNumberControler = new TextEditingController();
  TextEditingController relationshipControler = new TextEditingController();

  //emergencyContact2
  TextEditingController name1Controler = new TextEditingController();
  TextEditingController contactNumber1Controler = new TextEditingController();
  TextEditingController relationship1Controler = new TextEditingController();

  Map<String, dynamic> profiledata = new Map();
  GlobalKey<FormState> _key = GlobalKey();

  int _groupValue1 = -2;
  int _groupValue2 = -3;
  int selectedRadio;

  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;

  String _format = 'yyyy-MMMM-dd';
  TextEditingController _formatCtrl = TextEditingController();
  bool _showTitle = false;

  DateTime _dateTime;
  List<BloodGrop> _bloodGroups = new List<BloodGrop>();
  BloodGrop blooddropdownValue;
  String dropdownValue = 'One';
  String _hint = 'select blood group';

  List _myActivities;
  String _myActivitiesResult;

  List<AddressItemModel> _stateslist = new List<AddressItemModel>();
  List<AddressItemModel> _distslist = new List<AddressItemModel>();
  List<AddressItemModel> _mandalslist = new List<AddressItemModel>(); //
  List<AddressItemModel> _villagelist = new List<AddressItemModel>();
  AddressItemModel stateselected;
  AddressItemModel distsselected;
  AddressItemModel mandalselected;
  AddressItemModel villagelistselected;
  LocalData localData = new LocalData();

  @override
  Future<void> initState() {
    super.initState();

    blooddropdownValue = null;
    stateselected = null;
    distsselected = null;
    mandalselected = null;
    villagelistselected = null;
    getstates();
    getbloodgroups();

    _valuegender = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('SnackBar Playground'),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: form(context),
        ),
      ),
    );
  }

  Widget addressForm() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ]),
      child: ExpansionTile(title: Text('Adress form'), children: <Widget>[
        Material(
          child: Column(children: <Widget>[
            statesDropdown(),
            SizedBox(height: 5.0),
            distsDropdown(),
            SizedBox(height: 5.0),
            mandalsDropdown(),
            SizedBox(height: 5.0),
            villagesDropdown(),
            SizedBox(height: 5.0),
            landmarkFormField(),
          ]),
        ),
      ]),
    );
  }

  Widget statesDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: Colors.black38, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('select states '),
            isExpanded: true,
            value: stateselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              setState(() {
                mandalselected = null;
                distsselected = null;
                villagelistselected = null;
                stateselected = newValue;

                getDistsbystateid(newValue.id);
              });
            },
            items: _stateslist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget distsDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('select dist'),
            isExpanded: true,
            value: distsselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              setState(() {
                mandalselected = null;
                villagelistselected = null;
                getMandalsbyDistid(newValue.id);
                if (newValue == null) {
                } else {
                  distsselected = newValue;
                }

                //distsselected = newValue;
                // getDistsbystateid(newValue.id);
              });
            },
            items: _distslist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget mandalsDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('Select Madal '),
            isExpanded: true,
            value: mandalselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              villagelistselected = null;
              setState(() {
                if (newValue == null) {
                } else {
                  mandalselected = newValue;
                }
                getvillaagebyMandalid(newValue.id);
                //distsselected = newValue;
                // getDistsbystateid(newValue.id);
              });
            },
            items: _mandalslist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget villagesDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('Select Village '),
            isExpanded: true,
            value: villagelistselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              setState(() {
                if (newValue == null) {
                } else {
                  villagelistselected = newValue;
                }
                //distsselected = newValue;
                // getDistsbystateid(newValue.id);
              });
            },
            items: _villagelist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Future<void> getstates() async {
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
      setState(() {
        _stateslist = statelist;
      });
    } else {
      return null;
    }
  }

  Future<void> getDistsbystateid(int stateid) async {
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
      setState(() {
        _distslist = distslist;
      });
    } else {
      return null;
    }
  }

  Future<void> getMandalsbyDistid(int distid) async {
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
      setState(() {
        if (mandalslist != null) {
          _mandalslist = mandalslist;
        }
      });
    } else {
      return null;
    }
  }
  Future<void> getvillaagebyMandalid(int mandalis) async {
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
      setState(() {
        if (villagelist != null) {
          _villagelist = villagelist;
        }
      });
    } else {
      return null;
    }
  }

  Widget form(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 15, top: 20),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: 5.0),
            phoneNumberTextFormField(),
            SizedBox(height: 5.0),
            emailTextFormField(),
            SizedBox(height: 5.0),
            _genderselection(),
            SizedBox(height: 5.0),
            dateofBirthFormField(),
            SizedBox(height: 5.0),
            address1TextFormField(),
            SizedBox(height: 5.0),
            address2TextFormField(),
            SizedBox(height: 5.0),
            heightFormField(),
            SizedBox(height: 5.0),
            weightFormField(),
            SizedBox(height: 5.0),
            disesChecklist(),
            SizedBox(height: 5.0),
            bloodgroupdropdown(),
            SizedBox(height: 5.0),
            addressForm(),
            SizedBox(height: 5.0),
            contactnumberForm(),
            SizedBox(height: 5.0),
            contactnumberForm2(),
            SizedBox(height: 5.0),
            RaisedButton(
                child: Text('address id'),
                onPressed: () async {

if(true)
{
   await validate(context);
}else
{
 Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('check internet connection')));
}

                  

                  // print('Fullname :' + fullnameControler.value.text);
                  // print('Mobile Number' + mobileNumberControler.value.text);
                  // print('email : ' + emailControler.value.text);
                  // print('Gender :' + _valuegender);
                  // if (_dateTime == null) {
                  //   print('date of birth : null');
                  // } else {
                  //   print('date of birth :' +
                  //       DateFormat.yMMMMd().format(_dateTime));
                  // }

                  // print('height :' + heightControler.value.text);
                  // print('weight :' + weightControler.value.text);

                  // for (int i = 0; i < _myActivities.length; i++) {
                  //   print('Dises :' + _myActivities[i]);
                  // }

                  // print('Bloodgroup :' + blooddropdownValue.name);

                  // print('State :' + stateselected.name);
                  // print('Dist :' + distsselected.name);
                  // print('Mandal :' + mandalselected.name);
                  // print('village :' + villagelistselected.name);
                  // print('landmark :' + landmarkControler.value.text);
                  // print(
                  //     'contact number 1:' + contactNumberControler.value.text);
                  // print('name 1 :' + nameControler.value.text);
                  // print('relation 1 :' + relationshipControler.value.text);
                  // print(
                  //     'contact number 2:' + contactNumber1Controler.value.text);
                  // print('name 2 :' + name1Controler.value.text);
                  // print('relation 2 :' + relationship1Controler.value.text);
                }),
          ],
        ),
      ),
    );
  }

  Future validate(BuildContext context) async {
     if (Validator.validateName(fullnameControler.text) != null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('filename cannot be empty')));
    } else if (Validator.validateMobile(
            mobileNumberControler.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateMobile(
              mobileNumberControler.text))));
    } else if (Validator.validateEmail(emailControler.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              Validator.validateEmail(emailControler.text))));
    }else if(address1Controler.text.isEmpty)
    {
     Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              Validator.validateEmail('Please Enter Address1'))));
    }
     else if (_valuegender == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select Gender')));
    } else if (_dateTime == 'date') {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Please DOB')));
    } else if (heightControler.text.length == null ||
        heightControler.text.length < 1) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select Height')));
    } else if (weightControler.text.length == null ||
        weightControler.text.length < 1) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select Wight')));
    } else if (_myActivities.length == 0) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select health info')));
    } else if (blooddropdownValue == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select blood group')));
    } else if (stateselected == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select state')));
    } else if (distsselected == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select Distict')));
    } else if (mandalselected == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select mandal')));
    } else if (villagelistselected == null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please Select village')));
    } else if (Validator.validateName(landmarkControler.text) !=
        null) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Please enter landmark')));
    } else if (Validator.validateMobile(
            contactNumberControler.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(Validator.validateMobile(
              contactNumberControler.text))));
    } else if (Validator.validateName(nameControler.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please enter contact person name')));
    } else if (Validator.validateName(
            relationshipControler.text) !=
        null) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please enter person relation')));
    } else if (contactNumber1Controler.text != null) {
      if (Validator.validateMobile(contactNumber1Controler.text) !=
          null) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(Validator.validateMobile(contactNumber1Controler.text))));
      }else if(Validator.validateName(name1Controler.text) != null)
      {
    Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Please enter Contact person2 name')));
      }
      else if(Validator.validateName(relationship1Controler.text) != null)
      {
    Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Please enter Contact person2 Relation')));
      }else{
        await localData
          .getStringValueSF(LocalData.USER_ID)
          .then((_userid) async {
        await localData
            .getStringValueSF(LocalData.accessToken)
            .then((_token) {
          _postUserData(_userid, _token);
        });
      });
      }
    
    
    } else {
      await localData
          .getStringValueSF(LocalData.USER_ID)
          .then((_userid) async {
        await localData
            .getStringValueSF(LocalData.accessToken)
            .then((_token) {
          _postUserData(_userid, _token);
        });
      });
    }
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: fullnameControler,
      icon: Icons.person,
      hint: "Full Name",
    );
  }

  Widget phoneNumberTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: mobileNumberControler,
      icon: Icons.phone,
      hint: "Phone Number",
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailControler,
      icon: Icons.email,
      hint: "email",
    );
  }
  Widget address1TextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: address1Controler,
      icon: Icons.home,
      hint: "Address 1",
    );
  }
 Widget address2TextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: address2Controler,
      icon: Icons.home,
      hint: "Address 2",
    );
  }

  Widget dateofBirthFormField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text('Date Of Birth :')),
              Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  child: InkWell(
                    child: Container(
                        child: Text(_dateTime == null
                            ? 'date '
                            : DateFormat.yMMMMd().format(_dateTime))),
                    onTap: () => _showDatePicker(),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget heightFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: heightControler,
      icon: Icons.line_weight,
      hint: "Height in CM",
    );
  }

  Widget weightFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: weightControler,
      icon: Icons.line_weight,
      hint: "Weight in kg",
    );
  }

  Widget landmarkFormField() {
    return CustomTextField2(
      keyboardType: TextInputType.text,
      textEditingController: landmarkControler,
      icon: Icons.map,
      hint: "landmark",
    );
  }

  Widget contactnumberForm() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ]),
      child: ExpansionTile(
        title: Text('Contact Form 1'),
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5.0),
                  CustomTextField2(
                    keyboardType: TextInputType.number,
                    textEditingController: contactNumberControler,
                    icon: Icons.line_weight,
                    hint: "Emergency Contact Number 1 ",
                  ),
                  SizedBox(height: 5.0),
                  CustomTextField2(
                    keyboardType: TextInputType.text,
                    textEditingController: nameControler,
                    icon: Icons.line_weight,
                    hint: "Contact Name ",
                  ),
                  SizedBox(height: 5.0),
                  CustomTextField2(
                    keyboardType: TextInputType.text,
                    textEditingController: relationshipControler,
                    icon: Icons.line_weight,
                    hint: "Relation Ship ",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contactnumberForm2() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ]),
      child: ExpansionTile(
          title: Container(
              child: Text(
            'Contact Form 2',
          )),
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5.0),
                  CustomTextField2(
                    keyboardType: TextInputType.number,
                    textEditingController: contactNumber1Controler,
                    icon: Icons.line_weight,
                    hint: "Emergency Contact Number 2 ",
                  ),
                  SizedBox(height: 5.0),
                  CustomTextField2(
                    keyboardType: TextInputType.text,
                    textEditingController: name1Controler,
                    icon: Icons.line_weight,
                    hint: "Contact Name ",
                  ),
                  SizedBox(height: 5.0),
                  CustomTextField2(
                    keyboardType: TextInputType.text,
                    textEditingController: relationship1Controler,
                    icon: Icons.line_weight,
                    hint: "Relation Ship ",
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _genderselection() {
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
            hint: Text('Select Gender '),
            isExpanded: true,
            value: _valuegender,
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
                if (newValue == null) {
                } else {
                  _valuegender = newValue;
                  print('Gender :' + _valuegender);
                }
                //distsselected = newValue;
                // getDistsbystateid(newValue.id);
              });
            },
            items: <String>{'Male', 'female'}.map((String user) {
              return new DropdownMenuItem<String>(
                value: user,
                child: new Text(
                  user,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget bloodgroupdropdown() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<BloodGrop>(
            hint: new Text(_hint),
            isExpanded: true,
            value: blooddropdownValue,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (BloodGrop newValue) {
              setState(() {
                blooddropdownValue = newValue;
                _hint = newValue.name;
              });
              print(newValue.name);
            },
            items: _bloodGroups.map((BloodGrop user) {
              return new DropdownMenuItem<BloodGrop>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Widget disesChecklist() {
    return MultiSelectFormField(
      autovalidate: false,
      titleText: 'health information',
      validator: (value) {
        if (value == null || value.length == 0) {
          return 'Please select one or more options';
        }
      },
      dataSource: [
        {
          "display": "Is Deceased",
          "value": "Is Deceased",
        },
        {
          "display": "Is Diabetic",
          "value": "Is Diabetic",
        },
        {
          "display": "Is Alcoholic",
          "value": "Is Alcoholic",
        },
        {
          "display": "HIV Positive",
          "value": "SHIV Positive",
        },
        {
          "display": "Is Any Major Surgeries in last 1 year",
          "value": "Is Any Major Surgeries in last 1 year",
        }
      ],
      textField: 'display',
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      // required: true,
      hintText: 'Please choose one or more',
      value: _myActivities,
      onSaved: (value) {
        if (value == null) return;
        setState(() {
          _myActivities = value;
        });
      },
    );
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: _showTitle,
        confirm: Text('custom Done', style: TextStyle(color: Colors.red)),
        cancel: Text('custom cancel', style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.now(),
      // maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  void _getProfileinfo() async {
    LocalData pref = new LocalData();
    await pref.getStringValueSF(LocalData.USER_ID).then((userid) {
      pref.getStringValueSF(LocalData.accessToken).then((token) async {
        print('::: _getprofile :::: TOken : ' + token);

        if (token != null) {
          Response res = await get(baseUrl + getProfileComponentUrl + userid,
              headers: {'authorization': token});

          int statusCode = res.statusCode;
          String responseBody = res.body;

          if (statusCode == 200) {
            setState(() {
              profiledata = json.decode(responseBody);
            });

            print('::: _getprofile :::: error : 200  res :' +
                profiledata.toString());
          } else if (statusCode == 401) {
            print('::: _getprofile :::: error : 401');

            return null;
          } else {
            return null;
          }
        } else {
          print('::: _getprofile :::: error(null Token Error) : 401');
          return null;
        }
      });
    });
  }

  Future<Void> getbloodgroups() async {
    List<BloodGrop> bloodGroups = new List<BloodGrop>();
    Response res = await get(baseUrl + getbloodgroupsUrl);

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

      // setstate
      setState(() {
        _bloodGroups = bloodGroups;
      });
      // return bloodGroups;
    } else {
      return null;
    }
  }

Future<Void> _postUserData(String _userid, String _token) async {
    final uri = baseUrl +updateProfileComponentUrl ;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _token
    };

 
  var updateprofileEntity =   {
  "id": 16,
  "userId": _userid,
  "firstName": null,
  "midddleName": null,
  "lastName": null,
  "mobileNumber": null,
  "email": emailControler.text,
  "fullName": fullnameControler.text,
  "addressId": villagelistselected.id,
  "genderTypeId": null,
  "dob": null,
  "bloodGroupTypeId": null,
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
  }
 
  Future<void> getprofile(String profileid) async {
    Response res = await get(baseUrl + getProfileComponentUrl+'/'+profileid);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

       print('Result :'+parsedMAP.toString());
       
    } else {
      return null;
    }
  }

}

_fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
