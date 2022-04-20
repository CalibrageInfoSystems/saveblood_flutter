import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/models/bloodgroup_model.dart';
import 'package:flutter_logindemo/ui/models/states_model.dart';
import 'package:flutter_logindemo/utils/validator.dart';


import '../../utils/localdata.dart';
import '../constants.dart';
import 'api_data_methods.dart';


class ProfileScreenNew extends StatefulWidget {
  @override
  _ProfileScreenNewState createState() => _ProfileScreenNewState();
}

class _ProfileScreenNewState extends State<ProfileScreenNew> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKeyBasicDetails = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyAddress = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyContact1 = GlobalKey<FormState>();
  bool _autoValidateBasicDetails = false;
  // ------------------- FocusNode -------------------------
  final focusMobile = FocusNode();
  final focusEmail = FocusNode();
  final focusnodeDropdown = FocusNode();
  final focusHeight = FocusNode();
  final focusWeight = FocusNode();
  final focusAddress1 = FocusNode();
  final focusAddress2 = FocusNode();
  final focusnodeBloodGroup = FocusNode();
  final focusDropDownStates = FocusNode();
  final focusDropDownDists = FocusNode();
  final focusDropDownMandals = FocusNode();
  final focusDropDownVillage = FocusNode();
  final focusContact1 = FocusNode();
  final focusContactName1 = FocusNode();
  final focusContactRelation = FocusNode();

  final fullnamecontroller = TextEditingController;
//-------------------- Controlser ---------------------------
  var _currencies = ["Male", "Female"];
  ProfileData profileapi = new ProfileData();
  LocalData localData =new LocalData();

  List<BloodGrop> _bloodGroups = new List<BloodGrop>();
  BloodGrop blooddropdownValue;
  List<AddressItemModel> _statesList = new List<AddressItemModel>();
  AddressItemModel selectedState;
  List<AddressItemModel> _distsList = new List<AddressItemModel>();
  AddressItemModel selecteddist;
  List<AddressItemModel> _mandalsList = new List<AddressItemModel>();
  AddressItemModel selectemandal;
  List<AddressItemModel> _villagesList = new List<AddressItemModel>();
  AddressItemModel selectevillage;
  String _username,
      _mobileNumber,
      _email,
      selectedSalutation,
      _address1,
      _address2,
      _hint,
      _contact1,
      _contactname1,
      _relation1,
      _contact2,
      _contactname2,
      _relation2;
 int _userIDFROMAPI;   

 String fullname,mobilenumber,email;  
      

  LocalData pref = new LocalData();
  Map<String,dynamic> profileresponce;
  TextEditingController fullnamecontoler = new TextEditingController();
  TextEditingController mobilenumbercontoler = new TextEditingController();
  TextEditingController emailcontoler = new TextEditingController();

  TextEditingController dobcontoler = new TextEditingController();
  TextEditingController heightcontoler = new TextEditingController();
  TextEditingController weghtcontoler = new TextEditingController();
  TextEditingController address1contoler = new TextEditingController();
  TextEditingController address2contoler = new TextEditingController();

  var _isDeceased= false;
  var _isDiabetic= false;
  var _isAlcoholic= false;
  var _ishivpositive= false;
  var _isMajorSurgery =false;
  
  @override
  Future<void> initState()  {
    super.initState();
    
    selectedSalutation = _currencies[0];
    _hint = 'select blood group';
    profileapi.getbloodgroups().then((bloodgropslist) {
      setState(() {
        _bloodGroups = bloodgropslist;
     
      });
    });
    selectedState = null;
    profileapi.getstates().then((stateslist) {
      setState(() {
        _statesList = stateslist;
        
      });
    });

    getUserdata(); 
   
  _isDeceased= true;
  _isDiabetic= false;
  _isAlcoholic= true;
  _ishivpositive= false;
  _isMajorSurgery =true;
          
  }

  Future getUserdata() async {
     await pref.getStringValueSF(LocalData.USER_ID).then((userid) async {
      print('user id :'+ userid);
    await  pref.getStringValueSF(LocalData.accessToken).then((accessTOken) async {
      print('Token :'+accessTOken);
    
     await  profileapi.getProfileinfo(userid,accessTOken).then((profile) async {
         profileresponce = profile;
         if(profileresponce['statusCode'] == null)
         {
           profileresponce = profile;
            var addressmap =profileresponce['address'];
             
             
            _userIDFROMAPI = profile['id'];
             fullnamecontoler.text = profile['fullName'];
             mobilenumbercontoler.text= profile['mobileNumber'];
             emailcontoler.text = profile['email'];
             address1contoler.text = addressmap['address1'] ;
             address2contoler.text = addressmap['address2'];
             heightcontoler.text = profile['height'] == null ? 00 : profile['height'];
             weghtcontoler.text = profile['weight'];
            _isDiabetic =profile['isDiabetic'] == null ? false :profile['isDiabetic'];
            _isAlcoholic =profile['isAlcohalic'] == null ? false :profile['isAlcohalic'];
            _isDiabetic =profile['diseased'] == null ? false :profile['diseased'];
            _ishivpositive =profile['hivPositive'] == null ? false :profile['hivPositive'];//isAnyMajorSurgeries
            _isMajorSurgery =profile['isAnyMajorSurgeries'] == null ? false :profile['isAnyMajorSurgeries'];

      
             
            
             
             Scaffold.of(context)
             .showSnackBar(SnackBar(content: Text('Profile data available')));
            
         }else{
             print('API RESPONCE VALUE : NULL DATA COMMING....');
             await localData.addBoolToSF(LocalData.isLogin, true);
             Navigator.of(context).pushNamed(Constants.PROFILE_screen);
               Scaffold.of(context)
             .showSnackBar(SnackBar(content: Text('Please Check Your Internet Connection')));
         }
       });
    
      });
    
    }
    
    );
  }

  @override
  Widget build(BuildContext context) {
    fullname = 'mahesh';
    mobilenumber =_mobileNumber;
    email = _email;
        
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('appbar'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _userBasicDetailsForm(),
             Divider(),
            _addressForm(),
            Divider(),
            _contactForm(),
            Divider(),
            _contactForm2(),
            RaisedButton(
              child: Text('Validate'),
              onPressed: () {
               
              
                 
                final form = _formKeyBasicDetails.currentState;
                final formaddress = _formKeyAddress.currentState;
                final formContact = _formKeyContact1.currentState;
                if (form.validate() && formaddress.validate() && formContact.validate()) {
                  form.save();
                  print('Fullname :' + _username);
                  print('Mobile Number :' + _mobileNumber);
                  print('Email :' + _email);
                  print('Gender :'+ selectedSalutation);
                  print('BloodGroup :'+ blooddropdownValue.name);
                  print('Address 1:'+ _address1);
                  print('address 2:'+_address2);
                  print('State :' + selectedState.name);
                  print('dist :'+ selecteddist.name);
                  print('mandal :'+ selectemandal.name);
                  print('village :'+ selectevillage.name);
                  print('contact 1 :'+ _contactname1);
                  print('name1 :'+ _contactname1);
                  print('relation 1 :'+_relation1);
                  print('Contact 2 :'+_contactname2);
                  print('Name 2 :'+_contactname2);
                  print('Relation 2'+ _relation2);

                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _userBasicDetailsForm() {
    return Form(
      key: _formKeyBasicDetails,
      autovalidate: _autoValidateBasicDetails,
      child: Column(
        children: <Widget>[
          TextFormField(
          controller: fullnamecontoler,
          
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            autofocus: true,
            decoration:
                InputDecoration(labelText: "Full Name *", border: border),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusMobile);
            },
            validator: (value) => Validator.validateemptyString(value),
            onSaved: (val) => _username = val,
          ),
          Divider(),
          TextFormField(
           controller: mobilenumbercontoler,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            focusNode: focusMobile,
            decoration:
                InputDecoration(labelText: "Mobile Number *", border: border),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusEmail);
            },
            validator: (value) => Validator.validateMobile(value),
            onSaved: (val) => _mobileNumber = val,
          ),
          Divider(),
          TextFormField(
            controller: emailcontoler,
            keyboardType: TextInputType.emailAddress,
            focusNode: focusEmail,
            textInputAction: TextInputAction.next,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Email *",
              border: border,
            ),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusnodeDropdown);
            },
            validator: (value) => Validator.validateEmail(value),
            onSaved: (val) => _email = val,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: _genderdropdown(),
              ),
              Text(' '),
              Expanded(
                child: _bloodgroupdropdown(),
              )
            ],
          ),
          _disesinfo(),
        ],
      ),
    );
  }

  Widget _bloodgroupdropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Blood Group *",
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BloodGrop>(
              
              hint: Text('Please Select'),
              focusNode: focusnodeBloodGroup,
              value: blooddropdownValue,
              isDense: true,
              onChanged: (BloodGrop newValue) {
                setState(() {
                  blooddropdownValue = newValue;
                  FocusScope.of(context).requestFocus(focusAddress1);
                });
              },
              items: _bloodGroups.map((BloodGrop value) {
                return DropdownMenuItem<BloodGrop>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _genderdropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Gender *",
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text('Please Select '),
              focusNode: focusnodeDropdown,
              value: selectedSalutation,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  selectedSalutation = newValue;
                  FocusScope.of(context).requestFocus(focusAddress1);
                });
              },
              items: _currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  
Widget _addressForm() {
    return Form(
      key: _formKeyAddress,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
              ),
            ]),
        child: ExpansionTile(
          title: Text('Address Form *'),
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5.0),
                    TextFormField(
                      controller: address1contoler,
                      keyboardType: TextInputType.text,
                      focusNode: focusAddress1,
                     // initialValue: _address1,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Address 1 *",
                        border: border,
                      ),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusAddress2);
                      },
                      validator: (value) =>
                          Validator.validateemptyString(value),
                      onSaved: (val) => _address1 = val,
                    ),
                    Divider(),
                    TextFormField(
                      controller: address2contoler,
                     // initialValue: _address2,
                      keyboardType: TextInputType.text,
                      focusNode: focusAddress2,
                      textInputAction: TextInputAction.done,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: "Address 2 (Optional)",
                        border: border,
                      ),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(focusDropDownStates);
                      },
                      onSaved: (val) => _address2 = val,
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _statesropdown(),
                        ),
                        Text(' '),
                        Expanded(
                          child: _distsropdown(),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _mandaldropdown(),
                        ),
                        Text(' '),
                        Expanded(
                          child: _villagedopdown(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 Widget _disesinfo(){
   return Column(children: <Widget>[
Row(children: <Widget>[
  Expanded(child: CheckboxListTile(value: _isDeceased,onChanged: (bool newValue) {
    setState(() {
      _isDeceased = newValue;
    });
  },
  title: Text('Is Deceased'),
),),
 Expanded(child: CheckboxListTile(value: _isDiabetic,onChanged: (bool newValue) {
    setState(() {
      _isDiabetic = newValue;
    });
  },
  title: Text('Is Diabetic'),
),)

],),
Row(children: <Widget>[
  Expanded(child: CheckboxListTile(value: _isAlcoholic,onChanged: (bool newValue) {
    setState(() {
      _isAlcoholic = newValue;
    });
  },
  title: Text('Is Alcoholic'),
),),
 Expanded(child: CheckboxListTile(value: _ishivpositive,onChanged: (bool newValue) {
    setState(() {
      _ishivpositive = newValue;
    });
  },
  title: Text('HIV Positive'),
),)

],),
CheckboxListTile(value: _isMajorSurgery,onChanged: (bool newValue) {
    setState(() {
      _isMajorSurgery = newValue;
    });
  },
  title: Text('Is Any Major Surgeries in last 1 year'),
),

Row(children: <Widget>[
  Expanded(child:  TextFormField(
            controller: heightcontoler,
            keyboardType: TextInputType.number,
            focusNode: focusHeight,
            textInputAction: TextInputAction.next,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Height ",
              border: border,
            ),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusWeight);
            },
            validator: (value) => Validator.validateemptyString(value),
            onSaved: (val) => _email = val,
          ),),
Text(' '),
          Expanded(child:  TextFormField(
            controller:weghtcontoler ,
            keyboardType: TextInputType.number,
            focusNode: focusWeight,
            textInputAction: TextInputAction.next,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Weight ",
              border: border,
            ),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(focusnodeDropdown);
            },
            validator: (value) => Validator.validateemptyString(value),
            onSaved: (val) => _email = val,
          ),)
],)
],);
 }
  Widget _statesropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "State *",
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              hint: Text('Please Select'),
              focusNode: focusDropDownStates,
              value: selectedState,
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                selecteddist = null;
                selectemandal = null;
                selectevillage = null;
                setState(() {
                  selectedState = newValue;
                  FocusScope.of(context).requestFocus(focusDropDownDists);
                });
                profileapi.getDistsbystateid(newValue.id).then((dist) {
                  setState(() {
                    _distsList = dist;
                  });
                });
              },
              items: _statesList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _distsropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "district *",
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              hint: Text('Please Select '),
              focusNode: focusDropDownDists,
              value: selecteddist,
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                selectemandal = null;
                selectevillage = null;
                setState(() {
                  selecteddist = newValue;
                  FocusScope.of(context).requestFocus(focusDropDownMandals);
                });
                profileapi.getMandalsbyDistid(selecteddist.id).then((mandals) {
                  setState(() {
                    _mandalsList = mandals;
                  });
                });
              },
              items: _distsList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _mandaldropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Madal *",
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              hint: Text('Please Select '),
              focusNode: focusDropDownMandals,
              value: selectemandal,
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                selectevillage = null;
                setState(() {
                  selectemandal = newValue;
                  FocusScope.of(context).requestFocus(focusDropDownVillage);
                });

                profileapi.getvillaagebyMandalid(newValue.id).then((villages) {
                  setState(() {
                    _villagesList = villages;
                  });
                });
              },
              items: _mandalsList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _villagedopdown() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Village *",
            border: border,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AddressItemModel>(
              
              hint: Text('Please Select '),
              focusNode: focusDropDownVillage,
              value: selectevillage,
              isDense: true,
              onChanged: (AddressItemModel newValue) {
                setState(() {
                  selectevillage = newValue;
                  FocusScope.of(context).requestFocus(focusContact1);
                });
              },
              
              items: _villagesList.map((AddressItemModel value) {
                return DropdownMenuItem<AddressItemModel>(
                  value: value,
                  child: Container(
                    child: Text(value.name),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _contactForm() {
    return Form(
      key: _formKeyContact1,
      autovalidate: _autoValidateBasicDetails,
      
      child: Column(
        children: <Widget>[
             Container(
                decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5.0,
              ),
            ]),
               child: ExpansionTile(
                title: Text('emergency contact 1 *'),
                children: <Widget>[
                
                Material(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                child: Column(
                  children: <Widget>[
                  SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: _contact1,
                    focusNode: focusContact1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Contact Number *", border: border),
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focusContactName1);
                    },
                    validator: (value) => Validator.validateMobile(value),
                    onSaved: (val) => _contact1 = val,
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: _contactname2,
                    focusNode: focusContactName1, 
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration:
                        InputDecoration(labelText: "Name *", border: border),
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focusContactRelation);
                    },
                    validator: (value) => Validator.validateMobile(value),
                    onSaved: (val) => _contactname1 = val,
                  ),
                  SizedBox(height: 5.0),
                  TextFormField(
                    initialValue: _relation1,
                    focusNode: focusContactRelation,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration:
                        InputDecoration(labelText: "Relation *", border: border),
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focusMobile);
                    },
                    validator: (value) => Validator.validateMobile(value),
                    onSaved: (val) => _relation1 = val,
                  ),
                   ],
                ),
              ),
            ),
                ]
                ,),
             )
        
        ]));   
  }
  Widget _contactForm2() {
    return Form(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 5.0,
                  ),
                ]),
            child: ExpansionTile(
              title: Text('emergency contact 2 (Optional)'),
              children: <Widget>[
                TextFormField(
                  initialValue: _contact2,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Contact Number", border: border),
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focusMobile);
                  },
                  validator: (value) => Validator.validateMobile(value),
                  onSaved: (val) => _contact2 = val,
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  initialValue: _contactname2,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration:
                      InputDecoration(labelText: "Name ", border: border),
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focusMobile);
                  },
                  validator: (value) => Validator.validateMobile(value),
                  onSaved: (val) => _contactname2 = val,
                ),
                SizedBox(height: 5.0),
                TextFormField(
                  initialValue: _relation2,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration:
                      InputDecoration(labelText: "Relation ", border: border),
                  onFieldSubmitted: (v) {
                    FocusScope.of(context).requestFocus(focusMobile);
                  },
                  validator: (value) => Validator.validateMobile(value),
                  onSaved: (val) => _relation2 = val,
                ),
              ],
            )));
  }

  var border = OutlineInputBorder(
    borderRadius: new BorderRadius.circular(10.0),
    borderSide: new BorderSide(),
  );
}
